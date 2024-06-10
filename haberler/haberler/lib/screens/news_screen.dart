import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import '../language_provider.dart';
import '../theme_provider.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<dynamic> newsList = [];

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    String fileName = languageProvider.isEnglish ? 'assets/newsEn.json' : 'assets/news.json';
    final String response = await rootBundle.loadString(fileName);
    final data = await json.decode(response);
    setState(() {
      newsList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Consumer<LanguageProvider>(
          builder: (context, languageProvider, child) {
            return Text(languageProvider.isEnglish ? 'News' : 'Haberler');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              _showSettingsDialog(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Image.asset(newsList[index]['imageUrl']),
              title: Text(newsList[index]['new']),
            ),
          );
        },
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              return Text(languageProvider.isEnglish ? 'Settings' : 'Ayarlar');
            },
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Provider.of<LanguageProvider>(context, listen: false).isEnglish ? 'Dark Mode:' : 'Karanlık Mod:'),
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return Switch(
                        value: themeProvider.isDarkMode,
                        onChanged: (value) {
                          themeProvider.toggleTheme();
                        },
                      );
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Provider.of<LanguageProvider>(context, listen: false).isEnglish ? 'English:' : 'İngilizce:'),
                  Consumer<LanguageProvider>(
                    builder: (context, languageProvider, child) {
                      return Switch(
                        value: languageProvider.isEnglish,
                        onChanged: (value) {
                          languageProvider.toggleLanguage();
                          _loadNews(); // Verileri yeniden yükle
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(Provider.of<LanguageProvider>(context, listen: false).isEnglish ? 'Close' : 'Kapat'),
            ),
          ],
        );
      },
    );
  }
}
