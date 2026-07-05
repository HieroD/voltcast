import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/prediction_service.dart';
import '../widgets/custom_input.dart';
import 'dart:math';
import 'result_screen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final List<TextEditingController> _controllers = List.generate(
    30,
    (_) => TextEditingController(),
  );
  final PredictionService _predictionService = PredictionService();
  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _loadSampleData() {
    final rng = Random();
    for (int i = 0; i < 30; i++) {
      _controllers[i].text = (11000 + rng.nextDouble() * 10000).toStringAsFixed(
        1,
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.white, size: 18),
            SizedBox(width: 6),
            Text('Data sampel dimuat'),
          ],
        ),
        backgroundColor: AppColors.green,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _clearAll() {
    for (var controller in _controllers) {
      controller.clear();
    }
  }

  bool _validateInputs() {
    for (int i = 0; i < 30; i++) {
      if (_controllers[i].text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.warning, color: AppColors.white, size: 18),
                const SizedBox(width: 6),
                Text('Harap isi Hari ${i + 1}'),
              ],
            ),
            backgroundColor: AppColors.orange,
          ),
        );
        return false;
      }
      final value = double.tryParse(_controllers[i].text);
      if (value == null || value < 0 || value > 31500) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.warning, color: AppColors.white, size: 18),
                const SizedBox(width: 6),
                Text('Day ${i + 1} harus antara 0 dan 31500 MW'),
              ],
            ),
            backgroundColor: AppColors.orange,
          ),
        );
        return false;
      }
    }
    return true;
  }

  Future<void> _predict() async {
    if (!_validateInputs()) return;

    setState(() => _isLoading = true);

    final List<double> pastDays = _controllers
        .map((c) => double.parse(c.text))
        .toList();

    try {
      final result = await _predictionService.predict(pastDays);

      if (!mounted) return;
      setState(() => _isLoading = false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            predictedMw: result.predictedMw,
            pastData: pastDays,
            modelName: result.modelName,
          ),
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: AppColors.white, size: 18),
              const SizedBox(width: 6),
              Text('Error: $e'),
            ],
          ),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header with gradient
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.navyBlue,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsetsDirectional.only(start: 16, bottom: 16),
              title: const Text(
                'VoltCast',
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
                    colors: [
                      AppColors.navyBlue,
                      AppColors.electricBlue,
                      AppColors.cyan,
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.bolt, size: 80, color: AppColors.white),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.electricBlue.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.bar_chart_sharp,
                                  color: AppColors.electricBlue,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Prediksi Energi Harian',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkGray,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Masukkan data permintaan listrik kota 30 hari terakhir (MW) untuk memperkirakan beban besok.',
                            style: TextStyle(
                              color: AppColors.mediumGray,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Input fields
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.bar_chart,
                                size: 20,
                                color: AppColors.darkGray,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Penggunaan 30 Hari Terakhir',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkGray,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _loadSampleData,
                                  icon: const Icon(Icons.dataset),
                                  label: const Text('Generate Sampel'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.electricBlue,
                                    side: const BorderSide(
                                      color: AppColors.electricBlue,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _clearAll,
                                  icon: const Icon(Icons.clear_all),
                                  label: const Text('Hapus'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.mediumGray,
                                    side: BorderSide(
                                      color: AppColors.mediumGray.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ...List.generate(30, (index) {
                            final daysAgo = 30 - index;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: CustomInputField(
                                controller: _controllers[index],
                                label: 'Hari -$daysAgo',
                                hint: 'contoh: 14500',
                                icon: Icons.calendar_today,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Predict button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _predict,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.white,
                              ),
                            )
                          : const Icon(Icons.punch_clock_sharp),
                      label: Text(
                        _isLoading ? 'Memprediksi...' : 'Prediksi Besok',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.electricBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
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
}
