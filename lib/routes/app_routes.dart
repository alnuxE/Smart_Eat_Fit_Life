import 'package:flutter/material.dart';
import '../views/home_view.dart';
import '../views/detail_view.dart';
import '../views/article_view.dart';

class AppRoutes {
  static const String home = '/';
  static const String detail = '/detail';
  static const String article = '/article';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomeView(),
      detail: (context) => const DetailView(),
      article: (context) => const ArticleView(),
    };
  }
}
