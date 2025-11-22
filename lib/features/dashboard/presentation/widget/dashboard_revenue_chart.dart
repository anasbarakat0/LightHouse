import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/dashboard/presentation/bloc/get_dashboard_revenue_chart_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardRevenueChart extends StatelessWidget {
  final bool isMobile;
  final String selectedPeriod;
  final Function(String) onPeriodChanged;

  const DashboardRevenueChart({
    super.key,
    required this.isMobile,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Revenue Chart".tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildPeriodButton('monthly', "Monthly".tr()),
                    _buildPeriodButton('weekly', "Weekly".tr()),
                    _buildPeriodButton('daily', "Daily".tr()),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          BlocBuilder<GetDashboardRevenueChartBloc, GetDashboardRevenueChartState>(
            builder: (context, state) {
              if (state is LoadingGetDashboardRevenueChart) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (state is ExceptionGetDashboardRevenueChart) {
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

              if (state is SuccessGetDashboardRevenueChart) {
                final chartData = state.response.body;
                if (chartData.dataPoints.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        "No data available".tr(),
                        style: TextStyle(color: grey),
                      ),
                    ),
                  );
                }

                return SizedBox(
                  height: isMobile ? 250 : 300,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 1000,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.white.withOpacity(0.1),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: chartData.dataPoints.length > 10 ? 2 : 1,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index >= 0 && index < chartData.dataPoints.length) {
                                final label = chartData.dataPoints[index].label;
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    label.length > 10 ? label.substring(0, 10) : label,
                                    style: TextStyle(
                                      color: grey,
                                      fontSize: 10,
                                    ),
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 50,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  color: grey,
                                  fontSize: 10,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      minX: 0,
                      maxX: (chartData.dataPoints.length - 1).toDouble(),
                      minY: 0,
                      maxY: chartData.dataPoints
                              .map((e) => e.revenue)
                              .reduce((a, b) => a > b ? a : b) *
                          1.2,
                      lineBarsData: [
                        // Total Revenue Line (Main)
                        LineChartBarData(
                          spots: chartData.dataPoints.asMap().entries.map((entry) {
                            return FlSpot(entry.key.toDouble(), entry.value.revenue);
                          }).toList(),
                          isCurved: true,
                          color: orange,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: orange.withOpacity(0.1),
                          ),
                        ),
                        // Session Revenue Line
                        if (chartData.dataPoints.any((e) => e.sessionRevenue > 0))
                          LineChartBarData(
                            spots: chartData.dataPoints.asMap().entries.map((entry) {
                              return FlSpot(entry.key.toDouble(), entry.value.sessionRevenue);
                            }).toList(),
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 2,
                            dotData: const FlDotData(show: false),
                          ),
                        // Buffet Revenue Line
                        if (chartData.dataPoints.any((e) => e.buffetRevenue > 0))
                          LineChartBarData(
                            spots: chartData.dataPoints.asMap().entries.map((entry) {
                              return FlSpot(entry.key.toDouble(), entry.value.buffetRevenue);
                            }).toList(),
                            isCurved: true,
                            color: Colors.brown.shade400,
                            barWidth: 2,
                            dotData: const FlDotData(show: false),
                          ),
                        // Packages Revenue Line
                        if (chartData.dataPoints.any((e) => (e.packagesRevenue ?? 0) > 0))
                          LineChartBarData(
                            spots: chartData.dataPoints.asMap().entries.map((entry) {
                              return FlSpot(entry.key.toDouble(), entry.value.packagesRevenue ?? 0);
                            }).toList(),
                            isCurved: true,
                            color: Colors.purple,
                            barWidth: 2,
                            dotData: const FlDotData(show: false),
                          ),
                      ],
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 16),
          // Legend
          BlocBuilder<GetDashboardRevenueChartBloc, GetDashboardRevenueChartState>(
            builder: (context, state) {
              if (state is SuccessGetDashboardRevenueChart) {
                final chartData = state.response.body;
                final hasSession = chartData.dataPoints.any((e) => e.sessionRevenue > 0);
                final hasBuffet = chartData.dataPoints.any((e) => e.buffetRevenue > 0);
                final hasPackages = chartData.dataPoints.any((e) => (e.packagesRevenue ?? 0) > 0);
                
                return Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _buildChartLegendItem("Total".tr(), orange),
                    if (hasSession) _buildChartLegendItem("Sessions".tr(), Colors.blue),
                    if (hasBuffet) _buildChartLegendItem("Buffet".tr(), Colors.brown.shade400),
                    if (hasPackages) _buildChartLegendItem("Packages".tr(), Colors.purple),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChartLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodButton(String period, String label) {
    final isSelected = selectedPeriod == period;
    return InkWell(
      onTap: () => onPeriodChanged(period),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? orange.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? orange : Colors.white.withOpacity(0.7),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

