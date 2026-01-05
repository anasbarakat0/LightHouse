import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/dashboard/presentation/bloc/get_dashboard_recent_sessions_bloc.dart';

class DashboardRecentSessions extends StatelessWidget {
  final bool isMobile;

  const DashboardRecentSessions({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Sessions".tr(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<GetDashboardRecentSessionsBloc, GetDashboardRecentSessionsState>(
            builder: (context, state) {
              if (state is LoadingGetDashboardRecentSessions) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (state is ExceptionGetDashboardRecentSessions) {
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

              if (state is SuccessGetDashboardRecentSessions) {
                final sessions = state.response.body.sessions;
                if (sessions.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        "No recent sessions".tr(),
                        style: TextStyle(color: grey),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sessions.length > 5 ? 5 : sessions.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    return _buildSessionCard(context, session);
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(BuildContext context, dynamic session) {
    // Premium: Gold/Amber color
    final premiumColor = Colors.amber.shade600;
    final sessionColor = premiumColor;
    
    // Active sessions get green border and dot
    final borderColor = session.isActive
        ? Colors.green
        : sessionColor.withOpacity(0.3);
    final dotColor = session.isActive
        ? Colors.green
        : Colors.grey;

    return InkWell(
      onTap: () {
        _showSessionDetailsDialog(context, session);
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor,
            width: session.isActive ? 2.0 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        session.userName ?? "",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: sessionColor.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: sessionColor.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          session.sessionType ?? "",
                          style: TextStyle(
                            color: sessionColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${session.date} • ${session.startTime}${session.endTime != null ? ' - ${session.endTime}' : ''}",
                    style: TextStyle(
                      color: grey.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${session.totalRevenue.toStringAsFixed(0)} S.P",
                  style: TextStyle(
                    color: orange,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${session.duration.toStringAsFixed(1)} hrs",
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
    );
  }

  void _showSessionDetailsDialog(BuildContext context, dynamic session) {
    // Premium: Gold/Amber color
    final premiumColor = Colors.amber.shade600;
    final sessionColor = premiumColor;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1A2F4A),
                  const Color(0xFF0F1E2E),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: sessionColor.withOpacity(0.2),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    border: Border(
                      bottom: BorderSide(
                        color: sessionColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: sessionColor.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: sessionColor.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.star,
                          color: sessionColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              session.sessionType ?? "",
                              style: TextStyle(
                                color: sessionColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              session.userName ?? "",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildDetailRow(
                          "Date".tr(),
                          session.date ?? "",
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          "Start Time".tr(),
                          session.startTime ?? "",
                        ),
                        if (session.endTime != null) ...[
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            "End Time".tr(),
                            session.endTime ?? "",
                          ),
                        ],
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          "Duration".tr(),
                          "${session.duration.toStringAsFixed(2)} ${"hours".tr()}",
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          "Status".tr(),
                          session.isActive ? "Active".tr() : "Completed".tr(),
                          valueColor: session.isActive
                              ? Colors.green
                              : Colors.grey,
                        ),
                        const SizedBox(height: 20),
                        Divider(
                          thickness: 1,
                          color: Colors.white.withOpacity(0.1),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Revenue Details".tr(),
                          style: TextStyle(
                            color: sessionColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          "Session Price".tr(),
                          "${session.sessionPrice.toStringAsFixed(0)} S.P",
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          "Buffet Price".tr(),
                          "${session.buffetPrice.toStringAsFixed(0)} S.P",
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: orange.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: orange.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Revenue".tr(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                "${session.totalRevenue.toStringAsFixed(0)} S.P",
                                style: TextStyle(
                                  color: orange,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String title, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: TextStyle(
              color: grey.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

