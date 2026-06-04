import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

void main() {
  runApp(const SmartEatFitLifeApp());
}

class SmartEatFitLifeApp extends StatelessWidget {
  const SmartEatFitLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, _) {
        return MaterialApp(
          title: 'Smart Eat Fit Life',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.black, // Color sólido al estilo Google/Next.js
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: const Color(
              0xFFF9FAFB,
            ), // Fondo gris muy claro minimalista
            fontFamily: 'Roboto', // Tipografía estándar y sólida
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white,
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(0xFF121212),
            fontFamily: 'Roboto',
          ),
          initialRoute: AppRoutes.home,
          routes: AppRoutes.getRoutes(),
        );
      },
    );
  }
}
