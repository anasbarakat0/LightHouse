import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NoPackagesCard extends StatelessWidget {


  const NoPackagesCard({
    super.key,
    
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.white.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 23, horizontal: 75),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.inbox,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 25),
            Text(
              "no_package".tr(),
              style:Theme.of(context).textTheme.labelLarge?.copyWith(

                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
