// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class FinishPremiumSessionResponseModel {
    final String message;
    final String status;
    final String localDateTime;
    final Body body;
  FinishPremiumSessionResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });


  FinishPremiumSessionResponseModel copyWith({
    String? message,
    String? status,
    String? localDateTime,
    Body? body,
  }) {
    return FinishPremiumSessionResponseModel(
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

  factory FinishPremiumSessionResponseModel.fromMap(Map<String, dynamic> map) {
    return FinishPremiumSessionResponseModel(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: Body.fromMap(map['body'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory FinishPremiumSessionResponseModel.fromJson(String source) => FinishPremiumSessionResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FinishPremiumSessionResponseModel(message: $message, status: $status, localDateTime: $localDateTime, body: $body)';
  }

  @override
  bool operator ==(covariant FinishPremiumSessionResponseModel other) {
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
    // final CreatedBy createdBy;
    final String userId;
    final String firstName;
    final String lastName;
    final String endTime;
    final SessionInvoice sessionInvoice;
    final double buffetInvoicePrice;
    final List<BuffetInvoice> buffetInvoices;
    final double totalPrice;
    final bool active;
  Body({
    required this.id,
    required this.date,
    required this.startTime,
    required this.qrCode,
    // required this.createdBy,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.endTime,
    required this.sessionInvoice,
    required this.buffetInvoicePrice,
    required this.buffetInvoices,
    required this.totalPrice,
    required this.active,
  });



  Body copyWith({
    String? id,
    String? date,
    String? startTime,
    String? qrCode,
    // CreatedBy? createdBy,
    String? userId,
    String? firstName,
    String? lastName,
    String? endTime,
    SessionInvoice? sessionInvoice,
    double? buffetInvoicePrice,
    List<BuffetInvoice>? buffetInvoices,
    double? totalPrice,
    bool? active,
  }) {
    return Body(
      id: id ?? this.id,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      qrCode: qrCode ?? this.qrCode,
      // createdBy: createdBy ?? this.createdBy,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
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
      // 'createdBy': createdBy,
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'endTime': endTime,
      'sessionInvoice': sessionInvoice.toMap(),
      'buffetInvoicePrice': buffetInvoicePrice,
      'buffetInvoices': buffetInvoices,
      'totalPrice': totalPrice,
      'active': active,
    };
  }

   factory Body.fromMap(Map<String, dynamic> map) {

  return Body(
    id: map['id'] as String? ?? '',
    date: map['date'] as String? ?? '',
    startTime: map['startTime'] as String? ?? '',
    qrCode: map['qrCode'] as String? ?? '',
    // createdBy: CreatedBy.fromMap(map['createdBy'] as Map<String, dynamic>),
    userId: map['userId'] as String? ?? '',
    firstName: map['firstName'] as String? ?? '',
    lastName: map['lastName'] as String? ?? '',
    endTime: map['endTime'],
    sessionInvoice: SessionInvoice.fromMap(map['sessionInvoice'] as Map<String, dynamic>),
    buffetInvoicePrice: (map['buffetInvoicePrice'] is double)
        ? map['buffetInvoicePrice']
        : (map['buffetInvoicePrice'] as num?)?.toDouble() ?? 0.0,
    buffetInvoices: (map['buffetInvoices'] as List<dynamic>)
        .map((invoice) => BuffetInvoice.fromMap(invoice as Map<String, dynamic>))
        .toList(),
    totalPrice: (map['totalPrice'] is double)
        ? map['totalPrice']
        : (map['totalPrice'] as num?)?.toDouble() ?? 0.0,
    active: map['active'] as bool? ?? false,
  );
}

  String toJson() => json.encode(toMap());

  factory Body.fromJson(String source) => Body.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Body(id: $id, date: $date, startTime: $startTime, qrCode: $qrCode, userId: $userId, firstName: $firstName, lastName: $lastName, endTime: $endTime, sessionInvoice: $sessionInvoice, buffetInvoicePrice: $buffetInvoicePrice, buffetInvoices: $buffetInvoices, totalPrice: $totalPrice, active: $active)';
  }

  @override
  bool operator ==(covariant Body other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.date == date &&
      other.startTime == startTime &&
      other.qrCode == qrCode &&
      // other.createdBy == createdBy &&
      other.userId == userId &&
      other.firstName == firstName &&
      other.lastName == lastName &&
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
      // createdBy.hashCode ^
      userId.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      endTime.hashCode ^
      sessionInvoice.hashCode ^
      buffetInvoicePrice.hashCode ^
      buffetInvoices.hashCode ^
      totalPrice.hashCode ^
      active.hashCode;
  }
}

class SessionInvoice {
    final String id;
    final String userType;
    final String session_id;
    final double hoursAmount;
    final double sessionPrice;
    final double? totalInvoiceBeforeDiscount;
    final double? discountAmount;
    final double? totalInvoiceAfterDiscount;
    final double? manualDiscountAmount;
    final String? manualDiscountNote;
    final double? finalTotalAfterAllDiscounts;
  SessionInvoice({
    required this.id,
    required this.userType,
    required this.session_id,
    required this.hoursAmount,
    required this.sessionPrice,
    this.totalInvoiceBeforeDiscount,
    this.discountAmount,
    this.totalInvoiceAfterDiscount,
    this.manualDiscountAmount,
    this.manualDiscountNote,
    this.finalTotalAfterAllDiscounts,
  });

  SessionInvoice copyWith({
    String? id,
    String? userType,
    String? session_id,
    double? hoursAmount,
    double? sessionPrice,
    double? totalInvoiceBeforeDiscount,
    double? discountAmount,
    double? totalInvoiceAfterDiscount,
    double? manualDiscountAmount,
    String? manualDiscountNote,
    double? finalTotalAfterAllDiscounts,
  }) {
    return SessionInvoice(
      id: id ?? this.id,
      userType: userType ?? this.userType,
      session_id: session_id ?? this.session_id,
      hoursAmount: hoursAmount ?? this.hoursAmount,
      sessionPrice: sessionPrice ?? this.sessionPrice,
      totalInvoiceBeforeDiscount: totalInvoiceBeforeDiscount ?? this.totalInvoiceBeforeDiscount,
      discountAmount: discountAmount ?? this.discountAmount,
      totalInvoiceAfterDiscount: totalInvoiceAfterDiscount ?? this.totalInvoiceAfterDiscount,
      manualDiscountAmount: manualDiscountAmount ?? this.manualDiscountAmount,
      manualDiscountNote: manualDiscountNote ?? this.manualDiscountNote,
      finalTotalAfterAllDiscounts: finalTotalAfterAllDiscounts ?? this.finalTotalAfterAllDiscounts,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userType': userType,
      'session_id': session_id,
      'hoursAmount': hoursAmount,
      'sessionPrice': sessionPrice,
      'totalInvoiceBeforeDiscount': totalInvoiceBeforeDiscount,
      'discountAmount': discountAmount,
      'totalInvoiceAfterDiscount': totalInvoiceAfterDiscount,
      'manualDiscountAmount': manualDiscountAmount,
      'manualDiscountNote': manualDiscountNote,
      'finalTotalAfterAllDiscounts': finalTotalAfterAllDiscounts,
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
    
    // Handle sessionPrice with robust parsing
    double sessionPriceValue = 0.0;
    if (map['sessionPrice'] != null) {
      if (map['sessionPrice'] is double) {
        sessionPriceValue = map['sessionPrice'] as double;
      } else if (map['sessionPrice'] is int) {
        sessionPriceValue = (map['sessionPrice'] as int).toDouble();
      } else if (map['sessionPrice'] is num) {
        sessionPriceValue = (map['sessionPrice'] as num).toDouble();
      } else {
        try {
          sessionPriceValue = double.parse(map['sessionPrice'].toString());
        } catch (e) {
          sessionPriceValue = 0.0;
        }
      }
    }
    
    return SessionInvoice(
      id: map['id'] as String,
      userType: map['userType'] as String,
      session_id: map['session_id'] as String,
      hoursAmount: hoursAmountValue,
      sessionPrice: sessionPriceValue,
      totalInvoiceBeforeDiscount: map['totalInvoiceBeforeDiscount'] != null ? ((map['totalInvoiceBeforeDiscount'] is double) ? map['totalInvoiceBeforeDiscount'] : (map['totalInvoiceBeforeDiscount'] as num?)?.toDouble()) : null,
      discountAmount: map['discountAmount'] != null ? ((map['discountAmount'] is double) ? map['discountAmount'] : (map['discountAmount'] as num?)?.toDouble()) : null,
      totalInvoiceAfterDiscount: map['totalInvoiceAfterDiscount'] != null ? ((map['totalInvoiceAfterDiscount'] is double) ? map['totalInvoiceAfterDiscount'] : (map['totalInvoiceAfterDiscount'] as num?)?.toDouble()) : null,
      manualDiscountAmount: map['manualDiscountAmount'] != null ? ((map['manualDiscountAmount'] is double) ? map['manualDiscountAmount'] : (map['manualDiscountAmount'] as num?)?.toDouble()) : null,
      manualDiscountNote: map['manualDiscountNote'] as String?,
      finalTotalAfterAllDiscounts: map['finalTotalAfterAllDiscounts'] != null ? ((map['finalTotalAfterAllDiscounts'] is double) ? map['finalTotalAfterAllDiscounts'] : (map['finalTotalAfterAllDiscounts'] as num?)?.toDouble()) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SessionInvoice.fromJson(String source) => SessionInvoice.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SessionInvoice(id: $id, userType: $userType, session_id: $session_id, hoursAmount: $hoursAmount, sessionPrice: $sessionPrice, totalInvoiceBeforeDiscount: $totalInvoiceBeforeDiscount, discountAmount: $discountAmount, totalInvoiceAfterDiscount: $totalInvoiceAfterDiscount, manualDiscountAmount: $manualDiscountAmount, manualDiscountNote: $manualDiscountNote, finalTotalAfterAllDiscounts: $finalTotalAfterAllDiscounts)';
  }

  @override
  bool operator ==(covariant SessionInvoice other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.userType == userType &&
      other.session_id == session_id &&
      other.hoursAmount == hoursAmount &&
      other.sessionPrice == sessionPrice &&
      other.totalInvoiceBeforeDiscount == totalInvoiceBeforeDiscount &&
      other.discountAmount == discountAmount &&
      other.totalInvoiceAfterDiscount == totalInvoiceAfterDiscount &&
      other.manualDiscountAmount == manualDiscountAmount &&
      other.manualDiscountNote == manualDiscountNote &&
      other.finalTotalAfterAllDiscounts == finalTotalAfterAllDiscounts;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userType.hashCode ^
      session_id.hashCode ^
      hoursAmount.hashCode ^
      sessionPrice.hashCode ^
      totalInvoiceBeforeDiscount.hashCode ^
      discountAmount.hashCode ^
      totalInvoiceAfterDiscount.hashCode ^
      manualDiscountAmount.hashCode ^
      manualDiscountNote.hashCode ^
      finalTotalAfterAllDiscounts.hashCode;
  }
}


class BuffetInvoice {
    final String id;
    final String invoiceDate;
    final String invoiceTime;
    final String session_id;
    final List<Order> orders;
    final double totalPrice;
  BuffetInvoice({
    required this.id,
    required this.invoiceDate,
    required this.invoiceTime,
    required this.session_id,
    required this.orders,
    required this.totalPrice,
  });


  BuffetInvoice copyWith({
    String? id,
    String? invoiceDate,
    String? invoiceTime,
    String? session_id,
    List<Order>? orders,
    double? totalPrice,
  }) {
    return BuffetInvoice(
      id: id ?? this.id,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      invoiceTime: invoiceTime ?? this.invoiceTime,
      session_id: session_id ?? this.session_id,
      orders: orders ?? this.orders,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'invoiceDate': invoiceDate,
      'invoiceTime': invoiceTime,
      'session_id': session_id,
      'orders': orders.map((x) => x.toMap()).toList(),
      'totalPrice': totalPrice,
    };
  }

  factory BuffetInvoice.fromMap(Map<String, dynamic> map) {
  return BuffetInvoice(
    id: map['id'] as String? ?? '',
    invoiceDate: map['invoiceDate'] as String? ?? '',
    invoiceTime: map['invoiceTime'] as String? ?? '',
    session_id: map['session_id'] as String? ?? '',
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
    return 'BuffetInvoice(id: $id, invoiceDate: $invoiceDate, invoiceTime: $invoiceTime, session_id: $session_id, orders: $orders, totalPrice: $totalPrice)';
  }

  @override
  bool operator ==(covariant BuffetInvoice other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.invoiceDate == invoiceDate &&
      other.invoiceTime == invoiceTime &&
      other.session_id == session_id &&
      listEquals(other.orders, orders) &&
      other.totalPrice == totalPrice;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      invoiceDate.hashCode ^
      invoiceTime.hashCode ^
      session_id.hashCode ^
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
