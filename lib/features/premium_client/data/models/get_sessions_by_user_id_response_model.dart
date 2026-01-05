// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';

class GetSessionsByUserIdResponseModel {
  final String message;
  final String status;
  final String localDateTime;
  final SessionsBody body;
  GetSessionsByUserIdResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  GetSessionsByUserIdResponseModel copyWith({
    String? message,
    String? status,
    String? localDateTime,
    SessionsBody? body,
  }) {
    return GetSessionsByUserIdResponseModel(
      message: message ?? this.message,
      status: status ?? this.status,
      localDateTime: localDateTime ?? this.localDateTime,
      body: body ?? this.body,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'status': status,
      'localDateTime': localDateTime,
      'body': body.toMap(),
    };
  }

  factory GetSessionsByUserIdResponseModel.fromMap(Map<String, dynamic> map) {
    return GetSessionsByUserIdResponseModel(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: SessionsBody.fromMap(map['body'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetSessionsByUserIdResponseModel.fromJson(String source) =>
      GetSessionsByUserIdResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'GetSessionsByUserIdResponseModel(message: $message, status: $status, localDateTime: $localDateTime, body: $body)';

  @override
  bool operator ==(covariant GetSessionsByUserIdResponseModel other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.status == status &&
        other.localDateTime == localDateTime &&
        other.body == body;
  }

  @override
  int get hashCode {
    return message.hashCode ^
        status.hashCode ^
        localDateTime.hashCode ^
        body.hashCode;
  }
}

class SessionsBody {
  final PaginationResponse paginationResponse;
  final List<SessionItem> sessions;
  SessionsBody({
    required this.paginationResponse,
    required this.sessions,
  });

  SessionsBody copyWith({
    PaginationResponse? paginationResponse,
    List<SessionItem>? sessions,
  }) {
    return SessionsBody(
      paginationResponse: paginationResponse ?? this.paginationResponse,
      sessions: sessions ?? this.sessions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'paginationResponse': paginationResponse.toMap(),
      'sessions': sessions.map((x) => x.toMap()).toList(),
    };
  }

  factory SessionsBody.fromMap(Map<String, dynamic> map) {
    // Support both old and new response formats
    // New format: premiumSessionList and pagination
    // Old format: sessions and paginationResponse
    final paginationMap = map['pagination'] ?? map['paginationResponse'];
    final sessionsList = map['premiumSessionList'] ?? map['sessions'];
    
    return SessionsBody(
      paginationResponse: PaginationResponse.fromMap(
          paginationMap as Map<String, dynamic>),
      sessions: List<SessionItem>.from(
        (sessionsList as List<dynamic>)
            .map((x) => SessionItem.fromMap(x as Map<String, dynamic>)),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SessionsBody.fromJson(String source) =>
      SessionsBody.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SessionsBody(paginationResponse: $paginationResponse, sessions: $sessions)';

  @override
  bool operator ==(covariant SessionsBody other) {
    if (identical(this, other)) return true;

    return other.paginationResponse == paginationResponse &&
        listEquals(other.sessions, sessions);
  }

  @override
  int get hashCode => paginationResponse.hashCode ^ sessions.hashCode;
}

class PaginationResponse {
  final int page;
  final int perPage;
  final int total;
  PaginationResponse({
    required this.page,
    required this.perPage,
    required this.total,
  });

  PaginationResponse copyWith({
    int? page,
    int? perPage,
    int? total,
  }) {
    return PaginationResponse(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'page': page,
      'perPage': perPage,
      'total': total,
    };
  }

  factory PaginationResponse.fromMap(Map<String, dynamic> map) {
    return PaginationResponse(
      page: map['page'] as int,
      perPage: map['perPage'] as int,
      total: map['total'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaginationResponse.fromJson(String source) =>
      PaginationResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PaginationResponse(page: $page, perPage: $perPage, total: $total)';

  @override
  bool operator ==(covariant PaginationResponse other) {
    if (identical(this, other)) return true;

    return other.page == page &&
        other.perPage == perPage &&
        other.total == total;
  }

  @override
  int get hashCode => page.hashCode ^ perPage.hashCode ^ total.hashCode;
}

class SessionItem {
  final String id;
  final String date;
  final String startTime;
  final String qrCode;
  final CreatedBy createdBy;
  final String userId;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final dynamic endTime;
  final dynamic sessionInvoice;
  final double buffetInvoicePrice;
  final List<BuffetInvoice> buffetInvoices;
  final dynamic totalPrice;
  final bool active;
  final String? sessionType; // 'premium'
  SessionItem({
    required this.id,
    required this.date,
    required this.startTime,
    required this.qrCode,
    required this.createdBy,
    required this.userId,
    this.firstName,
    this.lastName,
    this.fullName,
    required this.endTime,
    required this.sessionInvoice,
    required this.buffetInvoicePrice,
    required this.buffetInvoices,
    required this.totalPrice,
    required this.active,
    this.sessionType,
  });

  SessionItem copyWith({
    String? id,
    String? date,
    String? startTime,
    String? qrCode,
    CreatedBy? createdBy,
    String? userId,
    String? firstName,
    String? lastName,
    String? fullName,
    dynamic endTime,
    dynamic sessionInvoice,
    double? buffetInvoicePrice,
    List<BuffetInvoice>? buffetInvoices,
    dynamic totalPrice,
    bool? active,
    String? sessionType,
  }) {
    return SessionItem(
      id: id ?? this.id,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      qrCode: qrCode ?? this.qrCode,
      createdBy: createdBy ?? this.createdBy,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? this.fullName,
      endTime: endTime ?? this.endTime,
      sessionInvoice: sessionInvoice ?? this.sessionInvoice,
      buffetInvoicePrice: buffetInvoicePrice ?? this.buffetInvoicePrice,
      buffetInvoices: buffetInvoices ?? this.buffetInvoices,
      totalPrice: totalPrice ?? this.totalPrice,
      active: active ?? this.active,
      sessionType: sessionType ?? this.sessionType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date,
      'startTime': startTime,
      'qrCode': qrCode,
      'createdBy': createdBy.toMap(),
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'endTime': endTime,
      'sessionInvoice': sessionInvoice,
      'buffetInvoicePrice': buffetInvoicePrice,
      'buffetInvoices': buffetInvoices.map((x) => x.toMap()).toList(),
      'totalPrice': totalPrice,
      'active': active,
      'sessionType': sessionType,
    };
  }

  factory SessionItem.fromMap(Map<String, dynamic> map) {
    // All sessions are premium now
    String? sessionType = 'premium';

    return SessionItem(
      id: map['id'] as String? ?? '',
      date: map['date'] as String? ?? '',
      startTime: map['startTime'] as String? ?? '',
      qrCode: map['qrCode'] as String? ?? '',
      createdBy: CreatedBy.fromMap(map['createdBy'] as Map<String, dynamic>),
      userId: map['userId'] as String? ?? '',
      firstName: map['firstName'] as String?,
      lastName: map['lastName'] as String?,
      fullName: map['fullName'] as String?,
      endTime: map['endTime'],
      sessionInvoice: map['sessionInvoice'],
      buffetInvoicePrice: (map['buffetInvoicePrice'] is double)
          ? map['buffetInvoicePrice']
          : (map['buffetInvoicePrice'] as num?)?.toDouble() ?? 0.0,
      buffetInvoices: (map['buffetInvoices'] as List<dynamic>?)
              ?.map((invoice) =>
                  BuffetInvoice.fromMap(invoice as Map<String, dynamic>))
              .toList() ??
          [],
      totalPrice: map['totalPrice'],
      active: map['active'] as bool? ?? false,
      sessionType: sessionType,
    );
  }

  String toJson() => json.encode(toMap());

  factory SessionItem.fromJson(String source) =>
      SessionItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SessionItem(id: $id, date: $date, startTime: $startTime, qrCode: $qrCode, createdBy: $createdBy, userId: $userId, firstName: $firstName, lastName: $lastName, fullName: $fullName, endTime: $endTime, sessionInvoice: $sessionInvoice, buffetInvoicePrice: $buffetInvoicePrice, buffetInvoices: $buffetInvoices, totalPrice: $totalPrice, active: $active, sessionType: $sessionType)';
  }

  @override
  bool operator ==(covariant SessionItem other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.date == date &&
        other.startTime == startTime &&
        other.qrCode == qrCode &&
        other.createdBy == createdBy &&
        other.userId == userId &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.fullName == fullName &&
        other.endTime == endTime &&
        other.sessionInvoice == sessionInvoice &&
        other.buffetInvoicePrice == buffetInvoicePrice &&
        listEquals(other.buffetInvoices, buffetInvoices) &&
        other.totalPrice == totalPrice &&
        other.active == active &&
        other.sessionType == sessionType;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        date.hashCode ^
        startTime.hashCode ^
        qrCode.hashCode ^
        createdBy.hashCode ^
        userId.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        fullName.hashCode ^
        endTime.hashCode ^
        sessionInvoice.hashCode ^
        buffetInvoicePrice.hashCode ^
        buffetInvoices.hashCode ^
        totalPrice.hashCode ^
        active.hashCode ^
        sessionType.hashCode;
  }
}

class CreatedBy {
  final String id;
  final String firstName;
  final String lastName;
  final String? email;
  final String role;
  CreatedBy({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    required this.role,
  });

  CreatedBy copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? role,
  }) {
    return CreatedBy(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role,
    };
  }

  factory CreatedBy.fromMap(Map<String, dynamic> map) {
    return CreatedBy(
      id: map['id'] as String? ?? '',
      firstName: map['firstName'] as String? ?? '',
      lastName: map['lastName'] as String? ?? '',
      email: map['email'] as String?,
      role: map['role'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CreatedBy.fromJson(String source) =>
      CreatedBy.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CreatedBy(id: $id, firstName: $firstName, lastName: $lastName, email: $email, role: $role)';
  }

  @override
  bool operator ==(covariant CreatedBy other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.role == role;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        (email?.hashCode ?? 0) ^
        role.hashCode;
  }
}

class BuffetInvoice {
  final String id;
  final String invoiceDate;
  final String invoiceTime;
  final String sessionId;
  final List<Order> orders;
  final double totalPrice;
  BuffetInvoice({
    required this.id,
    required this.invoiceDate,
    required this.invoiceTime,
    required this.sessionId,
    required this.orders,
    required this.totalPrice,
  });

  BuffetInvoice copyWith({
    String? id,
    String? invoiceDate,
    String? invoiceTime,
    String? sessionId,
    List<Order>? orders,
    double? totalPrice,
  }) {
    return BuffetInvoice(
      id: id ?? this.id,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      invoiceTime: invoiceTime ?? this.invoiceTime,
      sessionId: sessionId ?? this.sessionId,
      orders: orders ?? this.orders,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'invoiceDate': invoiceDate,
      'invoiceTime': invoiceTime,
      'sessionId': sessionId,
      'orders': orders.map((x) => x.toMap()).toList(),
      'totalPrice': totalPrice,
    };
  }

  factory BuffetInvoice.fromMap(Map<String, dynamic> map) {
    return BuffetInvoice(
      id: map['id'] as String? ?? '',
      invoiceDate: map['invoiceDate'] as String? ?? '',
      invoiceTime: map['invoiceTime'] as String? ?? '',
      sessionId: map['sessionId'] as String? ?? '',
      orders: (map['orders'] as List<dynamic>?)
              ?.map((order) => Order.fromMap(order as Map<String, dynamic>))
              .toList() ??
          [],
      totalPrice: (map['totalPrice'] is double)
          ? map['totalPrice']
          : (map['totalPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory BuffetInvoice.fromJson(String source) =>
      BuffetInvoice.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BuffetInvoice(id: $id, invoiceDate: $invoiceDate, invoiceTime: $invoiceTime, sessionId: $sessionId, orders: $orders, totalPrice: $totalPrice)';
  }

  @override
  bool operator ==(covariant BuffetInvoice other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.invoiceDate == invoiceDate &&
        other.invoiceTime == invoiceTime &&
        other.sessionId == sessionId &&
        listEquals(other.orders, orders) &&
        other.totalPrice == totalPrice;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        invoiceDate.hashCode ^
        invoiceTime.hashCode ^
        sessionId.hashCode ^
        orders.hashCode ^
        totalPrice.hashCode;
  }
}

class Order {
  final String id;
  final String productId;
  final String productName;
  final int quantity;
  final double price;
  final String buffetInvoice;
  Order({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.buffetInvoice,
  });

  Order copyWith({
    String? id,
    String? productId,
    String? productName,
    int? quantity,
    double? price,
    String? buffetInvoice,
  }) {
    return Order(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      buffetInvoice: buffetInvoice ?? this.buffetInvoice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'buffetInvoice': buffetInvoice,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String? ?? '',
      productId: map['productId'] as String? ?? '',
      productName: map['productName'] as String? ?? '',
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      buffetInvoice: map['buffetInvoice'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Order(id: $id, productId: $productId, productName: $productName, quantity: $quantity, price: $price, buffetInvoice: $buffetInvoice)';
  }

  @override
  bool operator ==(covariant Order other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.productId == productId &&
        other.productName == productName &&
        other.quantity == quantity &&
        other.price == price &&
        other.buffetInvoice == buffetInvoice;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        productId.hashCode ^
        productName.hashCode ^
        quantity.hashCode ^
        price.hashCode ^
        buffetInvoice.hashCode;
  }
}

