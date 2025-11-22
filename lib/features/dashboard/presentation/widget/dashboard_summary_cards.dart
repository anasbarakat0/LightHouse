import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/dashboard/presentation/bloc/get_dashboard_summary_bloc.dart';

class DashboardSummaryCards extends StatelessWidget {
  final bool isMobile;

  const DashboardSummaryCards({super.key, required this.isMobile});

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
            return Column(
              children: [
                // First Row - Revenue
                _buildSummaryCard(
                  "Today Revenue".tr(),
                  "${summary.todayRevenue.toStringAsFixed(0)} S.P",
                  summary.todayRevenueGrowth,
                  Icons.attach_money,
                  Colors.green,
                ),
                const SizedBox(height: 16),
                _buildSummaryCard(
                  "Week Revenue".tr(),
                  "${summary.weekRevenue.toStringAsFixed(0)} S.P",
                  null,
                  Icons.trending_up,
                  const Color(0xFF81C784),
                ),
                const SizedBox(height: 16),
                _buildSummaryCard(
                  "Month Revenue".tr(),
                  "${summary.monthRevenue.toStringAsFixed(0)} S.P",
                  null,
                  Icons.monetization_on,
                  const Color(0xFFA5D6A7),
                ),
                const SizedBox(height: 16),
                // Second Row - Sessions
                _buildSummaryCard(
                  "Active Sessions".tr(),
                  "${summary.activeSessions}",
                  null,
                  Icons.people,
                  Colors.blue,
                ),
                const SizedBox(height: 16),
                _buildSummaryCard(
                  "Today Sessions".tr(),
                  "${summary.todaySessions}",
                  summary.todaySessionsGrowth,
                  Icons.event,
                  Colors.purple,
                ),
                const SizedBox(height: 16),
                _buildSummaryCard(
                  "Week Sessions".tr(),
                  "${summary.weekSessions}",
                  null,
                  Icons.calendar_today,
                  const Color(0xFFBA68C8),
                ),
                const SizedBox(height: 16),
                // Third Row - Users
                _buildSummaryCard(
                  "New Users Today".tr(),
                  "${summary.newUsersToday}",
                  null,
                  Icons.person_add,
                  orange,
                ),
                const SizedBox(height: 16),
                _buildSummaryCard(
                  "New Users Week".tr(),
                  "${summary.newUsersWeek}",
                  null,
                  Icons.group_add,
                  const Color(0xFFFFB74D),
                ),
                const SizedBox(height: 16),
                _buildSummaryCard(
                  "New Users Month".tr(),
                  "${summary.newUsersMonth}",
                  null,
                  Icons.people_outline,
                  const Color(0xFFFFCC80),
                ),
                const SizedBox(height: 16),
                // Fourth Row - Duration
                _buildSummaryCard(
                  "Average Session Duration Today".tr(),
                  "${summary.averageSessionDurationToday.toStringAsFixed(2)} ${"hours".tr()}",
                  null,
                  Icons.access_time,
                  Colors.teal,
                ),
              ],
            );
          }

          // Desktop View - Multiple Rows
          return Column(
            children: [
              // First Row - Revenue
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      "Today Revenue".tr(),
                      "${summary.todayRevenue.toStringAsFixed(0)} S.P",
                      summary.todayRevenueGrowth,
                      Icons.attach_money,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      "Week Revenue".tr(),
                      "${summary.weekRevenue.toStringAsFixed(0)} S.P",
                      null,
                      Icons.trending_up,
                      const Color(0xFF81C784),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      "Month Revenue".tr(),
                      "${summary.monthRevenue.toStringAsFixed(0)} S.P",
                      null,
                      Icons.monetization_on,
                      const Color(0xFFA5D6A7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Second Row - Sessions
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      "Active Sessions".tr(),
                      "${summary.activeSessions}",
                      null,
                      Icons.people,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      "Today Sessions".tr(),
                      "${summary.todaySessions}",
                      summary.todaySessionsGrowth,
                      Icons.event,
                      Colors.purple,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      "Week Sessions".tr(),
                      "${summary.weekSessions}",
                      null,
                      Icons.calendar_today,
                      const Color(0xFFBA68C8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Third Row - Users & Duration
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      "New Users Today".tr(),
                      "${summary.newUsersToday}",
                      null,
                      Icons.person_add,
                      orange,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      "New Users Week".tr(),
                      "${summary.newUsersWeek}",
                      null,
                      Icons.group_add,
                      const Color(0xFFFFB74D),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      "New Users Month".tr(),
                      "${summary.newUsersMonth}",
                      null,
                      Icons.people_outline,
                      const Color(0xFFFFCC80),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Fourth Row - Duration
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      "Average Session Duration Today".tr(),
                      "${summary.averageSessionDurationToday.toStringAsFixed(2)} ${"hours".tr()}",
                      null,
                      Icons.access_time,
                      Colors.teal,
                    ),
                  ),
                  const Spacer(),
                  const Spacer(),
                ],
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    String? growth,
    IconData icon,
    Color iconColor,
  ) {
    final isPositive = growth != null && growth.startsWith('+');
    final growthColor = growth != null
        ? (isPositive ? Colors.green : Colors.red)
        : Colors.transparent;

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
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (growth != null) ...[
            const SizedBox(height: 8),
            Row(
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
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

