import 'package:flutter/material.dart';
import 'dart:ui';
import '../controllers/home_controller.dart';
import '../routes/app_routes.dart';

class TipsView extends StatefulWidget {
  const TipsView({super.key});

  @override
  State<TipsView> createState() => _TipsViewState();
}

class _TipsViewState extends State<TipsView> with SingleTickerProviderStateMixin {
  final HomeController _controller = HomeController();
  
  final Map<int, bool> _likedPosts = {};
  final Map<int, int> _userRatings = {};
  
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
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
    final tips = _controller.lifestyleTips;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        title: Text(
          'Comunidad',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
          ),
        ),
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.notifications_active_outlined, color: Colors.black87),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 80, 
          bottom: 100,
        ),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          final tip = tips[index];
          final isLiked = _likedPosts[index] ?? false;
          final currentRating = _userRatings[index] ?? 0;
          final tipColor = tip['color'] as Color;

          // Calcular el delay para efecto en cascada (staggered animation)
          final double start = (index * 0.15).clamp(0.0, 1.0);
          final double end = (start + 0.5).clamp(0.0, 1.0);

          final slideAnimation = Tween<Offset>(
            begin: const Offset(0.0, 0.3),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(start, end, curve: Curves.easeOutCubic),
            ),
          );

          final fadeAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(start, end, curve: Curves.easeOut),
            ),
          );

          return FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(
              position: slideAnimation,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header (Autor)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  tipColor.withValues(alpha: 0.8),
                                  tipColor,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: tipColor.withValues(alpha: 0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              tip['icon'] as IconData,
                              color: Theme.of(context).colorScheme.surface,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tip['category'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.onSurface,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                Text(
                                  'Experto • Hace 2h',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.more_horiz_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ],
                      ),
                    ),
                    
                    // Área de "Media" simulada
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.article,
                          arguments: tip,
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 180,
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            colors: [
                              tipColor.withValues(alpha: 0.1),
                              tipColor.withValues(alpha: 0.02),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          border: Border.all(
                            color: tipColor.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Hero(
                            tag: 'icon_${tip['title']}', // Hero animation para transición fluida
                            child: Icon(
                              tip['icon'] as IconData,
                              size: 80,
                              color: tipColor.withValues(alpha: 0.2),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Contenido de Texto
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tip['title'],
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.7,
                              color: Theme.of(context).colorScheme.onSurface,
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            tip['desc'],
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              height: 1.5,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Footer (Reacciones)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(32),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _likedPosts[index] = !isLiked;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isLiked ? Colors.redAccent.withValues(alpha: 0.1) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      AnimatedScale(
                                        scale: isLiked ? 1.2 : 1.0,
                                        duration: const Duration(milliseconds: 150),
                                        child: Icon(
                                          isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                          color: isLiked ? Colors.redAccent : Theme.of(context).colorScheme.onSurfaceVariant,
                                          size: 22,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        isLiked ? '124' : '123',
                                        style: TextStyle(
                                          color: isLiked ? Colors.redAccent : Theme.of(context).colorScheme.onSurfaceVariant,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              IconButton(
                                icon: Icon(Icons.chat_bubble_outline_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 22),
                                onPressed: () {
                                  Navigator.pushNamed(context, AppRoutes.article, arguments: tip);
                                },
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: List.generate(5, (starIndex) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _userRatings[index] = starIndex + 1;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                    child: AnimatedScale(
                                      scale: starIndex < currentRating ? 1.2 : 1.0,
                                      duration: const Duration(milliseconds: 200),
                                      curve: Curves.elasticOut,
                                      child: Icon(
                                        Icons.star_rounded,
                                        color: starIndex < currentRating ? Colors.amber : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
