import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class BoardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("HABERLER",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26
              ),),
            Image.asset('assets/images/logo.png',
              width: 180,
              height: 180,),
            SizedBox(height: 20), // Boşluk için
            Text(
              'En güncel haberleri bu uygulamada bulabilirsiniz.\nVe kendi haberlerinizi paylaşabilirsiniz.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isFirstTime', false);
                context.go('/news');
              },
              child: Text('Başlayın'),
            ),
          ],
        ),
      ),
    );  }
}

