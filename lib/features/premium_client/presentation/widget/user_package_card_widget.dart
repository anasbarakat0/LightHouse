import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/features/premium_client/data/models/get_all_packages_by_user_id_response.dart';
import 'package:lighthouse/features/premium_client/presentation/widget/info_row.dart';

class UserPackageCard extends StatelessWidget {
  final UserPackage packageData;
  final Color color;

  const UserPackageCard({
    super.key,
    required this.packageData,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy/MM/dd');
    final String startDate =
        formatter.format(DateTime.parse(packageData.startDate));
    final bool isActive = packageData.active;

    return Stack(
      children: [
        Container(
          height: 180,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isActive
                  ? [Colors.green.shade400, Colors.green.shade800]
                  : [Colors.red.shade400, Colors.red.shade800],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(4, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(18),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Package ID with Icon
              Row(
                children: [
                  Icon(Icons.card_giftcard, color: Colors.white, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    "${("Package ID").tr()}: ${packageData.packageId}",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              InfoRow(
                icon: Icons.timer,
                text: "Consumed Hours: ${packageData.consumedHours}",
              ),
              InfoRow(
                icon: Icons.date_range,
                text: "Start Date: $startDate",
              ),
              InfoRow(
                icon: Icons.hourglass_bottom,
                text: "Remaining Days: ${packageData.remainingDays}",
              ),
            ],
          ),
        ),

        // Status Badge
        Positioned(
          left: 40,
          bottom: 30,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  isActive ? Icons.check_circle : Icons.cancel,
                  color: isActive ? Colors.green : Colors.red,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  isActive ? "Active" : "Inactive",
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: isActive
                            ? Colors.green.shade800
                            : Colors.red.shade800,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
