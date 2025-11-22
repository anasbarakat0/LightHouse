import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/dashboard/data/models/dashboard_alerts_response_model.dart';
import 'package:lighthouse/features/dashboard/data/sources/remote/get_dashboard_alerts_service.dart';

class GetDashboardAlertsRepo {
  final GetDashboardAlertsService getDashboardAlertsService;
  final NetworkConnection networkConnection;

  GetDashboardAlertsRepo({
    required this.getDashboardAlertsService,
    required this.networkConnection,
  });

  Future<Either<Failures, DashboardAlertsResponseModel>> call() async {
    if (await networkConnection.isConnected) {
      try {
        final response = await getDashboardAlertsService.getDashboardAlertsService();
        final data = DashboardAlertsResponseModel.fromMap(response.data);
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

