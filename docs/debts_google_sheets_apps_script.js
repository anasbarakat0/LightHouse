const TOKEN = '';
const SPREADSHEET_ID = '';
const ACCOUNTS_SHEET = 'debt_accounts';
const TRANSACTIONS_SHEET = 'debt_transactions';

function doGet() {
  return jsonResponse({
    ok: true,
    message: 'LightHouse debt sync is running',
  });
}

function doPost(e) {
  try {
    if (!e || !e.postData || !e.postData.contents) {
      return jsonResponse({
        ok: false,
        message: 'No POST body received. Use testUpsertAccount() inside Apps Script, or call the deployed Web App URL from the app.',
      });
    }

    const body = JSON.parse(e.postData.contents || '{}');

    if (TOKEN && body.token !== TOKEN) {
      return jsonResponse({ ok: false, message: 'Unauthorized' });
    }

    const spreadsheet = getSpreadsheet();

    if (body.action === 'upsertAccount') {
      upsertAccount(spreadsheet, body.payload || {});
      return jsonResponse({ ok: true });
    }

    if (body.action === 'addTransaction') {
      addTransaction(spreadsheet, body.payload || {});
      return jsonResponse({ ok: true });
    }

    if (body.action === 'getAll') {
      return jsonResponse({
        ok: true,
        data: getAllDebtData(spreadsheet),
      });
    }

    return jsonResponse({
      ok: false,
      message: `Unknown action: ${body.action || ''}`,
    });
  } catch (error) {
    console.error(error && error.stack ? error.stack : error);
    return jsonResponse({
      ok: false,
      message: error && error.message ? error.message : String(error),
    });
  }
}

function setupDebtSheets() {
  const spreadsheet = getSpreadsheet();
  getOrCreateSheet(spreadsheet, ACCOUNTS_SHEET, accountHeaders());
  getOrCreateSheet(spreadsheet, TRANSACTIONS_SHEET, transactionHeaders());
  return jsonResponse({ ok: true, message: 'Debt sheets are ready' });
}

function testUpsertAccount() {
  const result = doPost({
    postData: {
      contents: JSON.stringify({
        token: TOKEN,
        action: 'upsertAccount',
        payload: {
          id: 'test_account_1',
          clientId: 'test_client_1',
          firstName: 'Test',
          lastName: 'Client',
          phoneNumber: '0999999999',
          createdAt: new Date().toISOString(),
          createdBy: 'apps_script_test',
          syncedAt: new Date().toISOString(),
          archived: false,
        },
      }),
    },
  });
  Logger.log(result.getContent());
}

function testAddTransaction() {
  const result = doPost({
    postData: {
      contents: JSON.stringify({
        token: TOKEN,
        action: 'addTransaction',
        payload: {
          id: `test_transaction_${Date.now()}`,
          accountId: 'test_account_1',
          type: 'debt',
          amount: 1000,
          note: 'Apps Script test',
          createdAt: new Date().toISOString(),
          createdBy: 'apps_script_test',
          syncedAt: new Date().toISOString(),
        },
      }),
    },
  });
  Logger.log(result.getContent());
}

function testGetAll() {
  const result = doPost({
    postData: {
      contents: JSON.stringify({
        token: TOKEN,
        action: 'getAll',
        payload: {},
      }),
    },
  });
  Logger.log(result.getContent());
}

function getSpreadsheet() {
  if (SPREADSHEET_ID) {
    return SpreadsheetApp.openById(SPREADSHEET_ID);
  }

  const spreadsheet = SpreadsheetApp.getActiveSpreadsheet();

  if (!spreadsheet) {
    throw new Error('No active spreadsheet found. Open this script from Extensions > Apps Script inside the target Google Sheet, or set SPREADSHEET_ID.');
  }

  return spreadsheet;
}

function upsertAccount(spreadsheet, account) {
  requireFields(account, ['id', 'clientId']);

  const sheet = getOrCreateSheet(spreadsheet, ACCOUNTS_SHEET, accountHeaders());
  const rows = sheet.getDataRange().getValues();
  const rowIndex = rows.findIndex((row, index) => index > 0 && row[0] === account.id);
  const row = [
    account.id,
    account.clientId,
    account.firstName || '',
    account.lastName || '',
    account.phoneNumber || '',
    account.createdAt || new Date().toISOString(),
    account.createdBy || '',
    account.syncedAt || new Date().toISOString(),
    account.archived || false,
  ];

  if (rowIndex === -1) {
    sheet.appendRow(row);
    return;
  }

  sheet.getRange(rowIndex + 1, 1, 1, row.length).setValues([row]);
}

function addTransaction(spreadsheet, transaction) {
  requireFields(transaction, ['id', 'accountId', 'type', 'amount']);

  const sheet = getOrCreateSheet(
    spreadsheet,
    TRANSACTIONS_SHEET,
    transactionHeaders()
  );
  const rows = sheet.getDataRange().getValues();
  const exists = rows.some(
    (row, index) => index > 0 && row[0] === transaction.id
  );

  if (exists) {
    return;
  }

  sheet.appendRow([
    transaction.id,
    transaction.accountId,
    transaction.type,
    transaction.amount,
    transaction.note || '',
    transaction.createdAt || new Date().toISOString(),
    transaction.createdBy || '',
    transaction.syncedAt || new Date().toISOString(),
  ]);
}

function getAllDebtData(spreadsheet) {
  return {
    accounts: readSheetObjects(
      getOrCreateSheet(spreadsheet, ACCOUNTS_SHEET, accountHeaders())
    ),
    transactions: readSheetObjects(
      getOrCreateSheet(spreadsheet, TRANSACTIONS_SHEET, transactionHeaders())
    ),
  };
}

function readSheetObjects(sheet) {
  const values = sheet.getDataRange().getValues();

  if (values.length <= 1) {
    return [];
  }

  const headers = values[0];

  return values.slice(1)
    .filter((row) => row.some((cell) => cell !== '' && cell !== null))
    .map((row) => {
      const item = {};

      headers.forEach((header, index) => {
        const value = row[index];
        item[header] = value instanceof Date ? value.toISOString() : value;
      });

      return item;
    });
}

function getOrCreateSheet(spreadsheet, name, headers) {
  const sheet = spreadsheet.getSheetByName(name) || spreadsheet.insertSheet(name);

  if (sheet.getLastRow() === 0) {
    sheet.appendRow(headers);
  }

  return sheet;
}

function requireFields(payload, fields) {
  const missing = fields.filter((field) => payload[field] === undefined || payload[field] === null || payload[field] === '');

  if (missing.length) {
    throw new Error(`Missing required fields: ${missing.join(', ')}`);
  }
}

function accountHeaders() {
  return [
    'id',
    'clientId',
    'firstName',
    'lastName',
    'phoneNumber',
    'createdAt',
    'createdBy',
    'syncedAt',
    'archived',
  ];
}

function transactionHeaders() {
  return [
    'id',
    'accountId',
    'type',
    'amount',
    'note',
    'createdAt',
    'createdBy',
    'syncedAt',
  ];
}

function jsonResponse(payload) {
  return ContentService
    .createTextOutput(JSON.stringify(payload))
    .setMimeType(ContentService.MimeType.JSON);
}
