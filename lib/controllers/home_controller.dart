import 'package:flutter/material.dart';
import '../models/metric_model.dart';

class HomeController {
  // Simulación de eventos del día (Templates) movidos desde la vista para respetar MVC
  final List<Map<String, dynamic>> dailyEvents = [
    {
      'time': '07:30 AM',
      'title': 'Desayuno',
      'desc': 'Avena con frutos rojos - 350 kcal',
      'icon': Icons.restaurant,
      'color': Colors.orange,
    },
    {
      'time': '09:00 AM',
      'title': 'Correr',
      'desc': 'Cardio matutino - 5 km',
      'icon': Icons.directions_run,
      'color': Colors.blue,
    },
    {
      'time': '02:30 PM',
      'title': 'Comida',
      'desc': 'Pechuga de pollo y ensalada - 450 kcal',
      'icon': Icons.restaurant,
      'color': Colors.green,
    },
    {
      'time': '07:00 PM',
      'title': 'Gimnasio',
      'desc': 'Rutina de tren superior',
      'icon': Icons.fitness_center,
      'color': Colors.purple,
    },
  ];

  // Base de datos simulada de los Consejos (Tips) de estilo de vida
  final List<Map<String, dynamic>> lifestyleTips = [
    {
      'category': 'Nutrición',
      'title': 'Horarios ideales para comer',
      'desc':
          'Expertos recomiendan cenar al menos 2 horas antes de dormir para mejorar la digestión y la calidad del sueño. Intenta mantener ventanas de comida regulares.',
      'icon': Icons.schedule_rounded,
      'color': Colors.orange,
      'readTime': '3 min',
      'featured': true, // Este será nuestro consejo principal (Hero)
      'rating': 4.8,
    },
    {
      'category': 'Ejercicio',
      'title': 'Postura correcta al correr',
      'desc':
          'Mantén la mirada al frente, hombros relajados y aterriza con la parte media del pie para reducir el impacto en tus rodillas y evitar lesiones.',
      'icon': Icons.directions_run_rounded,
      'color': Colors.blue,
      'readTime': '4 min',
      'featured': false,
      'rating': 4.5,
    },
    {
      'category': 'Descanso',
      'title': 'La regla 10-3-2-1-0',
      'desc':
          '10h sin cafeína, 3h sin comida pesada, 2h sin trabajo, 1h sin pantallas y 0 veces posponer tu alarma matutina. Un hack vital para tu energía.',
      'icon': Icons.bedtime_rounded,
      'color': Colors.purple,
      'readTime': '2 min',
      'featured': false,
      'rating': 5.0,
    },
    {
      'category': 'Hidratación',
      'title': 'No esperes a tener sed',
      'desc':
          'La sed es un síntoma tardío de deshidratación. Acostúmbrate a tener un termo cerca y beber pequeños sorbos de agua durante todo el día.',
      'icon': Icons.water_drop_rounded,
      'color': Colors.cyan,
      'readTime': '1 min',
      'featured': false,
      'rating': 4.2,
    },
  ];

  // Lógica para añadir eventos gestionada por el controlador
  void addEvent(Map<String, dynamic> event) {
    dailyEvents.add(event);
  }

  // Simula la obtención de datos para nuestra vista (Controlador)
  List<Metric> getDashboardMetrics() {
    return [
      Metric(
        title: 'Historial de Peso',
        unit: 'kg',
        currentValue: '72.5',
        history: [
          MetricData(x: 1, y: 75.0),
          MetricData(x: 2, y: 74.2),
          MetricData(x: 3, y: 73.8),
          MetricData(x: 4, y: 73.0),
          MetricData(x: 5, y: 72.5),
        ],
      ),
      Metric(
        title: 'Calorías Consumidas',
        unit: 'kcal',
        currentValue: '2100',
        history: [
          MetricData(x: 1, y: 2200),
          MetricData(x: 2, y: 1900),
          MetricData(x: 3, y: 2400),
          MetricData(x: 4, y: 2000),
          MetricData(x: 5, y: 2100),
        ],
      ),
      Metric(
        title: 'Calorías Quemadas',
        unit: 'kcal',
        currentValue: '650',
        history: [
          MetricData(x: 1, y: 500),
          MetricData(x: 2, y: 600),
          MetricData(x: 3, y: 450),
          MetricData(x: 4, y: 700),
          MetricData(x: 5, y: 650),
        ],
      ),
    ];
  }
}
