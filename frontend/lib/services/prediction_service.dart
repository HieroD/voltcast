import 'dart:convert';
import 'package:http/http.dart' as http;

class PredictionResult {
  final double predictedMw;
  final String modelName;

  PredictionResult(this.predictedMw, this.modelName);
}

class PredictionService {
  final String apiUrl = "http://localhost:5000"; 

  Future<PredictionResult> predict(List<double> pastDays) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/predict'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"past_days": pastDays}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('error')) {
          throw Exception(data['error']);
        }
        final mw = (data['predicted_mw'] as num).toDouble();
        final model = data['model'] as String? ?? 'GRU';
        return PredictionResult(mw, model);
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }

  Future<Map<String, dynamic>> getModelInfo() async {
    final response = await http.get(Uri.parse('$apiUrl/model-info'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to fetch model info');
  }
}
