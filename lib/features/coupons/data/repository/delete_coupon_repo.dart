import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/coupons/data/models/delete_coupon_response_model.dart';
import 'package:lighthouse/features/coupons/data/source/remote/delete_coupon_service.dart';

class DeleteCouponRepo {
  final DeleteCouponService deleteCouponService;
  final NetworkConnection networkConnection;

  DeleteCouponRepo({
    required this.deleteCouponService,
    required this.networkConnection,
  });

  Future<Either<Failures, DeleteCouponResponseModel>> deleteCouponRepo(
      String couponId) async {
    if (await networkConnection.isConnected) {
      try {
        var data = await deleteCouponService.deleteCoupon(couponId);
        try {
          if (data.data == null) {
            return Left(NoDataFailure(message: "No data received"));
          }
          return Right(DeleteCouponResponseModel.fromMap(data.data));
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

