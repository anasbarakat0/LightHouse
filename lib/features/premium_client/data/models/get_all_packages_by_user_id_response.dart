// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';



class GetAllPackagesByUserIdResponse {
  final String message;
  final String status;
  final String localDateTime;
  final PackagesBody body;
  GetAllPackagesByUserIdResponse({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  GetAllPackagesByUserIdResponse copyWith({
    String? message,
    String? status,
    String? localDateTime,
    PackagesBody? body,
  }) {
    return GetAllPackagesByUserIdResponse(
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

  factory GetAllPackagesByUserIdResponse.fromMap(Map<String, dynamic> map) {
    return GetAllPackagesByUserIdResponse(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: PackagesBody.fromMap(map['body'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetAllPackagesByUserIdResponse.fromJson(String source) =>
      GetAllPackagesByUserIdResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'GetAllPackagesByUserIdResponse(message: $message, status: $status, localDateTime: $localDateTime, body: $body)';
}

class PackagesBody {
  final PaginationResponse paginationResponse;
  final List<UserPackage> userPackage;
  PackagesBody({
    required this.paginationResponse,
    required this.userPackage,
  });

  PackagesBody copyWith({
    PaginationResponse? paginationResponse,
    List<UserPackage>? userPackage,
  }) {
    return PackagesBody(
      paginationResponse: paginationResponse ?? this.paginationResponse,
      userPackage: userPackage ?? this.userPackage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'paginationResponse': paginationResponse.toMap(),
      'userPackage': userPackage.map((x) => x.toMap()).toList(),
    };
  }

  factory PackagesBody.fromMap(Map<String, dynamic> map) {
    return PackagesBody(
      paginationResponse:
          PaginationResponse.fromMap(map['paginationResponse'] as Map<String, dynamic>),
      userPackage: List<UserPackage>.from(
        (map['userPackage'] as List<dynamic>).map((x) => UserPackage.fromMap(x as Map<String, dynamic>)),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory PackagesBody.fromJson(String source) =>
      PackagesBody.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PackagesBody(paginationResponse: $paginationResponse, userPackage: $userPackage)';
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

class UserPackage {
  final String id;
  final String userId;
  final String packageId;
  final double consumedHours;
  final String startDate;
  final dynamic endDate;
  final int remainingDays;
  final bool active;
  UserPackage({
    required this.id,
    required this.userId,
    required this.packageId,
    required this.consumedHours,
    required this.startDate,
    this.endDate,
    required this.remainingDays,
    required this.active,
  });

  UserPackage copyWith({
    String? id,
    String? userId,
    String? packageId,
    double? consumedHours,
    String? startDate,
    dynamic endDate,
    int? remainingDays,
    bool? active,
  }) {
    return UserPackage(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      packageId: packageId ?? this.packageId,
      consumedHours: consumedHours ?? this.consumedHours,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      remainingDays: remainingDays ?? this.remainingDays,
      active: active ?? this.active,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'packageId': packageId,
      'consumedHours': consumedHours,
      'startDate': startDate,
      'endDate': endDate,
      'remainingDays': remainingDays,
      'active': active,
    };
  }

  factory UserPackage.fromMap(Map<String, dynamic> map) {
    print(map);
    return UserPackage(
      id: map['id'] as String,
      userId: map['userId'] as String,
      packageId: map['packageId'] as String,
      consumedHours: map['consumedHours'] as double,
      startDate: map['startDate'] as String,
      endDate: map['endDate'],
      remainingDays: map['remainingDays'] as int,
      active: map['active'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserPackage.fromJson(String source) =>
      UserPackage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserPackage(id: $id, userId: $userId, packageId: $packageId, consumedHours: $consumedHours, startDate: $startDate, endDate: $endDate, remainingDays: $remainingDays, active: $active)';
  }
}
