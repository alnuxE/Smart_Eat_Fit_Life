import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/metric_model.dart';
import '../controllers/detail_controller.dart';

class DetailView extends StatefulWidget {
  const DetailView({super.key});

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView>
    with SingleTickerProviderStateMixin {
  String _selectedPeriod = 'Hoy';
  late AnimationController _animationController;
  List<FlSpot>? _todaySpots;
  String? _currentValue;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Recuperamos los datos enviados desde la ruta dinámicamente
    final metric = ModalRoute.of(context)!.settings.arguments as Metric;
    // Instanciamos el controlador específico de esta vista
    final controller = DetailController(metric);

    // Inicializamos el valor interactivo
    _currentValue ??= metric.currentValue;
    if (_todaySpots == null) {
      // Datos de ejemplo para que la gráfica no esté vacía al abrir
      if (metric.title == 'Calorías Consumidas') {
        _todaySpots = [const FlSpot(10, 450)];
      } else if (metric.title.contains('Peso')) {
        _todaySpots = [
          FlSpot(10, double.tryParse(metric.currentValue) ?? 72.0),
        ];
      } else {
        _todaySpots = [FlSpot(10, double.tryParse(metric.currentValue) ?? 0.0)];
      }
    }

    // Configuramos las animaciones escalonadas
    final slideAnim1 =
        Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
          ),
        );
    final fadeAnim1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    final slideAnim2 =
        Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
          ),
        );
    final fadeAnim2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );

    final slideAnim3 =
        Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
          ),
        );
    final fadeAnim3 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          metric.title,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tarjeta estática de resumen arriba
              FadeTransition(
                opacity: fadeAnim1,
                child: SlideTransition(
                  position: slideAnim1,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF374151), Color(0xFF111827)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Valor Actual',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  _currentValue!,
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: -1,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  metric.unit,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.auto_graph_rounded, // Ícono llamativo
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              FadeTransition(
                opacity: fadeAnim2,
                child: SlideTransition(
                  position: slideAnim2,
                  child: SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 16, // Espacio si se juntan en la misma línea
                      runSpacing:
                          12, // Espacio vertical si los botones bajan de línea
                      children: [
                        Text(
                          'Historial Detallado',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        // Selector interactivo y animado
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: ['Hoy', 'Día', 'Mes', 'Año'].map((
                              period,
                            ) {
                              final isSelected = _selectedPeriod == period;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedPeriod = period;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeInOut,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.surface
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.05,
                                              ),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Text(
                                    period,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? Theme.of(context).colorScheme.onSurface
                                          : Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Gráfica de puntos interactiva con cuadrícula
              Expanded(
                child: FadeTransition(
                  opacity: fadeAnim3,
                  child: SlideTransition(
                    position: slideAnim3,
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 32,
                        right: 32,
                        left: 16,
                        bottom: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(
                          24,
                        ), // Bordes más suaves
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: Theme.of(context).colorScheme.surfaceContainerHighest),
                      ),
                      child: LineChart(
                        key: ValueKey(
                          _selectedPeriod,
                        ), // FIX: Reconstruye el chart al cambiar de período para evitar la animación extraña.
                        LineChartData(
                          // Habilita la interacción al tocar la gráfica
                          lineTouchData: LineTouchData(
                            handleBuiltInTouches: true,
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipColor: (touchedSpot) => Theme.of(context).colorScheme.onSurface,
                              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                                return touchedSpots.map((barSpot) {
                                  return LineTooltipItem(
                                    '${barSpot.y.toStringAsFixed(0)} ${metric.unit}',
                                    TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                            getTouchedSpotIndicator:
                                (
                                  LineChartBarData barData,
                                  List<int> spotIndexes,
                                ) {
                                  return spotIndexes.map((spotIndex) {
                                    return TouchedSpotIndicatorData(
                                      FlLine(
                                        color: Theme.of(context).colorScheme.onSurface.withValues(
                                          alpha: 0.3,
                                        ),
                                        strokeWidth: 1,
                                        dashArray: [4, 4],
                                      ),
                                      FlDotData(
                                        getDotPainter:
                                            (spot, percent, barData, index) {
                                              return FlDotCirclePainter(
                                                radius: 8,
                                                color: Theme.of(context).colorScheme.onSurface,
                                                strokeWidth: 4,
                                                strokeColor: Theme.of(context).colorScheme.surface,
                                              );
                                            },
                                      ),
                                    );
                                  }).toList();
                                },
                          ),

                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                strokeWidth: 1,
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                interval: _selectedPeriod == 'Hoy'
                                    ? 3
                                    : 1, // Espaciado dinámico para no amontonar las horas
                                getTitlesWidget: (value, meta) {
                                  String label = '';
                                  if (_selectedPeriod == 'Hoy') {
                                    label =
                                        '${value.toInt()}h'; // Muestra 8h, 11h, 14h...
                                  } else {
                                    String prefix = 'D';
                                    if (_selectedPeriod == 'Mes') prefix = 'M';
                                    if (_selectedPeriod == 'Año') prefix = 'A';
                                    label = '$prefix${value.toInt()}';
                                  }

                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(
                                      label,
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 45,
                                getTitlesWidget: (value, meta) {
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(
                                      '${value.toInt()}',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: _selectedPeriod == 'Hoy'
                                  ? _todaySpots!
                                  : metric.history
                                        .map((data) => FlSpot(data.x, data.y))
                                        .toList(),
                              isCurved: true,
                              color: Theme.of(context).colorScheme.onSurface,
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 5,
                                    color: Theme.of(context).colorScheme.onSurface,
                                    strokeWidth: 2,
                                    strokeColor: Colors.white,
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                                    Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.0),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FadeTransition(
        opacity: fadeAnim3,
        child: FloatingActionButton.extended(
          onPressed: () => _showAddRecordBottomSheet(context, metric),
          backgroundColor: Theme.of(context).colorScheme.onSurface,
          foregroundColor: Theme.of(context).colorScheme.surface,
          elevation: 4,
          icon: const Icon(Icons.add_rounded),
          label: const Text(
            'Registrar',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void _showAddRecordBottomSheet(BuildContext context, Metric metric) {
    final TextEditingController valueController = TextEditingController();
    String selectedTime = 'Día';

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      isScrollControlled:
          true, // Importante para que el panel no sea tapado por el teclado
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(
                  context,
                ).viewInsets.bottom, // Empuja con el teclado
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nuevo Registro',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setModalState(() => selectedTime = 'Día'),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: selectedTime == 'Día'
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(context).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '☀ Día',
                              style: TextStyle(
                                color: selectedTime == 'Día'
                                    ? Theme.of(context).colorScheme.surface
                                    : Theme.of(context).colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setModalState(() => selectedTime = 'Noche'),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: selectedTime == 'Noche'
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(context).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '🌙 Noche',
                              style: TextStyle(
                                color: selectedTime == 'Noche'
                                    ? Theme.of(context).colorScheme.surface
                                    : Theme.of(context).colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: valueController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Valor ingresado (${metric.unit})',
                      prefixIcon: const Icon(Icons.edit_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onSurface,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final double? val = double.tryParse(
                          valueController.text,
                        );
                        if (val != null) {
                          setState(() {
                            // Actualizamos la tarjeta de valor grande
                            _currentValue = val.toStringAsFixed(
                              metric.unit == 'kg' ? 1 : 0,
                            );
                            // Hora para la gráfica (10 = Día, 20 = Noche)
                            double xValue = selectedTime == 'Día' ? 10.0 : 20.0;

                            // Quitamos un registro anterior a la misma hora si existiera
                            _todaySpots!.removeWhere((s) => s.x == xValue);
                            _todaySpots!.add(FlSpot(xValue, val));
                            _todaySpots!.sort((a, b) => a.x.compareTo(b.x));

                            // Forzamos la vista a 'Hoy' para que el usuario vea el cambio
                            _selectedPeriod = 'Hoy';
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.onSurface,
                        foregroundColor: Theme.of(context).colorScheme.surface,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Guardar Registro',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
