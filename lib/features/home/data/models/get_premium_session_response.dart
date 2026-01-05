// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class GetPremiumSessionResponse {
    final String message;
    final String status;
    final String localDateTime;
    final Body body;
  GetPremiumSessionResponse({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });


  GetPremiumSessionResponse copyWith({
    String? message,
    String? status,
    String? localDateTime,
    Body? body,
  }) {
    return GetPremiumSessionResponse(
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

  factory GetPremiumSessionResponse.fromMap(Map<String, dynamic> map) {
    return GetPremiumSessionResponse(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: Body.fromMap(map['body'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetPremiumSessionResponse.fromJson(String source) => GetPremiumSessionResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GetPremiumSessionResponse(message: $message, status: $status, localDateTime: $localDateTime, body: $body)';
  }

  @override
  bool operator ==(covariant GetPremiumSessionResponse other) {
    if (identical(this, other)) return true;
  
    return 
      other.message == message &&
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

class Body {
    final String id;
    final String date;
    final String startTime;
    final String qrCode;
    final CreatedBy createdBy;
    final String userId;
    final String firstName;
    final String lastName;
    final dynamic endTime;
    final SessionInvoice? sessionInvoice;
    final double buffetInvoicePrice;
    final List<BuffetInvoice> buffetInvoices;
    final dynamic totalPrice;
    final bool active;
    final SummaryInvoiceResponse? summaryInvoice;
  Body({
    required this.id,
    required this.date,
    required this.startTime,
    required this.qrCode,
    required this.createdBy,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.endTime,
    this.sessionInvoice,
    required this.buffetInvoicePrice,
    required this.buffetInvoices,
    required this.totalPrice,
    required this.active,
    this.summaryInvoice,
  });

  Body copyWith({
    String? id,
    String? date,
    String? startTime,
    String? qrCode,
    CreatedBy? createdBy,
    String? userId,
    String? firstName,
    String? lastName,
    dynamic endTime,
    SessionInvoice? sessionInvoice,
    double? buffetInvoicePrice,
    List<BuffetInvoice>? buffetInvoices,
    dynamic totalPrice,
    bool? active,
    SummaryInvoiceResponse? summaryInvoice,
  }) {
    return Body(
      id: id ?? this.id,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      qrCode: qrCode ?? this.qrCode,
      createdBy: createdBy ?? this.createdBy,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      endTime: endTime ?? this.endTime,
      sessionInvoice: sessionInvoice ?? this.sessionInvoice,
      buffetInvoicePrice: buffetInvoicePrice ?? this.buffetInvoicePrice,
      buffetInvoices: buffetInvoices ?? this.buffetInvoices,
      totalPrice: totalPrice ?? this.totalPrice,
      active: active ?? this.active,
      summaryInvoice: summaryInvoice ?? this.summaryInvoice,
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
      'endTime': endTime,
      'sessionInvoice': sessionInvoice?.toMap(),
      'buffetInvoicePrice': buffetInvoicePrice,
      'buffetInvoices': buffetInvoices,
      'totalPrice': totalPrice,
      'active': active,
      'summaryInvoice': summaryInvoice?.toMap(),
    };
  }

  factory Body.fromMap(Map<String, dynamic> map) {
 
  return Body(
    id: map['id'] as String? ?? '',
    date: map['date'] as String? ?? '',
    startTime: map['startTime'] as String? ?? '',
    qrCode: map['qrCode'] as String? ?? '',
    createdBy: CreatedBy.fromMap(map['createdBy'] as Map<String, dynamic>),
    userId: map['userId'] as String? ?? '',
    firstName: map['firstName'] as String? ?? '',
    lastName: map['lastName'] as String? ?? '',
    endTime: map['endTime'],
    sessionInvoice: map['sessionInvoice'] != null
        ? SessionInvoice.fromMap(map['sessionInvoice'] as Map<String, dynamic>)
        : null,
    buffetInvoicePrice: (map['buffetInvoicePrice'] is double)
        ? map['buffetInvoicePrice']
        : (map['buffetInvoicePrice'] as num?)?.toInt() ?? 0,
    buffetInvoices: (map['buffetInvoices'] as List<dynamic>)
        .map((invoice) => BuffetInvoice.fromMap(invoice as Map<String, dynamic>))
        .toList(),
    totalPrice: (map['totalPrice'] is int)
        ? map['totalPrice']
        : (map['totalPrice'] as num?)?.toInt() ?? 0,
    active: map['active'] as bool? ?? false,
    summaryInvoice: map['summaryInvoice'] != null
        ? SummaryInvoiceResponse.fromMap(map['summaryInvoice'] as Map<String, dynamic>)
        : null,
  );
}


  String toJson() => json.encode(toMap());

  factory Body.fromJson(String source) => Body.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Body(id: $id, date: $date, startTime: $startTime, qrCode: $qrCode, createdBy: $createdBy, userId: $userId, firstName: $firstName, lastName: $lastName, endTime: $endTime, sessionInvoice: $sessionInvoice, buffetInvoicePrice: $buffetInvoicePrice, buffetInvoices: $buffetInvoices, totalPrice: $totalPrice, active: $active, summaryInvoice: $summaryInvoice)';
  }

  @override
  bool operator ==(covariant Body other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.date == date &&
      other.startTime == startTime &&
      other.qrCode == qrCode &&
      other.createdBy == createdBy &&
      other.userId == userId &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.endTime == endTime &&
      other.sessionInvoice == sessionInvoice &&
      other.buffetInvoicePrice == buffetInvoicePrice &&
      listEquals(other.buffetInvoices, buffetInvoices) &&
      other.totalPrice == totalPrice &&
      other.active == active &&
      other.summaryInvoice == summaryInvoice;
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
      endTime.hashCode ^
      sessionInvoice.hashCode ^
      buffetInvoicePrice.hashCode ^
      buffetInvoices.hashCode ^
      totalPrice.hashCode ^
      active.hashCode ^
      summaryInvoice.hashCode;
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
    orders: (map['orders'] as List<dynamic>)
        .map((order) => Order.fromMap(order as Map<String, dynamic>))
        .toList(),
    totalPrice: (map['totalPrice'] is double)
        ? map['totalPrice']
        : (map['totalPrice'] as num?)?.toDouble() ?? 0,
  );
}


  String toJson() => json.encode(toMap());

  factory BuffetInvoice.fromJson(String source) => BuffetInvoice.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BuffetInvoice(id: $id, invoiceDate: $invoiceDate, invoiceTime: $invoiceTime, sessionId: $sessionId, orders: $orders, totalPrice: $totalPrice)';
  }

  @override
  bool operator ==(covariant BuffetInvoice other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
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
    price: (map['price'] as num?)?.toDouble() ?? 0,
    buffetInvoice: map['buffetInvoice'] as String? ?? '',
  );
}


  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Order(id: $id, productId: $productId, productName: $productName, quantity: $quantity, price: $price, buffetInvoice: $buffetInvoice)';
  }

  @override
  bool operator ==(covariant Order other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
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

class CreatedBy {
    final String id;
    final String firstName;
    final String lastName;
    final String email;
    final String role;
  CreatedBy({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
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
      id: map['id'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      role: map['role'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreatedBy.fromJson(String source) => CreatedBy.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CreatedBy(id: $id, firstName: $firstName, lastName: $lastName, email: $email, role: $role)';
  }

  @override
  bool operator ==(covariant CreatedBy other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
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
      email.hashCode ^
      role.hashCode;
  }
}

class SessionInvoice {
  final String id;
  final String userType;
  final String session_id;
  final double hoursAmount;
  final double hourlyPrice;
  SessionInvoice({
    required this.id,
    required this.userType,
    required this.session_id,
    required this.hoursAmount,
    required this.hourlyPrice,
  });

  SessionInvoice copyWith({
    String? id,
    String? userType,
    String? session_id,
    double? hoursAmount,
    double? hourlyPrice,
  }) {
    return SessionInvoice(
      id: id ?? this.id,
      userType: userType ?? this.userType,
      session_id: session_id ?? this.session_id,
      hoursAmount: hoursAmount ?? this.hoursAmount,
      hourlyPrice: hourlyPrice ?? this.hourlyPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userType': userType,
      'session_id': session_id,
      'hoursAmount': hoursAmount,
      'hourlyPrice': hourlyPrice,
    };
  }

  factory SessionInvoice.fromMap(Map<String, dynamic> map) {
    // Handle hoursAmount with robust parsing
    double hoursAmountValue = 0.0;
    if (map['hoursAmount'] != null) {
      if (map['hoursAmount'] is double) {
        hoursAmountValue = map['hoursAmount'] as double;
      } else if (map['hoursAmount'] is int) {
        hoursAmountValue = (map['hoursAmount'] as int).toDouble();
      } else if (map['hoursAmount'] is num) {
        hoursAmountValue = (map['hoursAmount'] as num).toDouble();
      } else {
        try {
          hoursAmountValue = double.parse(map['hoursAmount'].toString());
        } catch (e) {
          hoursAmountValue = 0.0;
        }
      }
    }
    
    // Handle hourlyPrice with robust parsing
    double hourlyPriceValue = 0.0;
    if (map['hourlyPrice'] != null) {
      if (map['hourlyPrice'] is double) {
        hourlyPriceValue = map['hourlyPrice'] as double;
      } else if (map['hourlyPrice'] is int) {
        hourlyPriceValue = (map['hourlyPrice'] as int).toDouble();
      } else if (map['hourlyPrice'] is num) {
        hourlyPriceValue = (map['hourlyPrice'] as num).toDouble();
      } else {
        try {
          hourlyPriceValue = double.parse(map['hourlyPrice'].toString());
        } catch (e) {
          hourlyPriceValue = 0.0;
        }
      }
    }
    
    return SessionInvoice(
      id: map['id'] as String? ?? '',
      userType: map['userType'] as String? ?? '',
      session_id: map['session_id'] as String? ?? '',
      hoursAmount: hoursAmountValue,
      hourlyPrice: hourlyPriceValue,
    );
  }

  String toJson() => json.encode(toMap());

  factory SessionInvoice.fromJson(String source) => SessionInvoice.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SessionInvoice(id: $id, userType: $userType, session_id: $session_id, hoursAmount: $hoursAmount, hourlyPrice: $hourlyPrice)';
  }

  @override
  bool operator ==(covariant SessionInvoice other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.userType == userType &&
      other.session_id == session_id &&
      other.hoursAmount == hoursAmount &&
      other.hourlyPrice == hourlyPrice;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userType.hashCode ^
      session_id.hashCode ^
      hoursAmount.hashCode ^
      hourlyPrice.hashCode;
  }
}

class SummaryInvoiceResponse {
  final double buffetInvoicePrice;
  final double sessionInvoicePrice;
  final double? sessionInvoiceBeforeDiscount;
  final double? sessionInvoiceAfterDiscount;
  final double? buffetInvoiceBeforeDiscount;
  final double? buffetInvoiceAfterDiscount;
  final double? discountAmount;
  final String? discountCode;
  final String? discountAppliesTo;
  final double? totalInvoiceBeforeDiscount;
  final double? totalInvoiceAfterDiscount;
  final double? manualDiscountAmount;
  final String? manualDiscountNote;
  final double? finalTotalAfterAllDiscounts;

  SummaryInvoiceResponse({
    required this.buffetInvoicePrice,
    required this.sessionInvoicePrice,
    this.sessionInvoiceBeforeDiscount,
    this.sessionInvoiceAfterDiscount,
    this.buffetInvoiceBeforeDiscount,
    this.buffetInvoiceAfterDiscount,
    this.discountAmount,
    this.discountCode,
    this.discountAppliesTo,
    this.totalInvoiceBeforeDiscount,
    this.totalInvoiceAfterDiscount,
    this.manualDiscountAmount,
    this.manualDiscountNote,
    this.finalTotalAfterAllDiscounts,
  });

  SummaryInvoiceResponse copyWith({
    double? buffetInvoicePrice,
    double? sessionInvoicePrice,
    double? sessionInvoiceBeforeDiscount,
    double? sessionInvoiceAfterDiscount,
    double? buffetInvoiceBeforeDiscount,
    double? buffetInvoiceAfterDiscount,
    double? discountAmount,
    String? discountCode,
    String? discountAppliesTo,
    double? totalInvoiceBeforeDiscount,
    double? totalInvoiceAfterDiscount,
    double? manualDiscountAmount,
    String? manualDiscountNote,
    double? finalTotalAfterAllDiscounts,
  }) {
    return SummaryInvoiceResponse(
      buffetInvoicePrice: buffetInvoicePrice ?? this.buffetInvoicePrice,
      sessionInvoicePrice: sessionInvoicePrice ?? this.sessionInvoicePrice,
      sessionInvoiceBeforeDiscount: sessionInvoiceBeforeDiscount ?? this.sessionInvoiceBeforeDiscount,
      sessionInvoiceAfterDiscount: sessionInvoiceAfterDiscount ?? this.sessionInvoiceAfterDiscount,
      buffetInvoiceBeforeDiscount: buffetInvoiceBeforeDiscount ?? this.buffetInvoiceBeforeDiscount,
      buffetInvoiceAfterDiscount: buffetInvoiceAfterDiscount ?? this.buffetInvoiceAfterDiscount,
      discountAmount: discountAmount ?? this.discountAmount,
      discountCode: discountCode ?? this.discountCode,
      discountAppliesTo: discountAppliesTo ?? this.discountAppliesTo,
      totalInvoiceBeforeDiscount: totalInvoiceBeforeDiscount ?? this.totalInvoiceBeforeDiscount,
      totalInvoiceAfterDiscount: totalInvoiceAfterDiscount ?? this.totalInvoiceAfterDiscount,
      manualDiscountAmount: manualDiscountAmount ?? this.manualDiscountAmount,
      manualDiscountNote: manualDiscountNote ?? this.manualDiscountNote,
      finalTotalAfterAllDiscounts: finalTotalAfterAllDiscounts ?? this.finalTotalAfterAllDiscounts,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'buffetInvoicePrice': buffetInvoicePrice,
      'sessionInvoicePrice': sessionInvoicePrice,
      'sessionInvoiceBeforeDiscount': sessionInvoiceBeforeDiscount,
      'sessionInvoiceAfterDiscount': sessionInvoiceAfterDiscount,
      'buffetInvoiceBeforeDiscount': buffetInvoiceBeforeDiscount,
      'buffetInvoiceAfterDiscount': buffetInvoiceAfterDiscount,
      'discountAmount': discountAmount,
      'discountCode': discountCode,
      'discountAppliesTo': discountAppliesTo,
      'totalInvoiceBeforeDiscount': totalInvoiceBeforeDiscount,
      'totalInvoiceAfterDiscount': totalInvoiceAfterDiscount,
      'manualDiscountAmount': manualDiscountAmount,
      'manualDiscountNote': manualDiscountNote,
      'finalTotalAfterAllDiscounts': finalTotalAfterAllDiscounts,
    };
  }

  factory SummaryInvoiceResponse.fromMap(Map<String, dynamic> map) {
    return SummaryInvoiceResponse(
      buffetInvoicePrice: (map['buffetInvoicePrice'] is double)
          ? map['buffetInvoicePrice']
          : (map['buffetInvoicePrice'] as num?)?.toDouble() ?? 0.0,
      sessionInvoicePrice: (map['sessionInvoicePrice'] is double)
          ? map['sessionInvoicePrice']
          : (map['sessionInvoicePrice'] as num?)?.toDouble() ?? 0.0,
      sessionInvoiceBeforeDiscount: map['sessionInvoiceBeforeDiscount'] != null
          ? ((map['sessionInvoiceBeforeDiscount'] is double)
              ? map['sessionInvoiceBeforeDiscount']
              : (map['sessionInvoiceBeforeDiscount'] as num?)?.toDouble())
          : null,
      sessionInvoiceAfterDiscount: map['sessionInvoiceAfterDiscount'] != null
          ? ((map['sessionInvoiceAfterDiscount'] is double)
              ? map['sessionInvoiceAfterDiscount']
              : (map['sessionInvoiceAfterDiscount'] as num?)?.toDouble())
          : null,
      buffetInvoiceBeforeDiscount: map['buffetInvoiceBeforeDiscount'] != null
          ? ((map['buffetInvoiceBeforeDiscount'] is double)
              ? map['buffetInvoiceBeforeDiscount']
              : (map['buffetInvoiceBeforeDiscount'] as num?)?.toDouble())
          : null,
      buffetInvoiceAfterDiscount: map['buffetInvoiceAfterDiscount'] != null
          ? ((map['buffetInvoiceAfterDiscount'] is double)
              ? map['buffetInvoiceAfterDiscount']
              : (map['buffetInvoiceAfterDiscount'] as num?)?.toDouble())
          : null,
      discountAmount: map['discountAmount'] != null
          ? ((map['discountAmount'] is double)
              ? map['discountAmount']
              : (map['discountAmount'] as num?)?.toDouble())
          : null,
      discountCode: map['discountCode'] as String?,
      discountAppliesTo: map['discountAppliesTo'] as String?,
      totalInvoiceBeforeDiscount: map['totalInvoiceBeforeDiscount'] != null
          ? ((map['totalInvoiceBeforeDiscount'] is double)
              ? map['totalInvoiceBeforeDiscount']
              : (map['totalInvoiceBeforeDiscount'] as num?)?.toDouble())
          : null,
      totalInvoiceAfterDiscount: map['totalInvoiceAfterDiscount'] != null
          ? ((map['totalInvoiceAfterDiscount'] is double)
              ? map['totalInvoiceAfterDiscount']
              : (map['totalInvoiceAfterDiscount'] as num?)?.toDouble())
          : null,
      manualDiscountAmount: map['manualDiscountAmount'] != null
          ? ((map['manualDiscountAmount'] is double)
              ? map['manualDiscountAmount']
              : (map['manualDiscountAmount'] as num?)?.toDouble())
          : null,
      manualDiscountNote: map['manualDiscountNote'] as String?,
      finalTotalAfterAllDiscounts: map['finalTotalAfterAllDiscounts'] != null
          ? ((map['finalTotalAfterAllDiscounts'] is double)
              ? map['finalTotalAfterAllDiscounts']
              : (map['finalTotalAfterAllDiscounts'] as num?)?.toDouble())
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SummaryInvoiceResponse.fromJson(String source) =>
      SummaryInvoiceResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SummaryInvoiceResponse(buffetInvoicePrice: $buffetInvoicePrice, sessionInvoicePrice: $sessionInvoicePrice, sessionInvoiceBeforeDiscount: $sessionInvoiceBeforeDiscount, sessionInvoiceAfterDiscount: $sessionInvoiceAfterDiscount, buffetInvoiceBeforeDiscount: $buffetInvoiceBeforeDiscount, buffetInvoiceAfterDiscount: $buffetInvoiceAfterDiscount, discountAmount: $discountAmount, discountCode: $discountCode, discountAppliesTo: $discountAppliesTo, totalInvoiceBeforeDiscount: $totalInvoiceBeforeDiscount, totalInvoiceAfterDiscount: $totalInvoiceAfterDiscount, manualDiscountAmount: $manualDiscountAmount, manualDiscountNote: $manualDiscountNote, finalTotalAfterAllDiscounts: $finalTotalAfterAllDiscounts)';
  }

  @override
  bool operator ==(covariant SummaryInvoiceResponse other) {
    if (identical(this, other)) return true;

    return other.buffetInvoicePrice == buffetInvoicePrice &&
        other.sessionInvoicePrice == sessionInvoicePrice &&
        other.sessionInvoiceBeforeDiscount == sessionInvoiceBeforeDiscount &&
        other.sessionInvoiceAfterDiscount == sessionInvoiceAfterDiscount &&
        other.buffetInvoiceBeforeDiscount == buffetInvoiceBeforeDiscount &&
        other.buffetInvoiceAfterDiscount == buffetInvoiceAfterDiscount &&
        other.discountAmount == discountAmount &&
        other.discountCode == discountCode &&
        other.discountAppliesTo == discountAppliesTo &&
        other.totalInvoiceBeforeDiscount == totalInvoiceBeforeDiscount &&
        other.totalInvoiceAfterDiscount == totalInvoiceAfterDiscount &&
        other.manualDiscountAmount == manualDiscountAmount &&
        other.manualDiscountNote == manualDiscountNote &&
        other.finalTotalAfterAllDiscounts == finalTotalAfterAllDiscounts;
  }

  @override
  int get hashCode {
    return buffetInvoicePrice.hashCode ^
        sessionInvoicePrice.hashCode ^
        sessionInvoiceBeforeDiscount.hashCode ^
        sessionInvoiceAfterDiscount.hashCode ^
        buffetInvoiceBeforeDiscount.hashCode ^
        buffetInvoiceAfterDiscount.hashCode ^
        discountAmount.hashCode ^
        discountCode.hashCode ^
        discountAppliesTo.hashCode ^
        totalInvoiceBeforeDiscount.hashCode ^
        totalInvoiceAfterDiscount.hashCode ^
        manualDiscountAmount.hashCode ^
        manualDiscountNote.hashCode ^
        finalTotalAfterAllDiscounts.hashCode;
  }
}
