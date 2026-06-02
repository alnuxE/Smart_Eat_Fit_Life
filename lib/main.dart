import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const SmartEatFitLifeApp());
}

class SmartEatFitLifeApp extends StatelessWidget {
  const SmartEatFitLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Eat Fit Life',
      debugShowCheckedModeBanner: false,
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
      initialRoute: AppRoutes.home,
      routes: AppRoutes.getRoutes(),
    );
  }
}
