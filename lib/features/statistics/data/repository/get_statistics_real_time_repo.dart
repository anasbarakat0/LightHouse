// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/statistics/data/models/statistics_real_time_response_model.dart';
import 'package:lighthouse/features/statistics/data/source/remote/get_statistics_real_time_service.dart';

class GetStatisticsRealTimeRepo {
  final GetStatisticsRealTimeService getStatisticsRealTimeService;
  final NetworkConnection networkConnection;

  GetStatisticsRealTimeRepo({
    required this.getStatisticsRealTimeService,
    required this.networkConnection,
  });

  Future<Either<Failures, StatisticsRealTimeResponseModel>>
      getStatisticsRealTimeRepo() async {
    if (await networkConnection.isConnected) {
      try {
        var data = await getStatisticsRealTimeService.getStatisticsRealTimeService();
        var response = StatisticsRealTimeResponseModel.fromMap(data.data);
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

