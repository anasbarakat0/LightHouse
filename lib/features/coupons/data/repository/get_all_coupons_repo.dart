import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/coupons/data/models/get_all_coupons_response_model.dart';
import 'package:lighthouse/features/coupons/data/source/remote/get_all_coupons_service.dart';

class GetAllCouponsRepo {
  final GetAllCouponsService getAllCouponsService;
  final NetworkConnection networkConnection;

  GetAllCouponsRepo({
    required this.getAllCouponsService,
    required this.networkConnection,
  });

  Future<Either<Failures, GetAllCouponsResponseModel>> getAllCouponsRepo({
    int? page,
    int? size,
    bool? active,
    String? discountType,
    String? appliesTo,
    String? codeSubstring,
    String? sort,
  }) async {
    if (await networkConnection.isConnected) {
      try {
        var data = await getAllCouponsService.getAllCoupons(
          page: page,
          size: size,
          active: active,
          discountType: discountType,
          appliesTo: appliesTo,
          codeSubstring: codeSubstring,
          sort: sort,
        );
        try {
          if (data.data == null) {
            return Left(NoDataFailure(message: "No data received"));
          }
          return Right(GetAllCouponsResponseModel.fromMap(data.data));
        } catch (e) {
          return Left(NoDataFailure(message: data.data?["message"] ?? "No data"));
        }
      } on Forbidden {
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
        return Left(ServerFailure(
            message: e.response?.data.toString() ?? "Unknown error"));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}

