import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/utils/responsive.dart';
import 'package:lighthouse/features/dashboard/data/repository/get_dashboard_alerts_repo.dart';
import 'package:lighthouse/features/dashboard/data/repository/get_dashboard_recent_sessions_repo.dart';
import 'package:lighthouse/features/dashboard/data/repository/get_dashboard_revenue_chart_repo.dart';
import 'package:lighthouse/features/dashboard/data/repository/get_dashboard_summary_repo.dart';
import 'package:lighthouse/features/dashboard/data/sources/remote/get_dashboard_alerts_service.dart';
import 'package:lighthouse/features/dashboard/data/sources/remote/get_dashboard_recent_sessions_service.dart';
import 'package:lighthouse/features/dashboard/data/sources/remote/get_dashboard_revenue_chart_service.dart';
import 'package:lighthouse/features/dashboard/data/sources/remote/get_dashboard_summary_service.dart';
import 'package:lighthouse/features/dashboard/domain/usecase/get_dashboard_alerts_usecase.dart';
import 'package:lighthouse/features/dashboard/domain/usecase/get_dashboard_recent_sessions_usecase.dart';
import 'package:lighthouse/features/dashboard/domain/usecase/get_dashboard_revenue_chart_usecase.dart';
import 'package:lighthouse/features/dashboard/domain/usecase/get_dashboard_summary_usecase.dart';
import 'package:lighthouse/features/dashboard/presentation/bloc/get_dashboard_alerts_bloc.dart';
import 'package:lighthouse/features/dashboard/presentation/bloc/get_dashboard_recent_sessions_bloc.dart';
import 'package:lighthouse/features/dashboard/presentation/bloc/get_dashboard_revenue_chart_bloc.dart';
import 'package:lighthouse/features/dashboard/presentation/bloc/get_dashboard_summary_bloc.dart';
import 'package:lighthouse/features/dashboard/presentation/widget/dashboard_summary_cards.dart';
import 'package:lighthouse/features/dashboard/presentation/widget/dashboard_summary_table.dart';
import 'package:lighthouse/features/dashboard/presentation/widget/dashboard_revenue_chart.dart';
import 'package:lighthouse/features/dashboard/presentation/widget/dashboard_recent_sessions.dart';
import 'package:lighthouse/features/dashboard/presentation/widget/dashboard_alerts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _selectedPeriod = 'daily';
  bool _isTableView = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetDashboardSummaryBloc(
            getDashboardSummaryUsecase: GetDashboardSummaryUsecase(
              getDashboardSummaryRepo: GetDashboardSummaryRepo(
                getDashboardSummaryService: GetDashboardSummaryService(dio: Dio()),
                networkConnection: NetworkConnection.createDefault(),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => GetDashboardRevenueChartBloc(
            getDashboardRevenueChartUsecase: GetDashboardRevenueChartUsecase(
              getDashboardRevenueChartRepo: GetDashboardRevenueChartRepo(
                getDashboardRevenueChartService: GetDashboardRevenueChartService(dio: Dio()),
                networkConnection: NetworkConnection.createDefault(),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => GetDashboardRecentSessionsBloc(
            getDashboardRecentSessionsUsecase: GetDashboardRecentSessionsUsecase(
              getDashboardRecentSessionsRepo: GetDashboardRecentSessionsRepo(
                getDashboardRecentSessionsService: GetDashboardRecentSessionsService(dio: Dio()),
                networkConnection: NetworkConnection.createDefault(),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => GetDashboardAlertsBloc(
            getDashboardAlertsUsecase: GetDashboardAlertsUsecase(
              getDashboardAlertsRepo: GetDashboardAlertsRepo(
                getDashboardAlertsService: GetDashboardAlertsService(dio: Dio()),
                networkConnection: NetworkConnection.createDefault(),
              ),
            ),
          ),
        ),
      ],
      child: Builder(
        builder: (builderContext) {
          // Load dashboard data on first build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            builderContext.read<GetDashboardSummaryBloc>().add(GetDashboardSummary());
            // Reverse the period: daily -> monthly, monthly -> daily
            String apiPeriod = _selectedPeriod;
            if (_selectedPeriod == 'daily') {
              apiPeriod = 'monthly';
            } else if (_selectedPeriod == 'monthly') {
              apiPeriod = 'daily';
            }
            builderContext.read<GetDashboardRevenueChartBloc>().add(
                  GetDashboardRevenueChart(period: apiPeriod),
                );
            builderContext.read<GetDashboardRecentSessionsBloc>().add(
                  GetDashboardRecentSessions(limit: 10),
                );
            builderContext.read<GetDashboardAlertsBloc>().add(GetDashboardAlerts());
          });

          return Scaffold(
            backgroundColor: darkNavy,
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Desktop Title
                      if (Responsive.isDesktop(context))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          orange.withOpacity(0.25),
                                          orange.withOpacity(0.15),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: orange.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.dashboard_rounded,
                                      color: orange,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    "Dashboard".tr(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              // View Toggle
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1A2F4A),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.1),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildViewToggleButton(
                                      builderContext,
                                      "Cards View".tr(),
                                      Icons.view_module,
                                      _isTableView == false,
                                      () {
                                        setState(() {
                                          _isTableView = false;
                                        });
                                      },
                                    ),
                                    Container(
                                      width: 1,
                                      height: 32,
                                      color: Colors.white.withOpacity(0.1),
                                    ),
                                    _buildViewToggleButton(
                                      builderContext,
                                      "Table View".tr(),
                                      Icons.table_chart,
                                      _isTableView == true,
                                      () {
                                        setState(() {
                                          _isTableView = true;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (!Responsive.isDesktop(context)) ...[
                        // Mobile View Toggle
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1A2F4A),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.1),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildViewToggleButton(
                                      builderContext,
                                      "Cards View".tr(),
                                      Icons.view_module,
                                      _isTableView == false,
                                      () {
                                        setState(() {
                                          _isTableView = false;
                                        });
                                      },
                                    ),
                                    Container(
                                      width: 1,
                                      height: 32,
                                      color: Colors.white.withOpacity(0.1),
                                    ),
                                    _buildViewToggleButton(
                                      builderContext,
                                      "Table View".tr(),
                                      Icons.table_chart,
                                      _isTableView == true,
                                      () {
                                        setState(() {
                                          _isTableView = true;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      // Summary Cards or Table
                      _isTableView
                          ? DashboardSummaryTable(isMobile: isMobile)
                          : DashboardSummaryCards(isMobile: isMobile),
                      const SizedBox(height: 24),
                      // Revenue Chart
                      DashboardRevenueChart(
                        isMobile: isMobile,
                        selectedPeriod: _selectedPeriod,
                        onPeriodChanged: (period) {
                          setState(() {
                            _selectedPeriod = period;
                          });
                          // Reverse the period: daily -> monthly, monthly -> daily
                          String apiPeriod = period;
                          if (period == 'daily') {
                            apiPeriod = 'monthly';
                          } else if (period == 'monthly') {
                            apiPeriod = 'daily';
                          }
                          builderContext.read<GetDashboardRevenueChartBloc>().add(
                                GetDashboardRevenueChart(period: apiPeriod),
                              );
                        },
                      ),
                      const SizedBox(height: 24),
                      // Recent Sessions and Alerts
                      if (isMobile)
                        Column(
                          children: [
                            DashboardRecentSessions(isMobile: isMobile),
                            const SizedBox(height: 24),
                            DashboardAlerts(isMobile: isMobile),
                          ],
                        )
                      else
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: DashboardRecentSessions(isMobile: isMobile),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 1,
                              child: DashboardAlerts(isMobile: isMobile),
                            ),
                          ],
                        ),
                      const SizedBox(height: 24),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildViewToggleButton(
    BuildContext context,
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? Colors.blue.shade300
                  : Colors.white.withOpacity(0.6),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.blue.shade300
                    : Colors.white.withOpacity(0.6),
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

