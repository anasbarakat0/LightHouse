import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/dashboard/data/models/dashboard_summary_response_model.dart';
import 'package:lighthouse/features/dashboard/data/sources/remote/get_dashboard_summary_service.dart';

class GetDashboardSummaryRepo {
  final GetDashboardSummaryService getDashboardSummaryService;
  final NetworkConnection networkConnection;

  GetDashboardSummaryRepo({
    required this.getDashboardSummaryService,
    required this.networkConnection,
  });

  Future<Either<Failures, DashboardSummaryResponseModel>> call() async {
    if (await networkConnection.isConnected) {
      try {
        final response = await getDashboardSummaryService.getDashboardSummaryService();
        final data = DashboardSummaryResponseModel.fromMap(response.data);
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

