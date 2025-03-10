// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GetAllActivePackagesResponse {
  final String message;
  final String status;
  final String localDateTime;
  final List<ActivePackage> body;
  final PaginationResponse pageable;
  GetAllActivePackagesResponse({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
    required this.pageable,
  });

  GetAllActivePackagesResponse copyWith({
    String? message,
    String? status,
    String? localDateTime,
    List<ActivePackage>? body,
    PaginationResponse? pageable,
  }) {
    return GetAllActivePackagesResponse(
      message: message ?? this.message,
      status: status ?? this.status,
      localDateTime: localDateTime ?? this.localDateTime,
      body: body ?? this.body,
      pageable: pageable ?? this.pageable,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'status': status,
      'localDateTime': localDateTime,
      'body': body.map((x) => x.toMap()).toList(),
      'pageable': pageable.toMap(),
    };
  }

  factory GetAllActivePackagesResponse.fromMap(Map<String, dynamic> map) {
    return GetAllActivePackagesResponse(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: List<ActivePackage>.from(
        (map['body'] as List<dynamic>).map((x) => ActivePackage.fromMap(x as Map<String, dynamic>)),
      ),
      pageable: PaginationResponse.fromMap(map['pageable'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetAllActivePackagesResponse.fromJson(String source) =>
      GetAllActivePackagesResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GetAllActivePackagesResponse(message: $message, status: $status, localDateTime: $localDateTime, body: $body, pageable: $pageable)';
  }
}

class ActivePackage {
  final String id;
  final String? name;
  final int numOfHours;
  final double price;
  final String description;
  final int packageDurationInDays;
  final bool active;
  ActivePackage({
    required this.id,
    this.name,
    required this.numOfHours,
    required this.price,
    required this.description,
    required this.packageDurationInDays,
    required this.active,
  });

  ActivePackage copyWith({
    String? id,
    String? name,
    int? numOfHours,
    double? price,
    String? description,
    int? packageDurationInDays,
    bool? active,
  }) {
    return ActivePackage(
      id: id ?? this.id,
      name: name ?? this.name,
      numOfHours: numOfHours ?? this.numOfHours,
      price: price ?? this.price,
      description: description ?? this.description,
      packageDurationInDays: packageDurationInDays ?? this.packageDurationInDays,
      active: active ?? this.active,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'numOfHours': numOfHours,
      'price': price,
      'description': description,
      'packageDurationInDays': packageDurationInDays,
      'active': active,
    };
  }

  factory ActivePackage.fromMap(Map<String, dynamic> map) {
    return ActivePackage(
      id: map['id'] as String,
      name: map['name'] ?? "Name" ,
      numOfHours: map['numOfHours'] as int,
      price: map['price'] as double,
      description: map['description'] as String,
      packageDurationInDays: map['packageDurationInDays'] as int,
      active: map['active'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivePackage.fromJson(String source) =>
      ActivePackage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ActivePackage(id: $id, name: $name, numOfHours: $numOfHours, price: $price, description: $description, packageDurationInDays: $packageDurationInDays, active: $active)';
  }
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
  String toString() => 'PaginationResponse(page: $page, perPage: $perPage, total: $total)';
}
