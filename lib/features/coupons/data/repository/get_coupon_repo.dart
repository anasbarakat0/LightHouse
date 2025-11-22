import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/coupons/data/models/get_coupon_response_model.dart';
import 'package:lighthouse/features/coupons/data/source/remote/get_coupon_service.dart';

class GetCouponRepo {
  final GetCouponService getCouponService;
  final NetworkConnection networkConnection;

  GetCouponRepo({
    required this.getCouponService,
    required this.networkConnection,
  });

  Future<Either<Failures, GetCouponResponseModel>> getCouponRepo(
      String codeOrId) async {
    if (await networkConnection.isConnected) {
      try {
        var data = await getCouponService.getCoupon(codeOrId);
        try {
          if (data.data == null) {
            return Left(NoDataFailure(message: "No data received"));
          }
          return Right(GetCouponResponseModel.fromMap(data.data));
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

