import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../language_provider.dart';
import 'package:provider/provider.dart';

class ReportersScreen extends StatefulWidget {
  @override
  _ReportersScreenState createState() => _ReportersScreenState();
}

class _ReportersScreenState extends State<ReportersScreen> {
  List<dynamic> reporters = [];

  @override
  void initState() {
    super.initState();
    _fetchReporters();
  }

  Future<void> _fetchReporters() async {
    final response = await http.get(Uri.parse('https://reqres.in/api/users?page=2'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        reporters = data['data'];
      });
    } else {
      throw Exception('Failed to load reporters');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Consumer<LanguageProvider>(
          builder: (context, languageProvider, child) {
            return Text(languageProvider.isEnglish ? 'Reporters' : 'Haberciler');
          },
        ),
      ),
      body: ListView.builder(
        itemCount: reporters.length,
        itemBuilder: (context, index) {
          final reporter = reporters[index];
          return Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Büyük fotoğraf
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100.0),
                    child: ClipOval(
                      child: Image.network(
                        reporter['avatar'],
                        height: 140,
                        width: 140,  // Bu satırı ekledik
                        fit: BoxFit.cover,  // Bu satırı fitWidth yerine kullanıyoruz
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${reporter['first_name']} ${reporter['last_name']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    reporter['email'],
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
