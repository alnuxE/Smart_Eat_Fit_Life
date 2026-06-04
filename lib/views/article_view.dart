import 'package:flutter/material.dart';
import 'dart:ui';

class ArticleView extends StatefulWidget {
  const ArticleView({super.key});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> with SingleTickerProviderStateMixin {
  int _userRating = 0; 
  bool _isLiked = false;
  late AnimationController _animationController;

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
    final tip = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (tip == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Artículo no encontrado')),
        body: const Center(child: Text('Error al cargar el artículo.')),
      );
    }

    final Color tipColor = tip['color'] as Color? ?? Colors.black;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: AnimatedScale(
                          scale: _isLiked ? 1.2 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            _isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded, 
                            color: _isLiked ? Colors.redAccent : Colors.white,
                            size: 24,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _isLiked = !_isLiked;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: Hero(
                tag: 'icon_${tip['title']}', // Mismo tag que en TipsView
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        tipColor.withValues(alpha: 0.7),
                        tipColor.withValues(alpha: 0.9),
                        Colors.black87,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        right: -30,
                        bottom: -20,
                        child: Icon(
                          tip['icon'] as IconData? ?? Icons.article,
                          size: 200,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      Icon(
                        tip['icon'] as IconData? ?? Icons.article,
                        size: 80,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
                ),
              ),
              child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(0.0, 0.1), end: Offset.zero).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
                  ),
                ),
                child: Container(
                  transform: Matrix4.translationValues(0.0, -30.0, 0.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: tipColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                tip['category'] ?? 'General',
                                style: TextStyle(
                                  color: tipColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.menu_book_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  tip['readTime'] ?? '5 min',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        Text(
                          tip['title'] ?? '',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.2,
                            color: Theme.of(context).colorScheme.onSurface,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border(
                              left: BorderSide(color: tipColor, width: 4),
                            ),
                          ),
                          child: Text(
                            tip['desc'] ?? '',
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              height: 1.6,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        Text(
                          'Para mantener un estilo de vida saludable, es fundamental prestar atención a los detalles y construir hábitos sólidos. La constancia es la clave del éxito en cualquier disciplina.',
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            height: 1.8,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Recuerda que cada pequeño cambio cuenta y se acumula con el tiempo. No busques la perfección inmediata, sino el progreso continuo. La ciencia detrás de esto nos demuestra que el cuerpo se adapta mejor a los cambios graduales.',
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            height: 1.8,
                          ),
                        ),
                        const SizedBox(height: 48),
                        
                        // Sección de Calificación Premium con animación interna
                        Container(
                          padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF374151), Color(0xFF111827)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                            ),
                          child: Column(
                            children: [
                              const Text(
                                '¿Te fue útil este consejo?',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tu opinión nos ayuda a mejorar el contenido.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _userRating = index + 1;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: AnimatedScale(
                                        scale: index < _userRating ? 1.3 : 1.0,
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.elasticOut,
                                        child: Icon(
                                          Icons.star_rounded,
                                          color: index < _userRating ? Colors.amber : Colors.white.withValues(alpha: 0.2),
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
