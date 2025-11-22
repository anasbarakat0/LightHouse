import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';

class RevenueChartWidget extends StatelessWidget {
  final double sessionRevenue;
  final double buffetRevenue;
  final double packagesRevenue;
  final double totalRevenue;
  final bool isMobile;

  const RevenueChartWidget({
    super.key,
    required this.sessionRevenue,
    required this.buffetRevenue,
    required this.packagesRevenue,
    required this.totalRevenue,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final sessionPercentage = totalRevenue > 0
        ? (sessionRevenue / totalRevenue * 100)
        : 0.0;
    final buffetPercentage = totalRevenue > 0
        ? (buffetRevenue / totalRevenue * 100)
        : 0.0;
    final packagesPercentage = totalRevenue > 0
        ? (packagesRevenue / totalRevenue * 100)
        : 0.0;

    return Container(
      width: isMobile ? double.infinity : null,
      padding: const EdgeInsets.all(28),
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
          color: orange.withOpacity(0.2),
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      orange.withOpacity(0.25),
                      orange.withOpacity(0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: orange.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(Icons.trending_up, color: orange, size: 24),
              ),
              const SizedBox(width: 16),
              Text(
                "Revenue Breakdown".tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 600;
              
              if (isNarrow || isMobile) {
                return Column(
                  children: [
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 60,
                          startDegreeOffset: -90,
                          sections: [
                            if (sessionPercentage > 0)
                              PieChartSectionData(
                                color: orange,
                                value: sessionPercentage,
                                title: '${sessionPercentage.toStringAsFixed(1)}%',
                                radius: 50,
                                titleStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            if (buffetPercentage > 0)
                              PieChartSectionData(
                                color: Colors.brown.shade400,
                                value: buffetPercentage,
                                title: '${buffetPercentage.toStringAsFixed(1)}%',
                                radius: 50,
                                titleStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            if (packagesPercentage > 0)
                              PieChartSectionData(
                                color: Colors.purple,
                                value: packagesPercentage,
                                title: '${packagesPercentage.toStringAsFixed(1)}%',
                                radius: 50,
                                titleStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLegendItem(
                          "Session Revenue".tr(),
                          sessionRevenue,
                          orange,
                        ),
                        const SizedBox(height: 12),
                        _buildLegendItem(
                          "Buffet Revenue".tr(),
                          buffetRevenue,
                          Colors.brown.shade400,
                        ),
                        if (packagesRevenue > 0) ...[
                          const SizedBox(height: 12),
                          _buildLegendItem(
                            "Packages Revenue".tr(),
                            packagesRevenue,
                            Colors.purple,
                          ),
                        ],
                        const SizedBox(height: 12),
                        Divider(color: grey.withOpacity(0.3)),
                        const SizedBox(height: 12),
                        _buildLegendItem(
                          "Total Revenue".tr(),
                          totalRevenue,
                          navy,
                          isTotal: true,
                        ),
                      ],
                    ),
                  ],
                );
              }
              
              return SizedBox(
                height: 200,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 60,
                          startDegreeOffset: -90,
                          sections: [
                            if (sessionPercentage > 0)
                              PieChartSectionData(
                                color: orange,
                                value: sessionPercentage,
                                title: '${sessionPercentage.toStringAsFixed(1)}%',
                                radius: 50,
                                titleStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            if (buffetPercentage > 0)
                              PieChartSectionData(
                                color: Colors.brown.shade400,
                                value: buffetPercentage,
                                title: '${buffetPercentage.toStringAsFixed(1)}%',
                                radius: 50,
                                titleStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            if (packagesPercentage > 0)
                              PieChartSectionData(
                                color: Colors.purple,
                                value: packagesPercentage,
                                title: '${packagesPercentage.toStringAsFixed(1)}%',
                                radius: 50,
                                titleStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildLegendItem(
                              "Session Revenue".tr(),
                              sessionRevenue,
                              orange,
                            ),
                            const SizedBox(height: 12),
                            _buildLegendItem(
                              "Buffet Revenue".tr(),
                              buffetRevenue,
                              Colors.brown.shade400,
                            ),
                            if (packagesRevenue > 0) ...[
                              const SizedBox(height: 12),
                              _buildLegendItem(
                                "Packages Revenue".tr(),
                                packagesRevenue,
                                Colors.purple,
                              ),
                            ],
                            const SizedBox(height: 12),
                            Divider(color: grey.withOpacity(0.3)),
                            const SizedBox(height: 12),
                            _buildLegendItem(
                              "Total Revenue".tr(),
                              totalRevenue,
                              navy,
                              isTotal: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, double value, Color color,
      {bool isTotal = false}) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: grey.withOpacity(0.9),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "${value.toStringAsFixed(0)} ${"S.P".tr()}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTotal ? 20 : 18,
                  fontWeight: isTotal ? FontWeight.w800 : FontWeight.w700,
                  letterSpacing: -0.3,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

