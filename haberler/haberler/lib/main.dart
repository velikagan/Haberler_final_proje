import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'language_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/boarding_screen.dart';
import 'screens/news_screen.dart';
import 'screens/reporters_screen.dart';
import 'screens/mynews_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.currentTheme,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          routerConfig: _router,
        );
      },
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      navigatorKey: GlobalKey<NavigatorState>(),
      builder: (context, state, child) {
        bool showBottomNav = !['/', '/boarding'].contains(state.location);
        return Scaffold(
          body: child,
          bottomNavigationBar: showBottomNav
              ? BottomNavigationBar(
            currentIndex: _calculateSelectedIndex(state.location),
            onTap: (index) {
              switch (index) {
                case 0:
                  context.go('/news');
                  break;
                case 1:
                  context.go('/reporters');
                  break;
                case 2:
                  context.go('/mynews');
                  break;
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.article),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.share),
                label: '',
              ),
            ],
            type: BottomNavigationBarType.fixed, // İkonların ortalanmasını sağlar
            selectedFontSize: 0, // Seçili metnin boyutunu sıfıra ayarlar
            unselectedFontSize: 0, // Seçili olmayan metnin boyutunu sıfıra ayarlar
          )
              : null,
        );
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => SplashScreen(),
        ),
        GoRoute(
          path: '/boarding',
          builder: (context, state) => BoardingScreen(),
        ),
        GoRoute(
          path: '/news',
          builder: (context, state) => NewsScreen(),
        ),
        GoRoute(
          path: '/reporters',
          builder: (context, state) => ReportersScreen(),
        ),
        GoRoute(
          path: '/mynews',
          builder: (context, state) => MyNewsScreen(),
        ),
      ],
    ),
  ],
);

int _calculateSelectedIndex(String location) {
  if (location.startsWith('/news')) {
    return 0;
  }
  if (location.startsWith('/reporters')) {
    return 1;
  }
  if (location.startsWith('/mynews')) {
    return 2;
  }
  return 0;
}
