import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse_/core/resources/colors.dart';
import 'package:lighthouse_/core/resources/padding.dart';

class Chart extends StatelessWidget {
  const Chart({super.key});

  @override
  Widget build(BuildContext context) {
    int num = 41;
    double percentage = num * 100 / 60;

    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: [
                PieChartSectionData(
                  color: yellow,
                  value: percentage,
                  showTitle: false,
                  radius: 13,
                ),
                PieChartSectionData(
                  color: orange.withOpacity(0.1),
                  value: 100 - percentage,
                  showTitle: false,
                  radius: 13,
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: defaultPadding),
                Text(
                  "${percentage.toInt()}%",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: orange,
                        fontWeight: FontWeight.w600,
                        height: 0.5,
                      ),
                ),
                const SizedBox(height: 8),
                Text("$num ${"client".tr()}",style: TextStyle(color: lightGrey),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
