import 'dart:convert';
import 'package:http/http.dart' as http;

class PredictionService {
  final String apiUrl = "";

  Future<double> predict(List<double> past7Days) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"past_7_days": past7Days}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('error')) {
          throw Exception(data['error']);
        }
        return (data['predicted_kwh'] as num).toDouble();
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }
}