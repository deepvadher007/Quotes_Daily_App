import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, String>?> fetchRandomQuote() async {
    try {
      final response = await http.get(Uri.parse('https://zenquotes.io/api/random'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'quote': data[0]['q'],
          'author': data[0]['a'],
        };
      }
    } catch (e) {
      print('Error fetching quote: $e');
    }

    return null;
  }
}
