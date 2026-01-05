import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/utils/responsive.dart';
import 'package:lighthouse/features/statistics/data/repository/get_statistics_buffet_repo.dart';
import 'package:lighthouse/features/statistics/data/repository/get_statistics_comparison_repo.dart';
import 'package:lighthouse/features/statistics/data/repository/get_statistics_coupons_repo.dart';
import 'package:lighthouse/features/statistics/data/repository/get_statistics_overview_repo.dart';
import 'package:lighthouse/features/statistics/data/repository/get_statistics_packages_repo.dart';
import 'package:lighthouse/features/statistics/data/repository/get_statistics_real_time_repo.dart';
import 'package:lighthouse/features/statistics/data/source/remote/get_statistics_buffet_service.dart';
import 'package:lighthouse/features/statistics/data/source/remote/get_statistics_comparison_service.dart';
import 'package:lighthouse/features/statistics/data/source/remote/get_statistics_coupons_service.dart';
import 'package:lighthouse/features/statistics/data/source/remote/get_statistics_overview_service.dart';
import 'package:lighthouse/features/statistics/data/source/remote/get_statistics_packages_service.dart';
import 'package:lighthouse/features/statistics/data/source/remote/get_statistics_real_time_service.dart';
import 'package:lighthouse/features/statistics/domain/usecase/get_statistics_buffet_usecase.dart';
import 'package:lighthouse/features/statistics/domain/usecase/get_statistics_comparison_usecase.dart';
import 'package:lighthouse/features/statistics/domain/usecase/get_statistics_coupons_usecase.dart';
import 'package:lighthouse/features/statistics/domain/usecase/get_statistics_overview_usecase.dart';
import 'package:lighthouse/features/statistics/domain/usecase/get_statistics_packages_usecase.dart';
import 'package:lighthouse/features/statistics/domain/usecase/get_statistics_real_time_usecase.dart';
import 'package:lighthouse/features/statistics/presentation/bloc/get_statistics_buffet_bloc.dart';
import 'package:lighthouse/features/statistics/presentation/bloc/get_statistics_comparison_bloc.dart';
import 'package:lighthouse/features/statistics/presentation/bloc/get_statistics_coupons_bloc.dart';
import 'package:lighthouse/features/statistics/presentation/bloc/get_statistics_overview_bloc.dart';
import 'package:lighthouse/features/statistics/presentation/bloc/get_statistics_packages_bloc.dart';
import 'package:lighthouse/features/statistics/presentation/bloc/get_statistics_real_time_bloc.dart';
import 'package:lighthouse/features/statistics/presentation/widget/statistics_card_widget.dart';
import 'package:lighthouse/features/statistics/presentation/widget/revenue_chart_widget.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  DateTime? _fromDate;
  DateTime? _toDate;
  DateTime? _previousFromDate;
  DateTime? _previousToDate;

  @override
  void initState() {
    super.initState();
    // Set default date range to current month
    final now = DateTime.now();
    _fromDate = DateTime(now.year, now.month, 1);
    _toDate = now;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetStatisticsOverviewBloc(
            getStatisticsOverviewUsecase: GetStatisticsOverviewUsecase(
              getStatisticsOverviewRepo: GetStatisticsOverviewRepo(
                getStatisticsOverviewService:
                    GetStatisticsOverviewService(dio: Dio()),
                networkConnection: NetworkConnection.createDefault(),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => GetStatisticsRealTimeBloc(
            getStatisticsRealTimeUsecase: GetStatisticsRealTimeUsecase(
              getStatisticsRealTimeRepo: GetStatisticsRealTimeRepo(
                getStatisticsRealTimeService:
                    GetStatisticsRealTimeService(dio: Dio()),
                networkConnection: NetworkConnection.createDefault(),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => GetStatisticsBuffetBloc(
            getStatisticsBuffetUsecase: GetStatisticsBuffetUsecase(
              getStatisticsBuffetRepo: GetStatisticsBuffetRepo(
                getStatisticsBuffetService:
                    GetStatisticsBuffetService(dio: Dio()),
                networkConnection: NetworkConnection.createDefault(),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => GetStatisticsPackagesBloc(
            getStatisticsPackagesUsecase: GetStatisticsPackagesUsecase(
              getStatisticsPackagesRepo: GetStatisticsPackagesRepo(
                getStatisticsPackagesService:
                    GetStatisticsPackagesService(dio: Dio()),
                networkConnection: NetworkConnection.createDefault(),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => GetStatisticsCouponsBloc(
            getStatisticsCouponsUsecase: GetStatisticsCouponsUsecase(
              getStatisticsCouponsRepo: GetStatisticsCouponsRepo(
                getStatisticsCouponsService:
                    GetStatisticsCouponsService(dio: Dio()),
                networkConnection: NetworkConnection.createDefault(),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => GetStatisticsComparisonBloc(
            getStatisticsComparisonUsecase: GetStatisticsComparisonUsecase(
              getStatisticsComparisonRepo: GetStatisticsComparisonRepo(
                getStatisticsComparisonService:
                    GetStatisticsComparisonService(dio: Dio()),
                networkConnection: NetworkConnection.createDefault(),
              ),
            ),
          ),
        ),
      ],
      child: Builder(
        builder: (builderContext) {
          // Load statistics on first build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final from = _fromDate != null
                ? "${_fromDate!.year}-${_fromDate!.month.toString().padLeft(2, '0')}-${_fromDate!.day.toString().padLeft(2, '0')}"
                : null;
            final to = _toDate != null
                ? "${_toDate!.year}-${_toDate!.month.toString().padLeft(2, '0')}-${_toDate!.day.toString().padLeft(2, '0')}"
                : null;

            builderContext.read<GetStatisticsOverviewBloc>().add(
                  GetStatisticsOverview(from: from, to: to),
                );
            builderContext
                .read<GetStatisticsRealTimeBloc>()
                .add(GetStatisticsRealTime());

            // Load additional statistics
            final fromDate = _fromDate != null
                ? "${_fromDate!.year}-${_fromDate!.month.toString().padLeft(2, '0')}-${_fromDate!.day.toString().padLeft(2, '0')}"
                : null;
            final toDate = _toDate != null
                ? "${_toDate!.year}-${_toDate!.month.toString().padLeft(2, '0')}-${_toDate!.day.toString().padLeft(2, '0')}"
                : null;

            builderContext.read<GetStatisticsBuffetBloc>().add(
                  GetStatisticsBuffet(from: fromDate, to: toDate, top: 10),
                );
            builderContext.read<GetStatisticsPackagesBloc>().add(
                  GetStatisticsPackages(from: fromDate, to: toDate),
                );
            builderContext.read<GetStatisticsCouponsBloc>().add(
                  GetStatisticsCoupons(from: fromDate, to: toDate, top: 10),
                );

            // Load comparison statistics if all dates are set
            if (_fromDate != null &&
                _toDate != null &&
                _previousFromDate != null &&
                _previousToDate != null) {
              final currentFrom =
                  "${_fromDate!.year}-${_fromDate!.month.toString().padLeft(2, '0')}-${_fromDate!.day.toString().padLeft(2, '0')}";
              final currentTo =
                  "${_toDate!.year}-${_toDate!.month.toString().padLeft(2, '0')}-${_toDate!.day.toString().padLeft(2, '0')}";
              final prevFrom =
                  "${_previousFromDate!.year}-${_previousFromDate!.month.toString().padLeft(2, '0')}-${_previousFromDate!.day.toString().padLeft(2, '0')}";
              final prevTo =
                  "${_previousToDate!.year}-${_previousToDate!.month.toString().padLeft(2, '0')}-${_previousToDate!.day.toString().padLeft(2, '0')}";
              builderContext.read<GetStatisticsComparisonBloc>().add(
                    GetStatisticsComparison(
                      currentFrom: currentFrom,
                      currentTo: currentTo,
                      previousFrom: prevFrom,
                      previousTo: prevTo,
                    ),
                  );
            }
          });

          return Scaffold(
            backgroundColor: null,
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
                                child: Icon(Icons.analytics,
                                    color: orange, size: 32),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                "Statistics".tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.4),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      // Date Range Picker
                      _buildDateRangePicker(builderContext, context, isMobile),
                      const SizedBox(height: 24),
                      // Real-time Statistics
                      BlocBuilder<GetStatisticsRealTimeBloc,
                          GetStatisticsRealTimeState>(
                        builder: (context, state) {
                          if (state is SuccessGetStatisticsRealTime) {
                            return _buildRealTimeSection(
                                context, state.response.body, isMobile);
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      const SizedBox(height: 24),
                      // Overview Statistics
                      BlocBuilder<GetStatisticsOverviewBloc,
                          GetStatisticsOverviewState>(
                        builder: (context, state) {
                          if (state is LoadingGetStatisticsOverview) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(40.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else if (state is ExceptionGetStatisticsOverview) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(40.0),
                                child: Text(
                                  state.message,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            );
                          } else if (state is SuccessGetStatisticsOverview) {
                            return _buildOverviewContent(
                                builderContext, state.response.body, isMobile);
                          }
                          return const SizedBox.shrink();
                        },
                      ),
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

  Widget _buildDateRangePicker(
      BuildContext blocContext, BuildContext dialogContext, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A2F4A),
            const Color(0xFF0F1E2E),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: orange.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: dialogContext,
                  initialDate: _fromDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _fromDate = date;
                    // Reload statistics
                    final from = _fromDate != null
                        ? "${_fromDate!.year}-${_fromDate!.month.toString().padLeft(2, '0')}-${_fromDate!.day.toString().padLeft(2, '0')}"
                        : null;
                    final to = _toDate != null
                        ? "${_toDate!.year}-${_toDate!.month.toString().padLeft(2, '0')}-${_toDate!.day.toString().padLeft(2, '0')}"
                        : null;
                    blocContext.read<GetStatisticsOverviewBloc>().add(
                          GetStatisticsOverview(from: from, to: to),
                        );
                    blocContext.read<GetStatisticsBuffetBloc>().add(
                          GetStatisticsBuffet(from: from, to: to, top: 10),
                        );
                    blocContext.read<GetStatisticsPackagesBloc>().add(
                          GetStatisticsPackages(from: from, to: to),
                        );
                    blocContext.read<GetStatisticsCouponsBloc>().add(
                          GetStatisticsCoupons(from: from, to: to, top: 10),
                        );
                  });
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      orange.withOpacity(0.15),
                      orange.withOpacity(0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: orange.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today, color: orange, size: 20),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        _fromDate != null
                            ? "${_fromDate!.year}-${_fromDate!.month.toString().padLeft(2, '0')}-${_fromDate!.day.toString().padLeft(2, '0')}"
                            : "From Date".tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: dialogContext,
                  initialDate: _toDate ?? DateTime.now(),
                  firstDate: _fromDate ?? DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _toDate = date;
                    // Reload statistics
                    final from = _fromDate != null
                        ? "${_fromDate!.year}-${_fromDate!.month.toString().padLeft(2, '0')}-${_fromDate!.day.toString().padLeft(2, '0')}"
                        : null;
                    final to = _toDate != null
                        ? "${_toDate!.year}-${_toDate!.month.toString().padLeft(2, '0')}-${_toDate!.day.toString().padLeft(2, '0')}"
                        : null;
                    blocContext.read<GetStatisticsOverviewBloc>().add(
                          GetStatisticsOverview(from: from, to: to),
                        );
                    blocContext.read<GetStatisticsBuffetBloc>().add(
                          GetStatisticsBuffet(from: from, to: to, top: 10),
                        );
                    blocContext.read<GetStatisticsPackagesBloc>().add(
                          GetStatisticsPackages(from: from, to: to),
                        );
                    blocContext.read<GetStatisticsCouponsBloc>().add(
                          GetStatisticsCoupons(from: from, to: to, top: 10),
                        );
                  });
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      orange.withOpacity(0.15),
                      orange.withOpacity(0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: orange.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today, color: orange, size: 20),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        _toDate != null
                            ? "${_toDate!.year}-${_toDate!.month.toString().padLeft(2, '0')}-${_toDate!.day.toString().padLeft(2, '0')}"
                            : "To Date".tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRealTimeSection(
      BuildContext context, dynamic realTime, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            orange.withOpacity(0.15),
            orange.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: orange.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: orange.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      orange.withOpacity(0.3),
                      orange.withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: orange.withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: Icon(Icons.access_time, color: orange, size: 24),
              ),
              const SizedBox(width: 16),
              Text(
                "Real-time Statistics".tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (isMobile)
            Column(
              children: [
                _buildRealTimeCard("Active Sessions".tr(),
                    "${realTime.activeSessions}", Icons.people, Colors.blue),
                const SizedBox(height: 16),
                _buildRealTimeCard(
                    "Today Revenue".tr(),
                    "${realTime.todayRevenue.toStringAsFixed(0)} S.P",
                    Icons.attach_money,
                    Colors.green),
                const SizedBox(height: 16),
                _buildRealTimeCard("Today Sessions".tr(),
                    "${realTime.todaySessions}", Icons.event, Colors.purple),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: _buildRealTimeCard("Active Sessions".tr(),
                      "${realTime.activeSessions}", Icons.people, Colors.blue),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildRealTimeCard(
                      "Today Revenue".tr(),
                      "${realTime.todayRevenue.toStringAsFixed(0)} S.P",
                      Icons.attach_money,
                      Colors.green),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildRealTimeCard("Today Sessions".tr(),
                      "${realTime.todaySessions}", Icons.event, Colors.purple),
                ),
              ],
            ),
          const SizedBox(height: 16),
          if (isMobile)
            Column(
              children: [
                _buildRealTimeCard(
                    "Current Hour Revenue".tr(),
                    "${realTime.currentHourRevenue.toStringAsFixed(0)} S.P",
                    Icons.access_time,
                    Colors.orange),
                const SizedBox(height: 16),
                _buildRealTimeCard(
                    "Active Premium Sessions".tr(),
                    "${realTime.activePremiumSessions}",
                    Icons.stars,
                    Colors.amber),
                if (realTime.peakHours.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildPeakHoursSection(realTime.peakHours, isMobile),
                ],
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: _buildRealTimeCard(
                      "Current Hour Revenue".tr(),
                      "${realTime.currentHourRevenue.toStringAsFixed(0)} S.P",
                      Icons.access_time,
                      Colors.orange),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildRealTimeCard(
                      "Active Premium Sessions".tr(),
                      "${realTime.activePremiumSessions}",
                      Icons.stars,
                      Colors.amber),
                ),
              ],
            ),
          if (realTime.peakHours.isNotEmpty && !isMobile) ...[
            const SizedBox(height: 16),
            _buildPeakHoursSection(realTime.peakHours, isMobile),
          ],
        ],
      ),
    );
  }

  Widget _buildPeakHoursSection(List<String> peakHours, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A2F4A),
            const Color(0xFF0F1E2E),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: orange.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, color: orange, size: 20),
              const SizedBox(width: 8),
              Text(
                "Peak Hours".tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: peakHours
                .map((hour) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: orange.withOpacity(0.4),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        hour,
                        style: TextStyle(
                          color: orange,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRealTimeCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(color: grey, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: navy,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewContent(
      BuildContext context, dynamic overview, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Revenue Cards
        _buildSectionTitle("Revenue Statistics".tr(), Icons.attach_money),
        const SizedBox(height: 16),
        if (isMobile)
          Column(
            children: [
              StatisticsCardWidget(
                title: "Total Revenue".tr(),
                value:
                    "${overview.revenue.totalRevenue.toStringAsFixed(0)} S.P",
                icon: Icons.account_balance_wallet,
                iconColor: Colors.green,
                isMobile: true,
              ),
              const SizedBox(height: 16),
              StatisticsCardWidget(
                title: "Revenue Before Discounts".tr(),
                value:
                    "${overview.revenue.revenueBeforeDiscounts.toStringAsFixed(0)} S.P",
                icon: Icons.money_off,
                iconColor: Colors.blue,
                isMobile: true,
              ),
              const SizedBox(height: 16),
              StatisticsCardWidget(
                title: "Session Revenue".tr(),
                value:
                    "${overview.revenue.sessionRevenue.toStringAsFixed(0)} S.P",
                icon: Icons.event_seat,
                iconColor: orange,
                isMobile: true,
              ),
              const SizedBox(height: 16),
              StatisticsCardWidget(
                title: "Buffet Revenue".tr(),
                value:
                    "${overview.revenue.buffetRevenue.toStringAsFixed(0)} S.P",
                icon: Icons.restaurant,
                iconColor: Colors.brown.shade400,
                isMobile: true,
              ),
              const SizedBox(height: 16),
              StatisticsCardWidget(
                title: "Packages Revenue".tr(),
                value:
                    "${overview.revenue.packagesRevenue.toStringAsFixed(0)} S.P",
                icon: Icons.inventory,
                iconColor: Colors.purple,
                isMobile: true,
              ),
              const SizedBox(height: 16),
              StatisticsCardWidget(
                title: "Premium Revenue".tr(),
                value:
                    "${overview.revenue.premiumRevenue.toStringAsFixed(0)} S.P",
                icon: Icons.stars,
                iconColor: Colors.amber,
                isMobile: true,
              ),
              const SizedBox(height: 16),
              StatisticsCardWidget(
                title: "Coupon Discounts".tr(),
                value:
                    "${overview.revenue.couponDiscounts.toStringAsFixed(0)} S.P",
                icon: Icons.local_offer,
                iconColor: Colors.pink,
                isMobile: true,
              ),
              const SizedBox(height: 16),
              StatisticsCardWidget(
                title: "Manual Discounts".tr(),
                value:
                    "${overview.revenue.manualDiscounts.toStringAsFixed(0)} S.P",
                icon: Icons.edit,
                iconColor: Colors.red,
                isMobile: true,
              ),
              const SizedBox(height: 16),
              StatisticsCardWidget(
                title: "Net Revenue".tr(),
                value: "${overview.revenue.netRevenue.toStringAsFixed(0)} S.P",
                icon: Icons.trending_up,
                iconColor: Colors.teal,
                isMobile: true,
              ),
            ],
          )
        else
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: StatisticsCardWidget(
                      title: "Total Revenue".tr(),
                      value:
                          "${overview.revenue.totalRevenue.toStringAsFixed(0)} S.P",
                      icon: Icons.account_balance_wallet,
                      iconColor: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatisticsCardWidget(
                      title: "Revenue Before Discounts".tr(),
                      value:
                          "${overview.revenue.revenueBeforeDiscounts.toStringAsFixed(0)} S.P",
                      icon: Icons.money_off,
                      iconColor: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatisticsCardWidget(
                      title: "Net Revenue".tr(),
                      value:
                          "${overview.revenue.netRevenue.toStringAsFixed(0)} S.P",
                      icon: Icons.trending_up,
                      iconColor: Colors.teal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: StatisticsCardWidget(
                      title: "Session Revenue".tr(),
                      value:
                          "${overview.revenue.sessionRevenue.toStringAsFixed(0)} S.P",
                      icon: Icons.event_seat,
                      iconColor: orange,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatisticsCardWidget(
                      title: "Buffet Revenue".tr(),
                      value:
                          "${overview.revenue.buffetRevenue.toStringAsFixed(0)} S.P",
                      icon: Icons.restaurant,
                      iconColor: Colors.brown.shade400,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatisticsCardWidget(
                      title: "Packages Revenue".tr(),
                      value:
                          "${overview.revenue.packagesRevenue.toStringAsFixed(0)} S.P",
                      icon: Icons.inventory,
                      iconColor: Colors.purple,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatisticsCardWidget(
                      title: "Premium Revenue".tr(),
                      value:
                          "${overview.revenue.premiumRevenue.toStringAsFixed(0)} S.P",
                      icon: Icons.stars,
                      iconColor: Colors.amber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: StatisticsCardWidget(
                      title: "Coupon Discounts".tr(),
                      value:
                          "${overview.revenue.couponDiscounts.toStringAsFixed(0)} S.P",
                      icon: Icons.local_offer,
                      iconColor: Colors.pink,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatisticsCardWidget(
                      title: "Manual Discounts".tr(),
                      value:
                          "${overview.revenue.manualDiscounts.toStringAsFixed(0)} S.P",
                      icon: Icons.edit,
                      iconColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        const SizedBox(height: 24),
        // Revenue Chart
        RevenueChartWidget(
          sessionRevenue: overview.revenue.sessionRevenue,
          buffetRevenue: overview.revenue.buffetRevenue,
          packagesRevenue: overview.revenue.packagesRevenue,
          totalRevenue: overview.revenue.totalRevenue,
          isMobile: isMobile,
        ),
        const SizedBox(height: 24),
        // Sessions Cards
        _buildSectionTitle("Sessions Statistics".tr(), Icons.event),
        const SizedBox(height: 16),
        if (isMobile)
          Column(
            children: [
              StatisticsCardWidget(
                title: "Total Sessions".tr(),
                value: "${overview.sessions.totalSessions}",
                icon: Icons.event,
                iconColor: Colors.blue,
                isMobile: true,
              ),
              const SizedBox(height: 16),
              StatisticsCardWidget(
                title: "Active Sessions".tr(),
                value: "${overview.sessions.activeSessions}",
                icon: Icons.play_circle,
                iconColor: Colors.green,
                isMobile: true,
              ),
              const SizedBox(height: 16),
              StatisticsCardWidget(
                title: "Completed Sessions".tr(),
                value: "${overview.sessions.completedSessions}",
                icon: Icons.check_circle,
                iconColor: Colors.teal,
                isMobile: true,
              ),
              const SizedBox(height: 16),
              StatisticsCardWidget(
                title: "Premium Sessions".tr(),
                value: "${overview.sessions.premiumSessions}",
                icon: Icons.stars,
                iconColor: Colors.amber,
                isMobile: true,
              ),
              const SizedBox(height: 16),
              StatisticsCardWidget(
                title: "Total Hours".tr(),
                value: "${overview.sessions.totalHours.toStringAsFixed(1)} hrs",
                icon: Icons.access_time,
                iconColor: Colors.teal,
                isMobile: true,
              ),
              const SizedBox(height: 16),
              StatisticsCardWidget(
                title: "Avg Premium Duration".tr(),
                value:
                    "${overview.sessions.averagePremiumDuration.toStringAsFixed(1)} hrs",
                icon: Icons.timer,
                iconColor: Colors.amber,
                isMobile: true,
              ),
              const SizedBox(height: 16),
              StatisticsCardWidget(
                title: "Avg Overall Duration".tr(),
                value:
                    "${overview.sessions.averageOverallDuration.toStringAsFixed(1)} hrs",
                icon: Icons.schedule,
                iconColor: Colors.blue,
                isMobile: true,
              ),
            ],
          )
        else
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: StatisticsCardWidget(
                      title: "Total Sessions".tr(),
                      value: "${overview.sessions.totalSessions}",
                      icon: Icons.event,
                      iconColor: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatisticsCardWidget(
                      title: "Active Sessions".tr(),
                      value: "${overview.sessions.activeSessions}",
                      icon: Icons.play_circle,
                      iconColor: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatisticsCardWidget(
                      title: "Completed Sessions".tr(),
                      value: "${overview.sessions.completedSessions}",
                      icon: Icons.check_circle,
                      iconColor: Colors.teal,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatisticsCardWidget(
                      title: "Total Hours".tr(),
                      value:
                          "${overview.sessions.totalHours.toStringAsFixed(1)} hrs",
                      icon: Icons.access_time,
                      iconColor: Colors.teal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: StatisticsCardWidget(
                      title: "Premium Sessions".tr(),
                      value: "${overview.sessions.premiumSessions}",
                      icon: Icons.stars,
                      iconColor: Colors.amber,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatisticsCardWidget(
                      title: "Avg Premium Duration".tr(),
                      value:
                          "${overview.sessions.averagePremiumDuration.toStringAsFixed(1)} hrs",
                      icon: Icons.timer,
                      iconColor: Colors.amber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: StatisticsCardWidget(
                      title: "Avg Overall Duration".tr(),
                      value:
                          "${overview.sessions.averageOverallDuration.toStringAsFixed(1)} hrs",
                      icon: Icons.schedule,
                      iconColor: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        const SizedBox(height: 24),
        // Users Cards
        _buildSectionTitle("Users Statistics".tr(), Icons.people),
        const SizedBox(height: 16),
        if (isMobile)
          Column(
            children: [
              StatisticsCardWidget(
                title: "Total Premium Users".tr(),
                value: "${overview.users.totalPremiumUsers}",
                icon: Icons.people,
                iconColor: Colors.indigo,
                isMobile: true,
              ),
              const SizedBox(height: 16),
              StatisticsCardWidget(
                title: "Active Users".tr(),
                value: "${overview.users.activePremiumUsers}",
                icon: Icons.person,
                iconColor: Colors.green,
                isMobile: true,
              ),
              const SizedBox(height: 16),
              StatisticsCardWidget(
                title: "New Users".tr(),
                value: "${overview.users.newUsers}",
                icon: Icons.person_add,
                iconColor: orange,
                isMobile: true,
              ),
              const SizedBox(height: 16),
              StatisticsCardWidget(
                title: "Users With Packages".tr(),
                value: "${overview.users.usersWithPackages}",
                icon: Icons.inventory,
                iconColor: Colors.blue,
                isMobile: true,
              ),
            ],
          )
        else
          Row(
            children: [
              Expanded(
                child: StatisticsCardWidget(
                  title: "Total Premium Users".tr(),
                  value: "${overview.users.totalPremiumUsers}",
                  icon: Icons.people,
                  iconColor: Colors.indigo,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatisticsCardWidget(
                  title: "Active Users".tr(),
                  value: "${overview.users.activePremiumUsers}",
                  icon: Icons.person,
                  iconColor: Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatisticsCardWidget(
                  title: "New Users".tr(),
                  value: "${overview.users.newUsers}",
                  icon: Icons.person_add,
                  iconColor: orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatisticsCardWidget(
                  title: "Users With Packages".tr(),
                  value: "${overview.users.usersWithPackages}",
                  icon: Icons.inventory,
                  iconColor: Colors.blue,
                ),
              ),
            ],
          ),
        if (overview.users.topActiveUsers.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildTopActiveUsersSection(overview.users.topActiveUsers, isMobile),
        ],
        const SizedBox(height: 24),
        // Buffet Statistics
        _buildSectionTitle("Buffet Statistics".tr(), Icons.restaurant),
        const SizedBox(height: 16),
        BlocBuilder<GetStatisticsBuffetBloc, GetStatisticsBuffetState>(
          builder: (context, state) {
            if (state is SuccessGetStatisticsBuffet) {
              final buffet = state.response.body;
              if (isMobile)
                return Column(
                  children: [
                    StatisticsCardWidget(
                      title: "Total Revenue".tr(),
                      value: "${buffet.totalRevenue.toStringAsFixed(0)} S.P",
                      icon: Icons.attach_money,
                      iconColor: Colors.brown.shade400,
                      isMobile: true,
                    ),
                    const SizedBox(height: 16),
                    StatisticsCardWidget(
                      title: "Average Per Session".tr(),
                      value:
                          "${buffet.averagePerSession.toStringAsFixed(0)} S.P",
                      icon: Icons.trending_up,
                      iconColor: Colors.orange,
                      isMobile: true,
                    ),
                    const SizedBox(height: 16),
                    StatisticsCardWidget(
                      title: "Total Orders".tr(),
                      value: "${buffet.totalOrders}",
                      icon: Icons.shopping_cart,
                      iconColor: Colors.green,
                      isMobile: true,
                    ),
                    if (buffet.topSellingProducts.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildTopProductsSection(
                          buffet.topSellingProducts, isMobile),
                    ],
                  ],
                );
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatisticsCardWidget(
                          title: "Total Revenue".tr(),
                          value:
                              "${buffet.totalRevenue.toStringAsFixed(0)} S.P",
                          icon: Icons.attach_money,
                          iconColor: Colors.brown.shade400,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatisticsCardWidget(
                          title: "Average Per Session".tr(),
                          value:
                              "${buffet.averagePerSession.toStringAsFixed(0)} S.P",
                          icon: Icons.trending_up,
                          iconColor: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatisticsCardWidget(
                          title: "Total Orders".tr(),
                          value: "${buffet.totalOrders}",
                          icon: Icons.shopping_cart,
                          iconColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  if (buffet.topSellingProducts.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildTopProductsSection(
                        buffet.topSellingProducts, isMobile),
                  ],
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(height: 24),
        // Packages Statistics
        _buildSectionTitle("Packages Statistics".tr(), Icons.inventory),
        const SizedBox(height: 16),
        BlocBuilder<GetStatisticsPackagesBloc, GetStatisticsPackagesState>(
          builder: (context, state) {
            if (state is SuccessGetStatisticsPackages) {
              final packages = state.response.body;
              if (isMobile)
                return Column(
                  children: [
                    StatisticsCardWidget(
                      title: "Total Packages Sold".tr(),
                      value: "${packages.totalPackagesSold}",
                      icon: Icons.shopping_bag,
                      iconColor: Colors.blue,
                      isMobile: true,
                    ),
                    const SizedBox(height: 16),
                    StatisticsCardWidget(
                      title: "Active Packages".tr(),
                      value: "${packages.activePackages}",
                      icon: Icons.check_circle,
                      iconColor: Colors.green,
                      isMobile: true,
                    ),
                    const SizedBox(height: 16),
                    StatisticsCardWidget(
                      title: "Utilization Rate".tr(),
                      value: "${packages.utilizationRate.toStringAsFixed(1)}%",
                      icon: Icons.percent,
                      iconColor: Colors.orange,
                      isMobile: true,
                    ),
                    const SizedBox(height: 16),
                    StatisticsCardWidget(
                      title: "Total Revenue".tr(),
                      value: "${packages.totalRevenue.toStringAsFixed(0)} S.P",
                      icon: Icons.account_balance_wallet,
                      iconColor: Colors.purple,
                      isMobile: true,
                    ),
                    const SizedBox(height: 16),
                    StatisticsCardWidget(
                      title: "Expired Packages".tr(),
                      value: "${packages.expiredPackages}",
                      icon: Icons.cancel,
                      iconColor: Colors.red,
                      isMobile: true,
                    ),
                    const SizedBox(height: 16),
                    StatisticsCardWidget(
                      title: "Average Package Value".tr(),
                      value:
                          "${packages.averagePackageValue.toStringAsFixed(0)} S.P",
                      icon: Icons.attach_money,
                      iconColor: Colors.green,
                      isMobile: true,
                    ),
                    const SizedBox(height: 16),
                    StatisticsCardWidget(
                      title: "Total Hours Purchased".tr(),
                      value:
                          "${packages.totalHoursPurchased.toStringAsFixed(1)} hrs",
                      icon: Icons.shopping_cart,
                      iconColor: Colors.blue,
                      isMobile: true,
                    ),
                    const SizedBox(height: 16),
                    StatisticsCardWidget(
                      title: "Total Hours Consumed".tr(),
                      value:
                          "${packages.totalHoursConsumed.toStringAsFixed(1)} hrs",
                      icon: Icons.hourglass_bottom,
                      iconColor: Colors.orange,
                      isMobile: true,
                    ),
                    const SizedBox(height: 16),
                    StatisticsCardWidget(
                      title: "Remaining Hours".tr(),
                      value:
                          "${packages.remainingHours.toStringAsFixed(1)} hrs",
                      icon: Icons.hourglass_top,
                      iconColor: Colors.teal,
                      isMobile: true,
                    ),
                    if (packages.popularPackages.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildPopularPackagesSection(
                          packages.popularPackages, isMobile),
                    ],
                  ],
                );
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatisticsCardWidget(
                          title: "Total Packages Sold".tr(),
                          value: "${packages.totalPackagesSold}",
                          icon: Icons.shopping_bag,
                          iconColor: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatisticsCardWidget(
                          title: "Active Packages".tr(),
                          value: "${packages.activePackages}",
                          icon: Icons.check_circle,
                          iconColor: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatisticsCardWidget(
                          title: "Expired Packages".tr(),
                          value: "${packages.expiredPackages}",
                          icon: Icons.cancel,
                          iconColor: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatisticsCardWidget(
                          title: "Utilization Rate".tr(),
                          value:
                              "${packages.utilizationRate.toStringAsFixed(1)}%",
                          icon: Icons.percent,
                          iconColor: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: StatisticsCardWidget(
                          title: "Total Revenue".tr(),
                          value:
                              "${packages.totalRevenue.toStringAsFixed(0)} S.P",
                          icon: Icons.account_balance_wallet,
                          iconColor: Colors.purple,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatisticsCardWidget(
                          title: "Average Package Value".tr(),
                          value:
                              "${packages.averagePackageValue.toStringAsFixed(0)} S.P",
                          icon: Icons.attach_money,
                          iconColor: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatisticsCardWidget(
                          title: "Total Hours Purchased".tr(),
                          value:
                              "${packages.totalHoursPurchased.toStringAsFixed(1)} hrs",
                          icon: Icons.shopping_cart,
                          iconColor: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatisticsCardWidget(
                          title: "Total Hours Consumed".tr(),
                          value:
                              "${packages.totalHoursConsumed.toStringAsFixed(1)} hrs",
                          icon: Icons.hourglass_bottom,
                          iconColor: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: StatisticsCardWidget(
                          title: "Remaining Hours".tr(),
                          value:
                              "${packages.remainingHours.toStringAsFixed(1)} hrs",
                          icon: Icons.hourglass_top,
                          iconColor: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                  if (packages.popularPackages.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildPopularPackagesSection(
                        packages.popularPackages, isMobile),
                  ],
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(height: 24),
        // Coupons Statistics
        _buildSectionTitle("Coupons Statistics".tr(), Icons.local_offer),
        const SizedBox(height: 16),
        BlocBuilder<GetStatisticsCouponsBloc, GetStatisticsCouponsState>(
          builder: (context, state) {
            if (state is SuccessGetStatisticsCoupons) {
              final coupons = state.response.body;
              if (isMobile)
                return Column(
                  children: [
                    StatisticsCardWidget(
                      title: "Total Coupons".tr(),
                      value: "${coupons.totalCoupons}",
                      icon: Icons.confirmation_number,
                      iconColor: Colors.pink,
                      isMobile: true,
                    ),
                    const SizedBox(height: 16),
                    StatisticsCardWidget(
                      title: "Active Coupons".tr(),
                      value: "${coupons.activeCoupons}",
                      icon: Icons.check_circle,
                      iconColor: Colors.green,
                      isMobile: true,
                    ),
                    const SizedBox(height: 16),
                    StatisticsCardWidget(
                      title: "Total Discount Given".tr(),
                      value:
                          "${coupons.totalDiscountGiven.toStringAsFixed(0)} S.P",
                      icon: Icons.discount,
                      iconColor: Colors.red,
                      isMobile: true,
                    ),
                    const SizedBox(height: 16),
                    StatisticsCardWidget(
                      title: "Used Coupons".tr(),
                      value: "${coupons.usedCoupons}",
                      icon: Icons.check_circle_outline,
                      iconColor: Colors.green,
                      isMobile: true,
                    ),
                    const SizedBox(height: 16),
                    StatisticsCardWidget(
                      title: "Average Discount Per Use".tr(),
                      value:
                          "${coupons.averageDiscountPerUse.toStringAsFixed(0)} S.P",
                      icon: Icons.calculate,
                      iconColor: Colors.blue,
                      isMobile: true,
                    ),
                    const SizedBox(height: 16),
                    StatisticsCardWidget(
                      title: "Total Revenue With Coupons".tr(),
                      value:
                          "${coupons.totalRevenueWithCoupons.toStringAsFixed(0)} S.P",
                      icon: Icons.attach_money,
                      iconColor: Colors.green,
                      isMobile: true,
                    ),
                    const SizedBox(height: 16),
                    StatisticsCardWidget(
                      title: "Net Revenue".tr(),
                      value: "${coupons.netRevenue.toStringAsFixed(0)} S.P",
                      icon: Icons.trending_up,
                      iconColor: Colors.teal,
                      isMobile: true,
                    ),
                    if (coupons.topUsedCoupons.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildTopCouponsSection(coupons.topUsedCoupons, isMobile),
                    ],
                  ],
                );
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatisticsCardWidget(
                          title: "Total Coupons".tr(),
                          value: "${coupons.totalCoupons}",
                          icon: Icons.confirmation_number,
                          iconColor: Colors.pink,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatisticsCardWidget(
                          title: "Active Coupons".tr(),
                          value: "${coupons.activeCoupons}",
                          icon: Icons.check_circle,
                          iconColor: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatisticsCardWidget(
                          title: "Used Coupons".tr(),
                          value: "${coupons.usedCoupons}",
                          icon: Icons.check_circle_outline,
                          iconColor: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatisticsCardWidget(
                          title: "Total Discount Given".tr(),
                          value:
                              "${coupons.totalDiscountGiven.toStringAsFixed(0)} S.P",
                          icon: Icons.discount,
                          iconColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: StatisticsCardWidget(
                          title: "Average Discount Per Use".tr(),
                          value:
                              "${coupons.averageDiscountPerUse.toStringAsFixed(0)} S.P",
                          icon: Icons.calculate,
                          iconColor: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatisticsCardWidget(
                          title: "Total Revenue With Coupons".tr(),
                          value:
                              "${coupons.totalRevenueWithCoupons.toStringAsFixed(0)} S.P",
                          icon: Icons.attach_money,
                          iconColor: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatisticsCardWidget(
                          title: "Net Revenue".tr(),
                          value: "${coupons.netRevenue.toStringAsFixed(0)} S.P",
                          icon: Icons.trending_up,
                          iconColor: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                  if (coupons.topUsedCoupons.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildTopCouponsSection(coupons.topUsedCoupons, isMobile),
                  ],
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(height: 24),
        // Comparison Statistics
        _buildSectionTitle("Period Comparison".tr(), Icons.compare_arrows),
        const SizedBox(height: 16),
        _buildComparisonSection(context, isMobile),
      ],
    );
  }

  Widget _buildComparisonSection(BuildContext context, bool isMobile) {
    // Check if all dates are set
    final allDatesSet = _fromDate != null &&
        _toDate != null &&
        _previousFromDate != null &&
        _previousToDate != null;

    return BlocBuilder<GetStatisticsComparisonBloc,
        GetStatisticsComparisonState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Date Range Selectors - Always visible
            if (isMobile)
              Column(
                children: [
                  _buildComparisonDateSelector(
                    context,
                    "Current Period".tr(),
                    _fromDate,
                    _toDate,
                    (from, to) {
                      setState(() {
                        _fromDate = from;
                        _toDate = to;
                      });
                      _loadComparison(context);
                    },
                    isMobile,
                  ),
                  const SizedBox(height: 16),
                  _buildComparisonDateSelector(
                    context,
                    "Previous Period".tr(),
                    _previousFromDate,
                    _previousToDate,
                    (from, to) {
                      setState(() {
                        _previousFromDate = from;
                        _previousToDate = to;
                      });
                      _loadComparison(context);
                    },
                    isMobile,
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    child: _buildComparisonDateSelector(
                      context,
                      "Current Period".tr(),
                      _fromDate,
                      _toDate,
                      (from, to) {
                        setState(() {
                          _fromDate = from;
                          _toDate = to;
                        });
                        _loadComparison(context);
                      },
                      isMobile,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildComparisonDateSelector(
                      context,
                      "Previous Period".tr(),
                      _previousFromDate,
                      _previousToDate,
                      (from, to) {
                        setState(() {
                          _previousFromDate = from;
                          _previousToDate = to;
                        });
                        _loadComparison(context);
                      },
                      isMobile,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 24),

            // Show content based on state
            if (!allDatesSet)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF1A2F4A),
                      const Color(0xFF0F1E2E),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.white.withOpacity(0.6),
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Please select both current and previous period dates to view comparison"
                          .tr(),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else if (state is LoadingGetStatisticsComparison)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (state is ExceptionGetStatisticsComparison)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Text(
                  state.message,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              )
            else if (state is SuccessGetStatisticsComparison)
              // Show comparison cards
              _buildComparisonCards(state.response.body, isMobile)
            else
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                ),
                child: Text(
                  "Select date ranges to compare periods".tr(),
                  style: TextStyle(color: grey),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildComparisonCards(dynamic comparison, bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          _buildComparisonCard(
            "Revenue".tr(),
            comparison.currentPeriod.revenue,
            comparison.previousPeriod.revenue,
            comparison.change.revenueChange,
            comparison.change.revenueChangeAmount,
            Icons.attach_money,
            Colors.green,
            isMobile,
          ),
          const SizedBox(height: 16),
          _buildComparisonCard(
            "Sessions".tr(),
            comparison.currentPeriod.sessions.toDouble(),
            comparison.previousPeriod.sessions.toDouble(),
            comparison.change.sessionsChange,
            comparison.change.sessionsChangeAmount.toDouble(),
            Icons.event,
            Colors.blue,
            isMobile,
          ),
          const SizedBox(height: 16),
          _buildComparisonCard(
            "Users".tr(),
            comparison.currentPeriod.users.toDouble(),
            comparison.previousPeriod.users.toDouble(),
            comparison.change.usersChange,
            comparison.change.usersChangeAmount.toDouble(),
            Icons.people,
            Colors.purple,
            isMobile,
          ),
          const SizedBox(height: 16),
          _buildComparisonCard(
            "New Users".tr(),
            comparison.currentPeriod.newUsers.toDouble(),
            comparison.previousPeriod.newUsers.toDouble(),
            comparison.change.newUsersChange,
            0.0,
            Icons.person_add,
            orange,
            isMobile,
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: _buildComparisonCard(
              "Revenue".tr(),
              comparison.currentPeriod.revenue,
              comparison.previousPeriod.revenue,
              comparison.change.revenueChange,
              comparison.change.revenueChangeAmount,
              Icons.attach_money,
              Colors.green,
              isMobile,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildComparisonCard(
              "Sessions".tr(),
              comparison.currentPeriod.sessions.toDouble(),
              comparison.previousPeriod.sessions.toDouble(),
              comparison.change.sessionsChange,
              comparison.change.sessionsChangeAmount.toDouble(),
              Icons.event,
              Colors.blue,
              isMobile,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildComparisonCard(
              "Users".tr(),
              comparison.currentPeriod.users.toDouble(),
              comparison.previousPeriod.users.toDouble(),
              comparison.change.usersChange,
              comparison.change.usersChangeAmount.toDouble(),
              Icons.people,
              Colors.purple,
              isMobile,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildComparisonCard(
              "New Users".tr(),
              comparison.currentPeriod.newUsers.toDouble(),
              comparison.previousPeriod.newUsers.toDouble(),
              comparison.change.newUsersChange,
              0.0,
              Icons.person_add,
              orange,
              isMobile,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildComparisonDateSelector(
    BuildContext context,
    String title,
    DateTime? fromDate,
    DateTime? toDate,
    Function(DateTime?, DateTime?) onChanged,
    bool isMobile,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A2F4A),
            const Color(0xFF0F1E2E),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: fromDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      onChanged(date, toDate);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: orange, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            fromDate != null
                                ? "${fromDate.year}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}"
                                : "From".tr(),
                            style: TextStyle(
                              color: fromDate != null ? Colors.white : grey,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: toDate ?? DateTime.now(),
                      firstDate: fromDate ?? DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      onChanged(fromDate, date);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: orange, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            toDate != null
                                ? "${toDate.year}-${toDate.month.toString().padLeft(2, '0')}-${toDate.day.toString().padLeft(2, '0')}"
                                : "To".tr(),
                            style: TextStyle(
                              color: toDate != null ? Colors.white : grey,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonCard(
    String title,
    double currentValue,
    double previousValue,
    String changePercent,
    double changeAmount,
    IconData icon,
    Color iconColor,
    bool isMobile,
  ) {
    final isPositive = changePercent.startsWith('+');
    final changeColor = isPositive ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A2F4A),
            const Color(0xFF0F1E2E),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: iconColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      iconColor.withOpacity(0.25),
                      iconColor.withOpacity(0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: iconColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Current".tr(),
                    style: TextStyle(
                      color: grey.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title == "Revenue".tr()
                        ? "${currentValue.toStringAsFixed(0)} S.P"
                        : currentValue.toStringAsFixed(0),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Previous".tr(),
                    style: TextStyle(
                      color: grey.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title == "Revenue".tr()
                        ? "${previousValue.toStringAsFixed(0)} S.P"
                        : previousValue.toStringAsFixed(0),
                    style: TextStyle(
                      color: grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: changeColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: changeColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive ? Icons.trending_up : Icons.trending_down,
                        color: changeColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          changePercent,
                          style: TextStyle(
                            color: changeColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                if (changeAmount != 0)
                  Flexible(
                    child: Text(
                      title == "Revenue".tr()
                          ? "${isPositive ? '+' : ''}${changeAmount.toStringAsFixed(0)} S.P"
                          : "${isPositive ? '+' : ''}${changeAmount.toStringAsFixed(0)}",
                      style: TextStyle(
                        color: changeColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _loadComparison(BuildContext context) {
    if (_fromDate != null &&
        _toDate != null &&
        _previousFromDate != null &&
        _previousToDate != null) {
      final currentFrom =
          "${_fromDate!.year}-${_fromDate!.month.toString().padLeft(2, '0')}-${_fromDate!.day.toString().padLeft(2, '0')}";
      final currentTo =
          "${_toDate!.year}-${_toDate!.month.toString().padLeft(2, '0')}-${_toDate!.day.toString().padLeft(2, '0')}";
      final previousFrom =
          "${_previousFromDate!.year}-${_previousFromDate!.month.toString().padLeft(2, '0')}-${_previousFromDate!.day.toString().padLeft(2, '0')}";
      final previousTo =
          "${_previousToDate!.year}-${_previousToDate!.month.toString().padLeft(2, '0')}-${_previousToDate!.day.toString().padLeft(2, '0')}";

      context.read<GetStatisticsComparisonBloc>().add(
            GetStatisticsComparison(
              currentFrom: currentFrom,
              currentTo: currentTo,
              previousFrom: previousFrom,
              previousTo: previousTo,
            ),
          );
    }
  }

  Widget _buildTopProductsSection(List<dynamic> products, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A2F4A),
            const Color(0xFF0F1E2E),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.brown.shade400.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Top Selling Products".tr(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          ...products.take(5).map((product) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.productName ?? "",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      "${product.totalQuantity ?? 0}",
                      style: TextStyle(
                        color: grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      "${(product.totalRevenue ?? 0.0).toStringAsFixed(0)} S.P",
                      style: TextStyle(
                        color: orange,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildTopCouponsSection(List<dynamic> coupons, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A2F4A),
            const Color(0xFF0F1E2E),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.pink.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Top Used Coupons".tr(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          ...coupons.take(5).map((coupon) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        coupon.couponCode ?? "",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      "${coupon.timesUsed ?? 0}",
                      style: TextStyle(
                        color: grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      "${(coupon.totalDiscount ?? 0.0).toStringAsFixed(0)} S.P",
                      style: TextStyle(
                        color: orange,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildTopActiveUsersSection(List<dynamic> users, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A2F4A),
            const Color(0xFF0F1E2E),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.indigo.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.indigo.withOpacity(0.25),
                      Colors.indigo.withOpacity(0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.indigo.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(Icons.star, color: Colors.indigo, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                "Top Active Users".tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...users.take(10).map((user) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.userName ?? "",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${user.totalSessions ?? 0} ${"sessions".tr()} • ${(user.averageSessionDuration ?? 0.0).toStringAsFixed(1)} hrs avg",
                              style: TextStyle(
                                color: grey.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${(user.totalSpent ?? 0.0).toStringAsFixed(0)} S.P",
                            style: TextStyle(
                              color: orange,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Total Spent".tr(),
                            style: TextStyle(
                              color: grey.withOpacity(0.7),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildPopularPackagesSection(List<dynamic> packages, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A2F4A),
            const Color(0xFF0F1E2E),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.purple.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.purple.withOpacity(0.25),
                      Colors.purple.withOpacity(0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.purple.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(Icons.star, color: Colors.purple, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                "Popular Packages".tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...packages.take(10).map((package) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              package.packageName ?? "",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${package.timesSold ?? 0} ${"times sold".tr()}",
                              style: TextStyle(
                                color: grey.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${(package.totalRevenue ?? 0.0).toStringAsFixed(0)} S.P",
                            style: TextStyle(
                              color: orange,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Total Revenue".tr(),
                            style: TextStyle(
                              color: grey.withOpacity(0.7),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                orange.withOpacity(0.25),
                orange.withOpacity(0.15),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: orange.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Icon(icon, color: orange, size: 24),
        ),
        const SizedBox(width: 16),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
