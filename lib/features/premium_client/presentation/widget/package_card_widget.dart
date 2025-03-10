import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/common/widget/my_button.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/premium_client/data/models/get_all_active_packages_response.dart';

class PackageCardWidget extends StatelessWidget {
  final ActivePackage packageData;
  final VoidCallback onTap;

  const PackageCardWidget({
    super.key,
    required this.packageData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            Colors.white,
            grey,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                packageData.name ?? "Name".tr(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: orange,
                    ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 20,
                  color: orange,
                ),
                const SizedBox(width: 6),
                Text(
                  "${packageData.numOfHours} ${("hrs").tr()}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Duration Row
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: orange,
                ),
                const SizedBox(width: 6),
                Text(
                  "${packageData.packageDurationInDays} ${("days").tr()}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Description Section
            Text(
              packageData.description.isNotEmpty
                  ? packageData.description
                  : "No description available",
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            const Spacer(),
            // Price
            Align(
              alignment: Alignment.center,
              child: Text(
                "${"Price".tr()}: ${packageData.price} ${"s.p".tr()}",
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            SizedBox(height: 12),
            // Activate button
            Align(
              alignment: Alignment.center,
              child: MyButton(
                onPressed: onTap,
                child: Center(
                  child: Text("Activate".tr(),
                      style: Theme.of(context).textTheme.labelLarge),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
