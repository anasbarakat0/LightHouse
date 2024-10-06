import 'package:flutter/material.dart';
import 'package:light_house/core/resources/colors.dart';
import 'package:light_house/features/mian_screen/presentation/widget/pie_chart.dart';
import 'package:light_house/features/mian_screen/presentation/widget/summary_details.dart';

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
        color: cardBackgroundColor,
      ),
      child: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Chart(),
            Text(
              'Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            SummaryDetails(visits: "visits", onGround: "onGround"),
          ],
        ),
      ),
    );
  }
}
