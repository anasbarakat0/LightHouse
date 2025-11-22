import 'dart:convert';
import 'package:flutter/foundation.dart';

class GetExpressSessionResponse {
  final String message;
  final String status;
  final String localDateTime;
  final ExpressSessionBody body;
  GetExpressSessionResponse({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  GetExpressSessionResponse copyWith({
    String? message,
    String? status,
    String? localDateTime,
    ExpressSessionBody? body,
  }) {
    return GetExpressSessionResponse(
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

  factory GetExpressSessionResponse.fromMap(Map<String, dynamic> map) {
    return GetExpressSessionResponse(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: ExpressSessionBody.fromMap(map['body'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetExpressSessionResponse.fromJson(String source) =>
      GetExpressSessionResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'GetExpressSessionResponse(message: $message, status: $status, localDateTime: $localDateTime, body: $body)';

  @override
  bool operator ==(covariant GetExpressSessionResponse other) {
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

class ExpressSessionBody {
  final String id;
  final String date;
  final String startTime;
  final String qrCode;
  final CreatedBy createdBy;
  final String userId;
  final String fullName;
  final dynamic endTime;
  final SessionInvoice? sessionInvoice;
  final double buffetInvoicePrice;
  final List<BuffetInvoice> buffetInvoices;
  final double totalPrice;
  final bool active;
  ExpressSessionBody({
    required this.id,
    required this.date,
    required this.startTime,
    required this.qrCode,
    required this.createdBy,
    required this.userId,
    required this.fullName,
    required this.endTime,
    this.sessionInvoice,
    required this.buffetInvoicePrice,
    required this.buffetInvoices,
    required this.totalPrice,
    required this.active,
  });

  ExpressSessionBody copyWith({
    String? id,
    String? date,
    String? startTime,
    String? qrCode,
    CreatedBy? createdBy,
    String? userId,
    String? fullName,
    dynamic endTime,
    SessionInvoice? sessionInvoice,
    double? buffetInvoicePrice,
    List<BuffetInvoice>? buffetInvoices,
    double? totalPrice,
    bool? active,
  }) {
    return ExpressSessionBody(
      id: id ?? this.id,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      qrCode: qrCode ?? this.qrCode,
      createdBy: createdBy ?? this.createdBy,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      endTime: endTime ?? this.endTime,
      sessionInvoice: sessionInvoice ?? this.sessionInvoice,
      buffetInvoicePrice: buffetInvoicePrice ?? this.buffetInvoicePrice,
      buffetInvoices: buffetInvoices ?? this.buffetInvoices,
      totalPrice: totalPrice ?? this.totalPrice,
      active: active ?? this.active,
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
      'fullName': fullName,
      'endTime': endTime,
      'sessionInvoice': sessionInvoice?.toMap(),
      'buffetInvoicePrice': buffetInvoicePrice,
      'buffetInvoices': buffetInvoices.map((x) => x.toMap()).toList(),
      'totalPrice': totalPrice,
      'active': active,
    };
  }

  factory ExpressSessionBody.fromMap(Map<String, dynamic> map) {
    return ExpressSessionBody(
      id: map['id'] as String? ?? '',
      date: map['date'] as String? ?? '',
      startTime: map['startTime'] as String? ?? '',
      qrCode: map['qrCode'] as String? ?? '',
      createdBy: CreatedBy.fromMap(map['createdBy'] as Map<String, dynamic>),
      userId: map['userId'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      endTime: map['endTime'],
      sessionInvoice: map['sessionInvoice'] != null
          ? SessionInvoice.fromMap(map['sessionInvoice'] as Map<String, dynamic>)
          : null,
      buffetInvoicePrice:
          (map['buffetInvoicePrice'] as num?)?.toDouble() ?? 0.0,
      buffetInvoices: (map['buffetInvoices'] as List<dynamic>?)
              ?.map((invoice) =>
                  BuffetInvoice.fromMap(invoice as Map<String, dynamic>))
              .toList() ??
          [],
      totalPrice: (map['totalPrice'] as num?)?.toDouble() ?? 0.0,
      active: map['active'] as bool? ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpressSessionBody.fromJson(String source) =>
      ExpressSessionBody.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ExpressSessionBody(id: $id, date: $date, startTime: $startTime, qrCode: $qrCode, createdBy: $createdBy, userId: $userId, fullName: $fullName, endTime: $endTime, sessionInvoice: $sessionInvoice, buffetInvoicePrice: $buffetInvoicePrice, buffetInvoices: $buffetInvoices, totalPrice: $totalPrice, active: $active)';
  }

  @override
  bool operator ==(covariant ExpressSessionBody other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.date == date &&
        other.startTime == startTime &&
        other.qrCode == qrCode &&
        other.createdBy == createdBy &&
        other.userId == userId &&
        other.fullName == fullName &&
        other.endTime == endTime &&
        other.sessionInvoice == sessionInvoice &&
        other.buffetInvoicePrice == buffetInvoicePrice &&
        listEquals(other.buffetInvoices, buffetInvoices) &&
        other.totalPrice == totalPrice &&
        other.active == active;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        date.hashCode ^
        startTime.hashCode ^
        qrCode.hashCode ^
        createdBy.hashCode ^
        userId.hashCode ^
        fullName.hashCode ^
        endTime.hashCode ^
        sessionInvoice.hashCode ^
        buffetInvoicePrice.hashCode ^
        buffetInvoices.hashCode ^
        totalPrice.hashCode ^
        active.hashCode;
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
      sessionId:
          (map['sessionId'] as String?) ?? (map['session_id'] as String? ?? ''),
      orders: (map['orders'] as List<dynamic>)
          .map((order) => Order.fromMap(order as Map<String, dynamic>))
          .toList(),
      totalPrice: (map['totalPrice'] is double)
          ? map['totalPrice']
          : (map['totalPrice'] as num).toDouble(),
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
      price: (map['price'] as num?)?.toDouble() ?? 0,
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
        email.hashCode ^
        role.hashCode;
  }
}

class SessionInvoice {
  final String id;
  final String userType;
  final String session_id;
  final double hoursAmount;
  final double sessionPrice;
  SessionInvoice({
    required this.id,
    required this.userType,
    required this.session_id,
    required this.hoursAmount,
    required this.sessionPrice,
  });

  SessionInvoice copyWith({
    String? id,
    String? userType,
    String? session_id,
    double? hoursAmount,
    double? sessionPrice,
  }) {
    return SessionInvoice(
      id: id ?? this.id,
      userType: userType ?? this.userType,
      session_id: session_id ?? this.session_id,
      hoursAmount: hoursAmount ?? this.hoursAmount,
      sessionPrice: sessionPrice ?? this.sessionPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userType': userType,
      'session_id': session_id,
      'hoursAmount': hoursAmount,
      'sessionPrice': sessionPrice,
    };
  }

  factory SessionInvoice.fromMap(Map<String, dynamic> map) {
    return SessionInvoice(
      id: map['id'] as String? ?? '',
      userType: map['userType'] as String? ?? '',
      session_id: map['session_id'] as String? ?? '',
      hoursAmount: (map['hoursAmount'] is double)
          ? map['hoursAmount']
          : (map['hoursAmount'] as num?)?.toDouble() ?? 0.0,
      sessionPrice: (map['sessionPrice'] is double)
          ? map['sessionPrice']
          : (map['sessionPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SessionInvoice.fromJson(String source) =>
      SessionInvoice.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SessionInvoice(id: $id, userType: $userType, session_id: $session_id, hoursAmount: $hoursAmount, sessionPrice: $sessionPrice)';
  }

  @override
  bool operator ==(covariant SessionInvoice other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userType == userType &&
        other.session_id == session_id &&
        other.hoursAmount == hoursAmount &&
        other.sessionPrice == sessionPrice;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userType.hashCode ^
        session_id.hashCode ^
        hoursAmount.hashCode ^
        sessionPrice.hashCode;
  }
}
