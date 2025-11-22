import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/dashboard/data/models/dashboard_recent_sessions_response_model.dart';
import 'package:lighthouse/features/dashboard/data/repository/get_dashboard_recent_sessions_repo.dart';

class GetDashboardRecentSessionsUsecase {
  final GetDashboardRecentSessionsRepo getDashboardRecentSessionsRepo;

  GetDashboardRecentSessionsUsecase({required this.getDashboardRecentSessionsRepo});

  Future<Either<Failures, DashboardRecentSessionsResponseModel>> call({
    int? limit,
  }) async {
    return await getDashboardRecentSessionsRepo(limit: limit);
  }
}

