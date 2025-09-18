import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bindings/app_binding.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SOLID Principles Example',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      initialBinding: AppBinding(), // Use binding for dependency injection
      initialRoute: AppRoutes.home, // Use routes for navigation
      getPages: AppRoutes.pages, // Use centralized routes
    );
  }
}
