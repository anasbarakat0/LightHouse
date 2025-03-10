import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/resources/padding.dart';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:lighthouse/core/utils/task_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chart extends StatefulWidget {
  final int onGround;
  const Chart({super.key, required this.onGround});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  late int capacity;
  late int visits;

  @override
  void initState() {
    capacity = memory.get<SharedPreferences>().getInt("capacity") ?? 50;
    visits = memory.get<SharedPreferences>().getInt("visits") ?? 0;
    capacityNotifier.addListener(() {
      setState(() {
        capacity = capacityNotifier.value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double percentage = widget.onGround * 100 / capacity;
    double percentageVisits = visits * 100 / capacity;

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
                  value: percentageVisits,
                  showTitle: false,
                  radius: 13,
                ),
                PieChartSectionData(
                  color: orange.withOpacity(0.1),
                  value: 100 - percentageVisits,
                  showTitle: false,
                  radius: 13,
                ),
              ],
            ),
          ),
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: 
                percentage > 100.0
                    ? [PieChartSectionData(
                        color: orange,
                        value: 100,
                        showTitle: false,
                        radius: 17,
                      )]
                    : [PieChartSectionData(
                        color: orange,
                        value: percentage,
                        showTitle: false,
                        radius: 20,
                      ),
                PieChartSectionData(
                  color:
                      percentageVisits > 100 ? yellow : orange.withOpacity(0),
                  value: 100 - percentage,
                  showTitle: false,
                  radius: 13,
                ),]
              ,
            ),
          ),
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: [
                PieChartSectionData(
                  color: yellow,
                  value: percentageVisits > 100 ? percentageVisits - 100 : 0,
                  showTitle: false,
                  radius: 13,
                ),
                PieChartSectionData(
                  color: orange.withOpacity(0),
                  value: percentageVisits > 100
                      ? 100 - (percentageVisits - 100)
                      : 100,
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
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: orange
                          ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${widget.onGround} ${"client".tr()}",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: lightGrey
                          ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
