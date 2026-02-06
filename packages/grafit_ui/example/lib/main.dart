import 'package:flutter/material.dart';
import 'package:grafit_ui/grafit_ui.dart';
import 'pages/home_page.dart';
import 'pages/components_page.dart';
import 'pages/theme_page.dart';

void main() {
  runApp(const GrafitExampleApp());
}

class GrafitExampleApp extends StatelessWidget {
  const GrafitExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grafit Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        extensions: [
          GrafitTheme.light(baseColor: 'zinc'),
        ],
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        extensions: [
          GrafitTheme.dark(baseColor: 'zinc'),
        ],
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/components': (context) => const ComponentsPage(),
        '/theme': (context) => const ThemePage(),
      },
    );
  }
}
