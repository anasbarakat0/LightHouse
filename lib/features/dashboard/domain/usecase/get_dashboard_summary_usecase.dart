import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/dashboard/data/models/dashboard_summary_response_model.dart';
import 'package:lighthouse/features/dashboard/data/repository/get_dashboard_summary_repo.dart';

class GetDashboardSummaryUsecase {
  final GetDashboardSummaryRepo getDashboardSummaryRepo;

  GetDashboardSummaryUsecase({required this.getDashboardSummaryRepo});

  Future<Either<Failures, DashboardSummaryResponseModel>> call() async {
    return await getDashboardSummaryRepo();
  }
}

