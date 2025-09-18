import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 4. INTERFACE SEGREGATION PRINCIPLE (ISP) EXAMPLE
// No client should be forced to depend on methods it does not use
// This example shows a notification system with segregated interfaces
// where clients only depend on the methods they actually need
// Interface should be small and specific

// EMAIL NOTIFICATION INTERFACE - Only for email-specific methods
abstract class EmailNotification {
  void sendEmail(String to, String subject, String body);
  void sendBulkEmail(List<String> recipients, String subject, String body);
}

// SMS NOTIFICATION INTERFACE - Only for SMS-specific methods
abstract class SMSNotification {
  void sendSMS(String phoneNumber, String message);
  void sendBulkSMS(List<String> phoneNumbers, String message);
}

// PUSH NOTIFICATION INTERFACE - Only for push-specific methods
abstract class PushNotification {
  void sendPush(String deviceToken, String title, String message);
  void sendBulkPush(List<String> deviceTokens, String title, String message);
}

// EMAIL SERVICE - Implements only email interface
class EmailService implements EmailNotification {
  @override
  void sendEmail(String to, String subject, String body) {}

  @override
  void sendBulkEmail(List<String> recipients, String subject, String body) {
    for (String recipient in recipients) {
      // Process each recipient
    }
  }
}

// SMS SERVICE - Implements only SMS interface
class SMSService implements SMSNotification {
  @override
  void sendSMS(String phoneNumber, String message) {}

  @override
  void sendBulkSMS(List<String> phoneNumbers, String message) {
    for (String phoneNumber in phoneNumbers) {
      // Process each phone number
    }
  }
}

// PUSH SERVICE - Implements only push interface
class PushService implements PushNotification {
  @override
  void sendPush(String deviceToken, String title, String message) {}

  @override
  void sendBulkPush(List<String> deviceTokens, String title, String message) {
    for (String deviceToken in deviceTokens) {
      // Process each device token
    }
  }
}

//  NOTIFICATION MANAGER - Coordinates different notification services
class NotificationManager {
  final EmailNotification _emailService;
  final SMSNotification _smsService;
  final PushNotification _pushService;

  NotificationManager({
    required EmailNotification emailService,
    required SMSNotification smsService,
    required PushNotification pushService,
  }) : _emailService = emailService,
       _smsService = smsService,
       _pushService = pushService;

  // Send email notification
  void sendEmailNotification(String to, String subject, String body) {
    _emailService.sendEmail(to, subject, body);
  }

  // Send SMS notification
  void sendSMSNotification(String phoneNumber, String message) {
    _smsService.sendSMS(phoneNumber, message);
  }

  // Send push notification
  void sendPushNotification(String deviceToken, String title, String message) {
    _pushService.sendPush(deviceToken, title, message);
  }

  // Send all types of notifications
  void sendAllNotifications({
    required String email,
    required String phoneNumber,
    required String deviceToken,
    required String subject,
    required String message,
  }) {
    sendEmailNotification(email, subject, message);
    sendSMSNotification(phoneNumber, message);
    sendPushNotification(deviceToken, subject, message);
  }
}

//  NOTIFICATION CONTROLLER - GetX controller for UI
class NotificationController extends GetxController {
  // This class has ONE responsibility: manage notification UI state
  final NotificationManager _notificationManager = NotificationManager(
    emailService: EmailService(),
    smsService: SMSService(),
    pushService: PushService(),
  );

  // Observable variables for reactive UI
  final RxList<String> notificationHistory = <String>[].obs;
  final RxBool isSending = false.obs;

  // Form controllers for notification input
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final deviceTokenController = TextEditingController();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  // Notification type selection
  final RxString selectedNotificationType = 'email'.obs;

  @override
  void onInit() {
    super.onInit();
    // Add some default notifications to demonstrate
    _addDefaultNotifications();
  }

  // Add default notifications for demonstration
  void _addDefaultNotifications() {
    notificationHistory.addAll([
      'Email: Welcome to our app!',
      'SMS: Your order has been confirmed',
      'Push: New message received',
    ]);
  }

  // Select notification type
  void selectNotificationType(String type) {
    selectedNotificationType.value = type;
  }

  // Send notification based on selected type
  void sendNotification() {
    try {
      final subject = subjectController.text.trim();
      final message = messageController.text.trim();

      if (subject.isEmpty || message.isEmpty) {
        _showError('Please enter subject and message');
        return;
      }

      isSending.value = true;

      switch (selectedNotificationType.value) {
        case 'email':
          final email = emailController.text.trim();
          if (email.isEmpty) {
            _showError('Please enter email address');
            return;
          }
          _notificationManager.sendEmailNotification(email, subject, message);
          notificationHistory.insert(0, 'Email: $subject');
          break;

        case 'sms':
          final phone = phoneController.text.trim();
          if (phone.isEmpty) {
            _showError('Please enter phone number');
            return;
          }
          _notificationManager.sendSMSNotification(phone, message);
          notificationHistory.insert(0, 'SMS: $message');
          break;

        case 'push':
          final deviceToken = deviceTokenController.text.trim();
          if (deviceToken.isEmpty) {
            _showError('Please enter device token');
            return;
          }
          _notificationManager.sendPushNotification(
            deviceToken,
            subject,
            message,
          );
          notificationHistory.insert(0, 'Push: $subject');
          break;

        case 'all':
          final email = emailController.text.trim();
          final phone = phoneController.text.trim();
          final deviceToken = deviceTokenController.text.trim();

          if (email.isEmpty || phone.isEmpty || deviceToken.isEmpty) {
            _showError('Please enter all contact details');
            return;
          }

          _notificationManager.sendAllNotifications(
            email: email,
            phoneNumber: phone,
            deviceToken: deviceToken,
            subject: subject,
            message: message,
          );
          notificationHistory.insert(0, 'All: $subject');
          break;

        default:
          _showError('Please select a notification type');
          return;
      }

      _clearForm();
      _showSuccess('Notification sent successfully!');
    } catch (e) {
      _showError('Error sending notification: ${e.toString()}');
    } finally {
      isSending.value = false;
    }
  }

  // Clear form
  void _clearForm() {
    emailController.clear();
    phoneController.clear();
    deviceTokenController.clear();
    subjectController.clear();
    messageController.clear();
  }

  // Show error message
  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  // Show success message
  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}

// NOTIFICATION CARD - Widget for displaying notifications
class NotificationCard extends StatelessWidget {
  final String notification;
  final int index;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Notification icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getNotificationColor(),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                _getNotificationIcon(),
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),

            // Notification content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sent ${_getTimeAgo()}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getNotificationColor() {
    if (notification.contains('Email')) return Colors.blue;
    if (notification.contains('SMS')) return Colors.green;
    if (notification.contains('Push')) return Colors.orange;
    return Colors.purple;
  }

  IconData _getNotificationIcon() {
    if (notification.contains('Email')) return Icons.email;
    if (notification.contains('SMS')) return Icons.sms;
    if (notification.contains('Push')) return Icons.notifications;
    return Icons.notifications_active;
  }

  String _getTimeAgo() {
    final minutes = index * 5; // Simulate time difference
    if (minutes < 60) return '${minutes}m ago';
    final hours = minutes ~/ 60;
    return '${hours}h ago';
  }
}
