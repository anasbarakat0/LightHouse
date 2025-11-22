import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lighthouse/features/dashboard/data/models/dashboard_summary_response_model.dart';
import 'package:lighthouse/features/dashboard/presentation/bloc/get_dashboard_summary_bloc.dart';

class DashboardSummaryTable extends StatelessWidget {
  final bool isMobile;

  const DashboardSummaryTable({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetDashboardSummaryBloc, GetDashboardSummaryState>(
      builder: (context, state) {
        if (state is LoadingGetDashboardSummary) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is ExceptionGetDashboardSummary) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (state is SuccessGetDashboardSummary) {
          final summary = state.response.body;

          if (isMobile) {
            return _buildMobileTable(summary);
          }

          return _buildDesktopTable(summary);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildMobileTable(DashboardSummaryBody summary) {
    return Container(
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
          color: Colors.white.withOpacity(0.1),
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
        children: [
          _buildMobileRow(
            "Today Revenue".tr(),
            "${summary.todayRevenue.toStringAsFixed(0)} S.P",
            summary.todayRevenueGrowth,
            isFirst: true,
          ),
          _buildDivider(),
          _buildMobileRow(
            "Week Revenue".tr(),
            "${summary.weekRevenue.toStringAsFixed(0)} S.P",
            null,
          ),
          _buildDivider(),
          _buildMobileRow(
            "Month Revenue".tr(),
            "${summary.monthRevenue.toStringAsFixed(0)} S.P",
            null,
          ),
          _buildDivider(),
          _buildMobileRow(
            "Active Sessions".tr(),
            "${summary.activeSessions}",
            null,
          ),
          _buildDivider(),
          _buildMobileRow(
            "Today Sessions".tr(),
            "${summary.todaySessions}",
            summary.todaySessionsGrowth,
          ),
          _buildDivider(),
          _buildMobileRow(
            "Week Sessions".tr(),
            "${summary.weekSessions}",
            null,
          ),
          _buildDivider(),
          _buildMobileRow(
            "New Users Today".tr(),
            "${summary.newUsersToday}",
            null,
          ),
          _buildDivider(),
          _buildMobileRow(
            "New Users Week".tr(),
            "${summary.newUsersWeek}",
            null,
          ),
          _buildDivider(),
          _buildMobileRow(
            "New Users Month".tr(),
            "${summary.newUsersMonth}",
            null,
          ),
          _buildDivider(),
          _buildMobileRow(
            "Average Session Duration Today".tr(),
            "${summary.averageSessionDurationToday.toStringAsFixed(2)} ${"hours".tr()}",
            null,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMobileRow(
    String label,
    String value,
    String? growth, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    final isPositive = growth != null && growth.startsWith('+');
    final growthColor = growth != null
        ? (isPositive ? Colors.green : Colors.red)
        : Colors.transparent;

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: isFirst ? 16 : 12,
        bottom: isLast ? 16 : 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (growth != null) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      color: growthColor,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      growth,
                      style: TextStyle(
                        color: growthColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.white.withOpacity(0.1),
      indent: 16,
      endIndent: 16,
    );
  }

  Widget _buildDesktopTable(DashboardSummaryBody summary) {
    return Container(
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
          color: Colors.white.withOpacity(0.1),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            Colors.white.withOpacity(0.05),
          ),
          dataRowMinHeight: 56,
          dataRowMaxHeight: 72,
          dividerThickness: 1,
          headingTextStyle: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
          dataTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          columns: [
            DataColumn(
              label: Text("Metric".tr()),
            ),
            DataColumn(
              label: Text("Value".tr()),
              numeric: false,
            ),
            DataColumn(
              label: Text("Growth".tr()),
              numeric: false,
            ),
          ],
          rows: [
            _buildDataRow(
              "Today Revenue".tr(),
              "${summary.todayRevenue.toStringAsFixed(0)} S.P",
              summary.todayRevenueGrowth,
            ),
            _buildDataRow(
              "Week Revenue".tr(),
              "${summary.weekRevenue.toStringAsFixed(0)} S.P",
              null,
            ),
            _buildDataRow(
              "Month Revenue".tr(),
              "${summary.monthRevenue.toStringAsFixed(0)} S.P",
              null,
            ),
            _buildDataRow(
              "Active Sessions".tr(),
              "${summary.activeSessions}",
              null,
            ),
            _buildDataRow(
              "Today Sessions".tr(),
              "${summary.todaySessions}",
              summary.todaySessionsGrowth,
            ),
            _buildDataRow(
              "Week Sessions".tr(),
              "${summary.weekSessions}",
              null,
            ),
            _buildDataRow(
              "New Users Today".tr(),
              "${summary.newUsersToday}",
              null,
            ),
            _buildDataRow(
              "New Users Week".tr(),
              "${summary.newUsersWeek}",
              null,
            ),
            _buildDataRow(
              "New Users Month".tr(),
              "${summary.newUsersMonth}",
              null,
            ),
            _buildDataRow(
              "Average Session Duration Today".tr(),
              "${summary.averageSessionDurationToday.toStringAsFixed(2)} ${"hours".tr()}",
              null,
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(String label, String value, String? growth) {
    final isPositive = growth != null && growth.startsWith('+');
    final growthColor = growth != null
        ? (isPositive ? Colors.green : Colors.red)
        : Colors.grey;

    return DataRow(
      cells: [
        DataCell(
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DataCell(
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        DataCell(
          growth != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      color: growthColor,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      growth,
                      style: TextStyle(
                        color: growthColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              : Text(
                  "-",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
        ),
      ],
    );
  }
}

