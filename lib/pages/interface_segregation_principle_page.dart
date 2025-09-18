import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../examples/interface_segregation_principle_example.dart';
import '../utils/controller_finder.dart';

// 4. ISP PAGE - Interface Segregation Principle
// This page demonstrates the Interface Segregation Principle
// Clients should not be forced to depend on methods they don't use

class InterfaceSegregationPrinciplePage extends StatelessWidget {
  const InterfaceSegregationPrinciplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('4. Interface Segregation Principle (ISP)'),
        backgroundColor: Colors.orange,
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
            // Notification type selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Select Notification Type',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Notification type radio buttons
                    Obx(() {
                      final controller =
                          ControllerFinder.notificationController;
                      return Column(
                        children: [
                          RadioListTile<String>(
                            title: const Text('Email'),
                            value: 'email',
                            groupValue:
                                controller.selectedNotificationType.value,
                            onChanged: (value) =>
                                controller.selectNotificationType(value!),
                          ),
                          RadioListTile<String>(
                            title: const Text('SMS'),
                            value: 'sms',
                            groupValue:
                                controller.selectedNotificationType.value,
                            onChanged: (value) =>
                                controller.selectNotificationType(value!),
                          ),
                          RadioListTile<String>(
                            title: const Text('Push'),
                            value: 'push',
                            groupValue:
                                controller.selectedNotificationType.value,
                            onChanged: (value) =>
                                controller.selectNotificationType(value!),
                          ),
                          RadioListTile<String>(
                            title: const Text('All Types'),
                            value: 'all',
                            groupValue:
                                controller.selectedNotificationType.value,
                            onChanged: (value) =>
                                controller.selectNotificationType(value!),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Notification form
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Send Notification',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Contact details based on selected type
                    Obx(() {
                      final controller =
                          ControllerFinder.notificationController;
                      final notificationType =
                          controller.selectedNotificationType.value;

                      return Column(
                        children: [
                          if (notificationType == 'email' ||
                              notificationType == 'all')
                            TextField(
                              controller: controller.emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email Address',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.email),
                              ),
                            ),
                          if (notificationType == 'email' ||
                              notificationType == 'all')
                            const SizedBox(height: 16),

                          if (notificationType == 'sms' ||
                              notificationType == 'all')
                            TextField(
                              controller: controller.phoneController,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.phone),
                              ),
                            ),
                          if (notificationType == 'sms' ||
                              notificationType == 'all')
                            const SizedBox(height: 16),

                          if (notificationType == 'push' ||
                              notificationType == 'all')
                            TextField(
                              controller: controller.deviceTokenController,
                              decoration: const InputDecoration(
                                labelText: 'Device Token',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.device_hub),
                              ),
                            ),
                          if (notificationType == 'push' ||
                              notificationType == 'all')
                            const SizedBox(height: 16),

                          // Subject field
                          TextField(
                            controller: controller.subjectController,
                            decoration: const InputDecoration(
                              labelText: 'Subject',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.subject),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Message field
                          TextField(
                            controller: controller.messageController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Message',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.message),
                            ),
                          ),
                        ],
                      );
                    }),

                    const SizedBox(height: 16),

                    // Send button
                    SizedBox(
                      width: double.infinity,
                      child: Obx(() {
                        final controller =
                            ControllerFinder.notificationController;
                        return ElevatedButton(
                          onPressed: controller.isSending.value
                              ? null
                              : controller.sendNotification,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                          child: controller.isSending.value
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
                                    Text('Sending...'),
                                  ],
                                )
                              : const Text(
                                  'Send Notification',
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

            // Notification history
            Expanded(
              child: Column(
                children: [
                  const Text(
                    'Notification History',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Obx(() {
                      final controller =
                          ControllerFinder.notificationController;
                      if (controller.notificationHistory.isEmpty) {
                        return const Center(
                          child: Text('No notifications sent yet'),
                        );
                      }
                      return ListView.builder(
                        itemCount: controller.notificationHistory.length,
                        itemBuilder: (context, index) {
                          return NotificationCard(
                            notification: controller.notificationHistory[index],
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
