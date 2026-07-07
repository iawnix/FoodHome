import 'package:flutter/material.dart';
import 'package:foodhome_app/core/routing/app_router.dart';
import 'package:foodhome_app/core/theme/app_theme.dart';

class FoodHomeApp extends StatelessWidget {
  const FoodHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FoodHome',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      routerConfig: appRouter,
    );
  }
}
