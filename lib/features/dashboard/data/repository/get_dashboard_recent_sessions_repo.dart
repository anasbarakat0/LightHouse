import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/dashboard/data/models/dashboard_recent_sessions_response_model.dart';
import 'package:lighthouse/features/dashboard/data/sources/remote/get_dashboard_recent_sessions_service.dart';

class GetDashboardRecentSessionsRepo {
  final GetDashboardRecentSessionsService getDashboardRecentSessionsService;
  final NetworkConnection networkConnection;

  GetDashboardRecentSessionsRepo({
    required this.getDashboardRecentSessionsService,
    required this.networkConnection,
  });

  Future<Either<Failures, DashboardRecentSessionsResponseModel>> call({
    int? limit,
  }) async {
    if (await networkConnection.isConnected) {
      try {
        final response = await getDashboardRecentSessionsService.getDashboardRecentSessionsService(
          limit: limit,
        );
        final data = DashboardRecentSessionsResponseModel.fromMap(response.data);
        return Right(data);
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

