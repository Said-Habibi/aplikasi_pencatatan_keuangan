import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/transaction_provider.dart';
import '../utils/app_theme.dart';
import '../utils/currency_formatter.dart';

class IncomeExpenseChart extends StatelessWidget {
  final TransactionProvider provider;
  const IncomeExpenseChart({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final data = provider.filterPeriod == FilterPeriod.week
        ? provider.weeklyChartData
        : provider.monthlyChartData;
    final maxVal = data.fold<double>(
        0, (m, d) => [m, d['income']!, d['expense']!].reduce((a, b) => a > b ? a : b));
    final labels = provider.filterPeriod == FilterPeriod.week
        ? ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min']
        : _last6MonthLabels();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Grafik Keuangan',
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
              Row(
                children: [
                  _dot(AppTheme.secondary, 'Masuk'),
                  const SizedBox(width: 12),
                  _dot(AppTheme.expense, 'Keluar'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                maxY: maxVal * 1.3 == 0 ? 100 : maxVal * 1.3,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: Colors.white.withOpacity(0.04), strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        final i = v.toInt();
                        if (i < 0 || i >= labels.length) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(labels[i],
                              style: const TextStyle(color: Color(0xFF4B5563), fontSize: 10)),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(data.length, (i) => BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: data[i]['income']!,
                      color: AppTheme.secondary,
                      width: 7,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                    BarChartRodData(
                      toY: data[i]['expense']!,
                      color: AppTheme.expense,
                      width: 7,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ],
                )),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppTheme.surface,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        CurrencyFormatter.formatCompact(rod.toY),
                        TextStyle(
                          color: rodIndex == 0 ? AppTheme.secondary : AppTheme.expense,
                          fontSize: 11,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color, String label) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
      ],
    );
  }

  List<String> _last6MonthLabels() {
    final now = DateTime.now();
    final months = ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Ags','Sep','Okt','Nov','Des'];
    return List.generate(6, (i) => months[DateTime(now.year, now.month - 5 + i, 1).month - 1]);
  }
}
