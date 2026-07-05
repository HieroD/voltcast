import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';

class ResultScreen extends StatelessWidget {
  final double predictedMw;
  final List<double> pastData;
  final String modelName;

  const ResultScreen({
    super.key,
    required this.predictedMw,
    required this.pastData,
    this.modelName = 'GRU',
  });

  Color _getStatusColor() {
    if (predictedMw < 13000) return AppColors.green;
    if (predictedMw < 17000) return AppColors.amber;
    if (predictedMw < 21000) return AppColors.orange;
    return AppColors.red;
  }

  String _getStatusText() {
    if (predictedMw < 13000) return 'Permintaan Rendah';
    if (predictedMw < 17000) return 'Permintaan Normal';
    if (predictedMw < 21000) return 'Permintaan Tinggi';
    return 'Permintaan Puncak';
  }

  IconData _getStatusIcon() {
    if (predictedMw < 13000) return Icons.eco;
    if (predictedMw < 17000) return Icons.bolt;
    if (predictedMw < 21000) return Icons.warning_amber;
    return Icons.error;
  }

  String _getRecommendation() {
    if (predictedMw < 13000) return 'Permintaan listrik di bawah rata-rata.';
    if (predictedMw < 17000) return 'Permintaan listrik normal.';
    if (predictedMw < 21000) return 'Permintaan di atas rata-rata.';
    return 'Permintaan puncak diperkirakan.';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    // Take only the last 7 days for the chart (model uses 30-day window)
    final chartData = pastData.length > 7
        ? pastData.sublist(pastData.length - 7)
        : pastData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Prediksi'),
        backgroundColor: AppColors.navyBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main prediction card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    statusColor,
                    statusColor.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: statusColor.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(_getStatusIcon(), color: AppColors.white, size: 48),
                  const SizedBox(height: 12),
                  const Text(
                    'Prediksi untuk Besok',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${predictedMw.toStringAsFixed(1)} MW',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusText(),
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Recommendation card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.cyan.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.lightbulb_outline,
                        color: AppColors.electricBlue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _getRecommendation(),
                        style: const TextStyle(
                          color: AppColors.darkGray,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Chart card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.show_chart, size: 20, color: AppColors.darkGray),
                        const SizedBox(width: 8),
                        const Text(
                          'Tren Permintaan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGray,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '7 hari terakhir + Prediksi besok',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.mediumGray,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 220,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 2000,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: AppColors.mediumGray.withValues(alpha: 0.2),
                                strokeWidth: 1,
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 50,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '${value.toInt()}',
                                    style: const TextStyle(
                                      color: AppColors.mediumGray,
                                      fontSize: 10,
                                    ),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final labels = ['D-7', 'D-6', 'D-5', 'D-4', 'D-3', 'D-2', 'D-1', 'TMR'];
                                  if (value.toInt() >= 0 && value.toInt() < labels.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        labels[value.toInt()],
                                        style: TextStyle(
                                          color: value.toInt() == 7
                                              ? AppColors.electricBlue
                                              : AppColors.mediumGray,
                                          fontSize: 10,
                                          fontWeight: value.toInt() == 7
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            // Past data line (last 7 days)
                            LineChartBarData(
                              spots: [
                                for (int i = 0; i < chartData.length; i++)
                                  FlSpot(i.toDouble(), chartData[i]),
                              ],
                              isCurved: true,
                              color: AppColors.electricBlue,
                              barWidth: 3,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, bar, index) {
                                  return FlDotCirclePainter(
                                    radius: 4,
                                    color: AppColors.white,
                                    strokeWidth: 2,
                                    strokeColor: AppColors.electricBlue,
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                color: AppColors.electricBlue.withValues(alpha: 0.1),
                              ),
                            ),
                            // Prediction point
                            LineChartBarData(
                              spots: [
                                FlSpot(6, chartData.last),
                                FlSpot(7, predictedMw),
                              ],
                              isCurved: false,
                              color: statusColor,
                              barWidth: 3,
                              dashArray: [5, 5],
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, bar, index) {
                                  if (index == 1) {
                                    return FlDotCirclePainter(
                                      radius: 7,
                                      color: statusColor,
                                      strokeWidth: 3,
                                      strokeColor: AppColors.white,
                                    );
                                  }
                                  return FlDotCirclePainter(
                                    radius: 4,
                                    color: AppColors.white,
                                    strokeWidth: 2,
                                    strokeColor: statusColor,
                                  );
                                },
                              ),
                            ),
                          ],
                          minX: 0,
                          maxX: 7,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Model info card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.smart_toy, size: 20, color: AppColors.darkGray),
                        const SizedBox(width: 8),
                        const Text(
                          'Informasi Model',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGray,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('Model', modelName, AppColors.electricBlue),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Try again button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Prediksi Lain'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navyBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.mediumGray,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
