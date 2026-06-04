import 'package:flutter/material.dart';
import 'dart:ui';
import '../controllers/home_controller.dart';
import '../widgets/metric_card.dart';
import 'package:smart_eat_fit_life/views/tips_view.dart';
import 'package:smart_eat_fit_life/views/settings_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  final HomeController _controller = HomeController();
  int _selectedIndex = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1000,
      ), // Duración total de la animación
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      _animationController.forward(
        from: 0.0,
      ); // Reinicia la animación al volver a Inicio
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildDashboard(context),
      const TipsView(),
      const SettingsView(),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBody: true,
      body: SafeArea(bottom: false, child: pages[_selectedIndex]),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        height: 70,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(Icons.dashboard_outlined, Icons.dashboard_rounded, 'Inicio', 0),
                _buildNavItem(Icons.tips_and_updates_outlined, Icons.tips_and_updates_rounded, 'Comunidad', 1),
                _buildNavItem(Icons.settings_outlined, Icons.settings_rounded, 'Ajustes', 2),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _selectedIndex == 0
          ? ScaleTransition(
              scale: CurvedAnimation(
                parent: _animationController,
                curve: const Interval(
                  0.6,
                  1.0,
                  curve: Curves.easeOutBack,
                ), // Rebote suave al final
              ),
              child: FloatingActionButton(
                onPressed: _showAddEventBottomSheet,
                backgroundColor: Theme.of(context).colorScheme.onSurface,
                foregroundColor: Theme.of(context).colorScheme.surface,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.add_rounded),
              ),
            )
          : null,
    );
  }
  Widget _buildNavItem(IconData icon, IconData selectedIcon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(isSelected ? selectedIcon : icon, color: isSelected ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            if (isSelected)
              Text(
                label,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
              ),
          ],
        ),
      ),
    );
  }

  // Vista principal (Dashboard)
  Widget _buildDashboard(BuildContext context) {
    // El controlador provee los datos de forma limpia a la vista
    final metrics = _controller.getDashboardMetrics();

    return SingleChildScrollView(
      physics:
          const BouncingScrollPhysics(), // Scroll suave y con rebote estilo nativo
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 16.0,
        ), // Padding más amplio
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header y Resumen Animados para atrapar la atención
            FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
                ),
              ),
              child: SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(0.0, 0.2),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(
                          0.0,
                          0.4,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                    ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Saludo de Bienvenida Personalizado
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '¡Hola, Alex! 👋',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1.2,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Hoy es un gran día para entrenar.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: _showProfileBottomSheet,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Colors.black87, Colors.grey],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 26,
                              backgroundColor: Theme.of(context).colorScheme.surface,
                              child: Icon(
                                Icons.person_rounded,
                                color: Theme.of(context).colorScheme.onSurface,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),

                    // Tarjeta "Hero" (Resumen Diario Premium)
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF374151), Color(0xFF111827)], // Neutral premium dark gradient
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            right: -20,
                            bottom: -20,
                            child: Icon(
                              Icons.local_fire_department_rounded,
                              size: 150,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        'Objetivo Diario',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      '70% Completado',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -1,
                                      ),
                                    ),
                                    SizedBox(height: 24),
                                    // Barra de progreso mejorada
                                    Stack(
                                      children: [
                                        Container(
                                          height: 12,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        FractionallySizedBox(
                                          alignment: Alignment.centerLeft,
                                          widthFactor: 0.7,
                                          child: Container(
                                            height: 12,
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [Colors.orangeAccent, Colors.deepOrange],
                                              ),
                                              borderRadius: BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.deepOrange.withValues(alpha: 0.5),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 36),

            // Título Dinámico de la Sección de Métricas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tus Métricas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey.shade600,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text('Ver más'),
                ),
              ],
            ),
            SizedBox(height: 16),

            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = constraints.maxWidth > 900 ? 3 : 2;
                double aspectRatio = constraints.maxWidth > 600 ? 1.4 : 0.95;
                return GridView.builder(
                  shrinkWrap:
                      true, // Permite que el grid conviva con el listado de abajo
                  physics:
                      const NeverScrollableScrollPhysics(), // Evita doble scroll
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio:
                        aspectRatio, // Adaptado para móvil y desktop
                  ),
                  itemCount: metrics.length,
                  itemBuilder: (context, index) {
                    // Lógica de retraso escalonado para las cards
                    final double start = (index * 0.15).clamp(0.0, 1.0);
                    final double end = (start + 0.4).clamp(0.0, 1.0);

                    final Animation<double> opacityAnim =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(start, end, curve: Curves.easeOut),
                          ),
                        );

                    final Animation<Offset> slideAnim =
                        Tween<Offset>(
                          begin: const Offset(0.0, 0.5),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(
                              start,
                              end,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                        );

                    return FadeTransition(
                      opacity: opacityAnim,
                      child: SlideTransition(
                        position: slideAnim,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: MetricCard(metric: metrics[index]),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            SizedBox(height: 32),
            // Título interactivo de la agenda
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Agenda de Hoy',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                TextButton(
                  onPressed: _showAddEventBottomSheet,
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.add, size: 18),
                      SizedBox(width: 4),
                      Text(
                        'Añadir',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _controller.dailyEvents.length,
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final event = _controller.dailyEvents[index];

                // Lógica de retraso escalonado para cada elemento
                final double start = (index * 0.15).clamp(0.0, 1.0);
                final double end = (start + 0.4).clamp(0.0, 1.0);

                final Animation<double> opacityAnim =
                    Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(start, end, curve: Curves.easeOut),
                      ),
                    );

                final Animation<Offset> slideAnim =
                    Tween<Offset>(
                      begin: const Offset(
                        0.0,
                        0.5,
                      ), // Empieza un poco más abajo
                      end: Offset.zero, // Termina en su posición original
                    ).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(start, end, curve: Curves.easeOutCubic),
                      ),
                    );

                return FadeTransition(
                  opacity: opacityAnim,
                  child: SlideTransition(
                    position: slideAnim,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              decoration: BoxDecoration(
                                color: event['color'] as Color,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: (event['color'] as Color).withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(event['icon'] as IconData, color: event['color'] as Color, size: 24),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            event['title'] as String,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              letterSpacing: -0.3,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            event['desc'] as String,
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          event['time'] as String,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 14,
                                            color: Theme.of(context).colorScheme.onSurface,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        PopupMenuButton<String>(
                                          padding: EdgeInsets.zero,
                                          icon: Icon(Icons.more_horiz_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          onSelected: (value) {
                                            if (value == 'editar') {
                                              _showEditEventBottomSheet(index, event);
                                            } else if (value == 'terminado') {
                                              setState(() {
                                                _controller.dailyEvents[index]['color'] = Colors.green;
                                              });
                                            } else if (value == 'cancelado') {
                                              setState(() {
                                                _controller.dailyEvents[index]['color'] = Colors.grey;
                                              });
                                            }
                                          },
                                          itemBuilder: (context) => [
                                            const PopupMenuItem(
                                              value: 'terminado',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.check_circle_rounded, color: Colors.green),
                                                  SizedBox(width: 8),
                                                  Text('Completar'),
                                                ],
                                              ),
                                            ),
                                            const PopupMenuItem(
                                              value: 'editar',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.edit_rounded, color: Colors.blueAccent),
                                                  SizedBox(width: 8),
                                                  Text('Editar'),
                                                ],
                                              ),
                                            ),
                                            const PopupMenuItem(
                                              value: 'cancelado',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.cancel_rounded, color: Colors.redAccent),
                                                  SizedBox(width: 8),
                                                  Text('Cancelar'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 100,
            ), // Espacio extra grande al final para que no estorbe el FAB
          ],
        ),
      ),
    );
  }

  // Vista de relleno para las otras pestañas
  Widget _buildPlaceholder(String title) {
    return Center(
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        ),
      ),
    );
  }

  // Muestra un panel inferior con la información del Perfil del usuario
  void _showProfileBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade100,
                    child: Icon(
                      Icons.person_rounded,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 48,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Alex',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'alex@smartfitlife.com',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 24),
                  ListTile(
                    leading: Icon(Icons.person_outline_rounded),
                    title: Text(
                      'Editar Perfil',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.pie_chart_outline_rounded),
                    title: Text(
                      'Mis Objetivos',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(height: 24),
                  ListTile(
                    leading: Icon(
                      Icons.logout_rounded,
                      color: Colors.redAccent,
                    ),
                    title: Text(
                      'Cerrar Sesión',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.redAccent,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddEventBottomSheet() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();
    IconData selectedIcon = Icons.event;
    bool reminder = false;

    final List<IconData> iconsToChoose = [
      Icons.event,
      Icons.restaurant,
      Icons.directions_run,
      Icons.fitness_center,
      Icons.water_drop_rounded,
      Icons.bedtime_rounded,
      Icons.local_cafe_rounded,
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
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
                ).viewInsets.bottom, // Sube cuando abres el teclado
                left: 24,
                right: 24,
                top: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nuevo Evento',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Título del evento',
                        prefixIcon: Icon(Icons.title_rounded),
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
                    SizedBox(height: 16),
                    TextField(
                      controller: descController,
                      decoration: InputDecoration(
                        labelText: 'Breve descripción',
                        prefixIcon: Icon(Icons.description_rounded),
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
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime: selectedTime,
                              );
                              if (time != null) {
                                setModalState(() => selectedTime = time);
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.access_time_rounded),
                                  SizedBox(width: 8),
                                  Text(
                                    selectedTime.format(context),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recordar',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Switch(
                                  value: reminder,
                                  onChanged: (val) =>
                                      setModalState(() => reminder = val),
                                  activeThumbColor: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Elige un icono',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: iconsToChoose.map((icon) {
                        final isSelected = selectedIcon == icon;
                        return GestureDetector(
                          onTap: () => setModalState(() => selectedIcon = icon),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.black
                                  : Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              icon,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Validar que al menos tenga título
                          if (titleController.text.isEmpty) return;

                          setState(() {
                            _controller.addEvent({
                              'time': selectedTime.format(context),
                              'title': titleController.text,
                              'desc': descController.text.isEmpty
                                  ? (reminder
                                        ? 'Con recordatorio'
                                        : 'Sin descripción')
                                  : descController.text,
                              'icon': selectedIcon,
                              'color': Colors
                                  .blueAccent, // Color por defecto dinámico
                            });
                          });
                          Navigator.pop(context); // Cerramos el panel
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.onSurface,
                          foregroundColor: Theme.of(context).colorScheme.surface,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Guardar Evento',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEditEventBottomSheet(int index, Map<String, dynamic> event) {
    final TextEditingController titleController = TextEditingController(
      text: event['title'],
    );
    final TextEditingController descController = TextEditingController(
      text: event['desc'],
    );

    // Intentamos parsear la hora que ya tenía el evento
    TimeOfDay selectedTime = TimeOfDay.now();
    try {
      final timeStr = event['time'].toString();
      final RegExp regex = RegExp(
        r'(\d+):(\d+)\s*(AM|PM)?',
        caseSensitive: false,
      );
      final match = regex.firstMatch(timeStr);
      if (match != null) {
        int h = int.parse(match.group(1)!);
        int m = int.parse(match.group(2)!);
        String? period = match.group(3)?.toUpperCase();
        if (period == 'PM' && h < 12) h += 12;
        if (period == 'AM' && h == 12) h = 0;
        selectedTime = TimeOfDay(hour: h, minute: m);
      }
    } catch (_) {}

    IconData selectedIcon = event['icon'] as IconData? ?? Icons.event;
    bool reminder = event['desc'].toString().contains('recordatorio');

    final List<IconData> iconsToChoose = [
      Icons.event,
      Icons.restaurant,
      Icons.directions_run,
      Icons.fitness_center,
      Icons.water_drop_rounded,
      Icons.bedtime_rounded,
      Icons.local_cafe_rounded,
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom, // Teclado
                left: 24,
                right: 24,
                top: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Editar Evento',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Título del evento',
                        prefixIcon: Icon(Icons.title_rounded),
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
                    SizedBox(height: 16),
                    TextField(
                      controller: descController,
                      decoration: InputDecoration(
                        labelText: 'Breve descripción',
                        prefixIcon: Icon(Icons.description_rounded),
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
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime: selectedTime,
                              );
                              if (time != null) {
                                setModalState(() => selectedTime = time);
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.access_time_rounded),
                                  SizedBox(width: 8),
                                  Text(
                                    selectedTime.format(context),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recordar',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Switch(
                                  value: reminder,
                                  onChanged: (val) =>
                                      setModalState(() => reminder = val),
                                  activeThumbColor: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Elige un icono',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: iconsToChoose.map((icon) {
                        final isSelected = selectedIcon == icon;
                        return GestureDetector(
                          onTap: () => setModalState(() => selectedIcon = icon),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.black
                                  : Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              icon,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (titleController.text.isEmpty) return;

                          setState(() {
                            _controller.dailyEvents[index] = {
                              'time': selectedTime.format(context),
                              'title': titleController.text,
                              'desc': descController.text.isEmpty
                                  ? (reminder
                                        ? 'Con recordatorio'
                                        : 'Sin descripción')
                                  : descController.text,
                              'icon': selectedIcon,
                              'color':
                                  event['color'], // Mantenemos el color original
                            };
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.onSurface,
                          foregroundColor: Theme.of(context).colorScheme.surface,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Actualizar Evento',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
