import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/premium_client/data/models/get_sessions_by_user_id_response_model.dart';

class SessionHistoryCardWidget extends StatelessWidget {
  final SessionItem session;
  final bool isMobile;

  const SessionHistoryCardWidget({
    super.key,
    required this.session,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = session.active;
    final bool isPremium = session.sessionType == 'premium';
    final String fullName = session.fullName ??
        '${session.firstName ?? ''} ${session.lastName ?? ''}'.trim();
    
    // Parse times
    String? formattedStartTime;
    String? formattedEndTime;
    String? duration;
    
    try {
      if (session.startTime.isNotEmpty) {
        final startParts = session.startTime.split('.');
        formattedStartTime = startParts[0];
      }
      if (session.endTime != null) {
        final endTimeStr = session.endTime.toString();
        if (endTimeStr.isNotEmpty) {
          final endParts = endTimeStr.split('.');
          formattedEndTime = endParts[0];
          
          // Calculate duration if both times exist
          if (formattedStartTime != null && formattedEndTime != null) {
            try {
              final start = DateFormat('HH:mm:ss').parse(formattedStartTime);
              final end = DateFormat('HH:mm:ss').parse(formattedEndTime);
              final diff = end.difference(start);
              final hours = diff.inHours;
              final minutes = diff.inMinutes.remainder(60);
              if (hours > 0) {
                duration = '${hours}h ${minutes}m';
              } else {
                duration = '${minutes}m';
              }
            } catch (e) {
              duration = null;
            }
          }
        }
      }
    } catch (e) {
      // Handle parsing errors gracefully
    }

    return Container(
      width: isMobile ? double.infinity : 340,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.98),
            Colors.white.withOpacity(0.92),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? Colors.green.withOpacity(0.4)
              : orange.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: (isActive ? Colors.green : orange).withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Decorative gradient background
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      (isPremium ? orange : Colors.blue).withOpacity(0.12),
                      (isPremium ? orange : Colors.blue).withOpacity(0.02),
                    ],
                  ),
                ),
              ),
            ),

            // Status Badge
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isActive
                        ? [Colors.green.shade400, Colors.green.shade600]
                        : [Colors.grey.shade400, Colors.grey.shade600],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: (isActive ? Colors.green : Colors.grey)
                          .withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isActive ? Icons.play_circle_filled : Icons.check_circle,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isActive ? "Active".tr() : "Ended".tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),

                  // Session Type Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isPremium
                                ? [orange.withOpacity(0.2), orange.withOpacity(0.1)]
                                : [Colors.blue.withOpacity(0.2), Colors.blue.withOpacity(0.1)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isPremium ? Icons.stars_rounded : Icons.rocket_launch_rounded,
                          color: isPremium ? orange : Colors.blue,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isPremium ? 'Premium Session'.tr() : 'Express Session'.tr(),
                              style: TextStyle(
                                color: isPremium ? orange : Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                            if (fullName.isNotEmpty)
                              Text(
                                fullName,
                                style: TextStyle(
                                  color: navy,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Date and Time Info
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: lightGrey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: grey.withOpacity(0.2), width: 1),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          icon: Icons.calendar_today_rounded,
                          label: "Date".tr(),
                          value: session.date,
                          iconColor: Colors.teal,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoRow(
                                icon: Icons.play_arrow_rounded,
                                label: "Start".tr(),
                                value: formattedStartTime ?? session.startTime,
                                iconColor: Colors.green,
                                compact: true,
                              ),
                            ),
                            if (formattedEndTime != null) ...[
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildInfoRow(
                                  icon: Icons.stop_rounded,
                                  label: "End".tr(),
                                  value: formattedEndTime!,
                                  iconColor: Colors.red,
                                  compact: true,
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (duration != null) ...[
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            icon: Icons.access_time_rounded,
                            label: "Duration".tr(),
                            value: duration!,
                            iconColor: orange,
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Additional Info
                  if (session.buffetInvoicePrice > 0 || 
                      (session.sessionInvoice != null && 
                       session.sessionInvoice is Map &&
                       (session.sessionInvoice as Map)['sessionPrice'] != null &&
                       (session.sessionInvoice as Map)['sessionPrice'] > 0))
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            orange.withOpacity(0.1),
                            orange.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: orange.withOpacity(0.2), width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.receipt_long_rounded,
                            color: orange,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total Price".tr(),
                                  style: TextStyle(
                                    color: grey,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${(session.buffetInvoicePrice + 
                                    ((session.sessionInvoice is Map && 
                                      (session.sessionInvoice as Map)['sessionPrice'] != null)
                                        ? ((session.sessionInvoice as Map)['sessionPrice'] as num).toDouble()
                                        : 0.0)).toStringAsFixed(0)} ${"SAR".tr()}",
                                  style: TextStyle(
                                    color: navy,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    bool compact = false,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(compact ? 6 : 8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: compact ? 16 : 18,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: grey,
                  fontSize: compact ? 10 : 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: navy,
                  fontSize: compact ? 12 : 13,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

