import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/main_window/presentation/widget/pie_chart.dart';
import 'package:lighthouse/features/main_window/presentation/widget/summary_details.dart';

class SummaryWidget extends StatefulWidget {
  const SummaryWidget({super.key});

  @override
  State<SummaryWidget> createState() => _SummaryWidgetState();
}

class _SummaryWidgetState extends State<SummaryWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // color: navy,
        gradient: LinearGradient(
          colors: [navy, darkNavy],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Chart(),
            Text(
              'summary'.tr(),
              style: const TextStyle(
                color: lightGrey,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                ),
            ),
            const SizedBox(height: 16),
            const SummaryDetails(visits: "80", onGround: "41"),
          ],
        ),
      ),
    );
  }
}
