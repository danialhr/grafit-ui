import 'package:flutter/material.dart';
import 'package:grafit_ui/grafit_ui.dart';
import 'screens/home_screen.dart';
import 'screens/form_components_screen.dart';
import 'screens/navigation_screen.dart';
import 'screens/overlay_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/data_display_screen.dart';
import 'screens/specialized_screen.dart';

void main() {
  runApp(const GrafitExampleApp());
}

class GrafitExampleApp extends StatelessWidget {
  const GrafitExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grafit UI Demo',
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
        '/': (context) => const HomeScreen(),
        '/form': (context) => const FormComponentsScreen(),
        '/navigation': (context) => const NavigationScreen(),
        '/overlay': (context) => const OverlayScreen(),
        '/feedback': (context) => const FeedbackScreen(),
        '/data-display': (context) => const DataDisplayScreen(),
        '/specialized': (context) => const SpecializedScreen(),
      },
    );
  }
}
