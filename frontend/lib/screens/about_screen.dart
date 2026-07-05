import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/prediction_service.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final PredictionService _service = PredictionService();
  Map<String, dynamic>? _modelInfo;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchModelInfo();
  }

  Future<void> _fetchModelInfo() async {
    try {
      final info = await _service.getModelInfo();
      if (mounted)
        setState(() {
          _modelInfo = info;
          _isLoading = false;
        });
    } catch (e) {
      if (mounted)
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            pinned: true,
            backgroundColor: AppColors.navyBlue,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsetsDirectional.only(start: 16, bottom: 16),
              title: const Text(
                'Tentang',
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.navyBlue, AppColors.electricBlue],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.info_outline,
                    size: 60,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App description
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.battery_charging_full,
                                size: 22,
                                color: AppColors.darkGray,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Apa itu VoltCast?',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkGray,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'VoltCast menggunakan Deep Learning untuk memperkirakan permintaan listrik kota keesokan hari (MW) berdasarkan data 30 hari terakhir.',
                            style: TextStyle(
                              color: AppColors.mediumGray,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Model comparison — fetched from backend
                  _buildModelComparisonCard(),

                  const SizedBox(height: 16),

                  // tech stack
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.build,
                                size: 22,
                                color: AppColors.darkGray,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Stack Teknologi',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkGray,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildTechRow(
                            Icons.code,
                            'Backend',
                            'Flask (Python)',
                          ),
                          _buildTechRow(
                            Icons.phone_android,
                            'Frontend',
                            'Flutter (Dart)',
                          ),
                          _buildTechRow(
                            Icons.memory,
                            'ML Framework',
                            'TensorFlow',
                          ),
                          _buildTechRow(
                            Icons.dataset,
                            'Dataset',
                            'Hourly Energy Consumption (Kaggle)',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // kelompok
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.group,
                                size: 22,
                                color: AppColors.darkGray,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Tim',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkGray,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Kelompok 3\nS1 Sistem Informasi\nUAS Praktikum Machine Learning 2026',
                            style: TextStyle(
                              color: AppColors.mediumGray,
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModelComparisonCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.balance, size: 22, color: AppColors.darkGray),
                const SizedBox(width: 8),
                const Text(
                  'Info Model',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGray,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Gagal memuat data model.\n$_error',
                  style: const TextStyle(
                    color: AppColors.mediumGray,
                    fontSize: 13,
                  ),
                ),
              )
            else ...[
              _buildInfoRow(
                'Architecture',
                _modelInfo?['model']?['name'] ?? 'N/A',
                AppColors.electricBlue,
              ),
              _buildInfoRow(
                'MSE',
                (_modelInfo?['model']?['mse'] ?? 0).toString(),
                AppColors.mediumGray,
              ),
              _buildInfoRow(
                'RMSE',
                (_modelInfo?['model']?['rmse'] ?? 0).toString(),
                AppColors.mediumGray,
              ),
              _buildInfoRow(
                'MAE',
                '${_modelInfo?['model']?['mae'] ?? 0} MW',
                AppColors.mediumGray,
              ),
              _buildInfoRow(
                'R²',
                (_modelInfo?['model']?['r2'] ?? 0).toString(),
                AppColors.mediumGray,
              ),
              _buildInfoRow(
                'MAPE',
                '${_modelInfo?['model']?['mape'] ?? 0} %',
                AppColors.mediumGray,
              ),
            ],
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
            style: const TextStyle(color: AppColors.mediumGray, fontSize: 14),
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

  Widget _buildTechRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.electricBlue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.mediumGray, fontSize: 14),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.darkGray,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
