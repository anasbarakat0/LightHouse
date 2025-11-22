import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/dashboard/data/models/dashboard_revenue_chart_response_model.dart';
import 'package:lighthouse/features/dashboard/data/repository/get_dashboard_revenue_chart_repo.dart';

class GetDashboardRevenueChartUsecase {
  final GetDashboardRevenueChartRepo getDashboardRevenueChartRepo;

  GetDashboardRevenueChartUsecase({required this.getDashboardRevenueChartRepo});

  Future<Either<Failures, DashboardRevenueChartResponseModel>> call({
    String? period,
    String? from,
    String? to,
  }) async {
    return await getDashboardRevenueChartRepo(
      period: period,
      from: from,
      to: to,
    );
  }
}

