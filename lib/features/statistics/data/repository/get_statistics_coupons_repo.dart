// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/statistics/data/models/statistics_coupons_response_model.dart';
import 'package:lighthouse/features/statistics/data/source/remote/get_statistics_coupons_service.dart';

class GetStatisticsCouponsRepo {
  final GetStatisticsCouponsService getStatisticsCouponsService;
  final NetworkConnection networkConnection;

  GetStatisticsCouponsRepo({
    required this.getStatisticsCouponsService,
    required this.networkConnection,
  });

  Future<Either<Failures, StatisticsCouponsResponseModel>>
      getStatisticsCouponsRepo({
    String? from,
    String? to,
    int? top,
  }) async {
    if (await networkConnection.isConnected) {
      try {
        var data = await getStatisticsCouponsService.getStatisticsCouponsService(
          from: from,
          to: to,
          top: top,
        );
        var response = StatisticsCouponsResponseModel.fromMap(data.data);
        return Right(response);
      } on Forbidden {
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
        return Left(ServerFailure(
            message: e.response?.data?.toString() ?? e.message ?? "Unknown error"));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}

