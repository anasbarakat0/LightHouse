import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/dashboard/data/models/dashboard_alerts_response_model.dart';
import 'package:lighthouse/features/dashboard/data/repository/get_dashboard_alerts_repo.dart';

class GetDashboardAlertsUsecase {
  final GetDashboardAlertsRepo getDashboardAlertsRepo;

  GetDashboardAlertsUsecase({required this.getDashboardAlertsRepo});

  Future<Either<Failures, DashboardAlertsResponseModel>> call() async {
    return await getDashboardAlertsRepo();
  }
}

