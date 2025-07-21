import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(QuotesApp());

class QuotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotes Daily',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: QuotesPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class QuotesPage extends StatefulWidget {
  @override
  _QuotesPageState createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  String quote = '';
  String author = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchQuote();
  }

  Future<void> fetchQuote() async {
    setState(() => isLoading = true);

    final response = await http.get(Uri.parse('https://zenquotes.io/api/random'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      setState(() {
        quote = data[0]['q'];
        author = data[0]['a'];
        isLoading = false;
      });
    } else {
      setState(() {
        quote = "Could not load quote.";
        author = "Try again later.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.indigo],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 💭 Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Quotes Daily 💭',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      )
                    ],
                  ),
                ),
              ),

              Expanded(
                child: Center(
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.format_quote, color: Colors.white70, size: 50),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              '"$quote"',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Text(
                              '- $author',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: fetchQuote,
                        icon: Icon(Icons.refresh),
                        label: Text('New Quote'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.deepPurple,
                          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
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
    );
  }
}
