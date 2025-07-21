import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class QuoteProvider with ChangeNotifier {
  String _quote = '';
  String _author = '';

  String get quote => _quote;
  String get author => _author;

  Future<void> loadQuote() async {
    final data = await ApiService.fetchRandomQuote();
    if (data != null) {
      _quote = data['quote']!;
      _author = data['author']!;
      notifyListeners();
    }
  }
}
