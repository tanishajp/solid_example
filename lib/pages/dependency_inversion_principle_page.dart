import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../examples/dependency_inversion_principle_example.dart';
import '../utils/controller_finder.dart';

// 5. DIP PAGE - Dependency Inversion Principle
// This page demonstrates the Dependency Inversion Principle
// High-level modules should not depend on low-level modules
// Both should depend on abstractions

class DependencyInversionPrinciplePage extends StatelessWidget {
  const DependencyInversionPrinciplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('5. Dependency Inversion Principle (DIP)'),
        backgroundColor: Colors.red,
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
            // Storage type selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Select Storage Type',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Storage type radio buttons
                    Obx(() {
                      final controller = ControllerFinder.dataController;
                      return Column(
                        children: [
                          RadioListTile<String>(
                            title: const Text('Local Storage'),
                            subtitle: const Text('Fast, local data storage'),
                            value: 'local',
                            groupValue: controller.selectedStorageType.value,
                            onChanged: (value) =>
                                controller.selectStorageType(value!),
                          ),
                          RadioListTile<String>(
                            title: const Text('Cloud Storage'),
                            subtitle: const Text('Remote, scalable storage'),
                            value: 'cloud',
                            groupValue: controller.selectedStorageType.value,
                            onChanged: (value) =>
                                controller.selectStorageType(value!),
                          ),
                          RadioListTile<String>(
                            title: const Text('Database Storage'),
                            subtitle: const Text(
                              'Persistent, structured storage',
                            ),
                            value: 'database',
                            groupValue: controller.selectedStorageType.value,
                            onChanged: (value) =>
                                controller.selectStorageType(value!),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Data operations form
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Data Operations',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // User ID field
                    TextField(
                      controller:
                          ControllerFinder.dataController.userIdController,
                      decoration: const InputDecoration(
                        labelText: 'User ID',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // User data field
                    TextField(
                      controller:
                          ControllerFinder.dataController.userDataController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'User Data',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.data_object),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Operation buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                ControllerFinder.dataController.saveUserData(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Save'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                ControllerFinder.dataController.getUserData(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Get'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => ControllerFinder.dataController
                                .deleteUserData(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Delete'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Backup button
                    SizedBox(
                      width: double.infinity,
                      child: Obx(() {
                        final controller = ControllerFinder.dataController;
                        return ElevatedButton(
                          onPressed: controller.isProcessing.value
                              ? null
                              : controller.backupData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                          ),
                          child: controller.isProcessing.value
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text('Processing...'),
                                  ],
                                )
                              : const Text(
                                  'Backup Data',
                                  style: TextStyle(fontSize: 16),
                                ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Data history
            Expanded(
              child: Column(
                children: [
                  const Text(
                    'Data Operations History',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Obx(() {
                      final controller = ControllerFinder.dataController;
                      if (controller.dataHistory.isEmpty) {
                        return const Center(
                          child: Text('No data operations yet'),
                        );
                      }
                      return ListView.builder(
                        itemCount: controller.dataHistory.length,
                        itemBuilder: (context, index) {
                          return DataCard(
                            operation: controller.dataHistory[index],
                            index: index,
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
