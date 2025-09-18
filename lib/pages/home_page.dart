import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

// HOME PAGE - SOLID Principles Navigation
// This page provides navigation to different SOLID principle examples

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SOLID Principles Examples'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Choose a SOLID Principle to explore:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // 1. Single Responsibility Principle
              _buildPrincipleCard(
                title: '1. Single Responsibility Principle (SRP)',
                description: 'Each class should have only one reason to change',
                color: Colors.blue,
                onTap: () => Get.toNamed(AppRoutes.srp),
              ),

              const SizedBox(height: 16),

              // 2. Open/Closed Principle
              _buildPrincipleCard(
                title: '2. Open/Closed Principle (OCP)',
                description: 'Open for extension, closed for modification',
                color: Colors.green,
                onTap: () => Get.toNamed(AppRoutes.ocp),
              ),

              const SizedBox(height: 16),

              // 3. Liskov Substitution Principle
              _buildPrincipleCard(
                title: '3. Liskov Substitution Principle (LSP)',
                description:
                    'Objects should be replaceable with instances of their subtypes',
                color: Colors.purple,
                onTap: () => Get.toNamed(AppRoutes.lsp),
              ),

              const SizedBox(height: 16),

              // 4. Interface Segregation Principle
              _buildPrincipleCard(
                title: '4. Interface Segregation Principle (ISP)',
                description:
                    'No client should be forced to depend on methods it does not use',
                color: Colors.orange,
                onTap: () => Get.toNamed(AppRoutes.isp),
              ),

              const SizedBox(height: 16),

              // 5. Dependency Inversion Principle
              _buildPrincipleCard(
                title: '5. Dependency Inversion Principle (DIP)',
                description: 'Depend on abstractions, not concretions',
                color: Colors.red,
                onTap: () => Get.toNamed(AppRoutes.dip),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrincipleCard({
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 60,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
