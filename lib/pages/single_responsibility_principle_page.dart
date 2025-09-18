import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../examples/single_responsibility_principle_example.dart';
import '../utils/controller_finder.dart';

// 1. SRP PAGE - Single Responsibility Principle
// This page demonstrates the Single Responsibility Principle
// Each class has only one responsibility

class SingleResponsibilityPrinciplePage extends StatelessWidget {
  const SingleResponsibilityPrinciplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('1. Single Responsibility Principle (SRP)'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Form section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Add New User',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller:
                          ControllerFinder.userController.nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller:
                          ControllerFinder.userController.emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          ControllerFinder.userController.addUser(),
                      child: const Text('Add User'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Users list section - Using Obx for reactive updates
            Expanded(
              child: Obx(() {
                final controller = ControllerFinder.userController;
                if (controller.users.isEmpty) {
                  return const Center(child: Text('No users added yet'));
                }
                return ListView.builder(
                  itemCount: controller.users.length,
                  itemBuilder: (context, index) {
                    return UserCard(user: controller.users[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
