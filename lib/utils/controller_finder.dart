import 'package:get/get.dart';

import '../examples/dependency_inversion_principle_example.dart';
import '../examples/interface_segregation_principle_example.dart';
import '../examples/liskov_substitution_principle_example.dart';
import '../examples/open_closed_principle_example.dart';
import '../examples/single_responsibility_principle_example.dart';

// COMMON CONTROLLER FINDER UTILITY
// This utility provides a common way to find controllers
// and reduces code duplication across the app

class ControllerFinder {
  // Generic method to find any controller type
  static T find<T>() {
    return Get.find<T>();
  }

  // Specific method for UserController (from SRP example)
  static UserController get userController => Get.find<UserController>();

  // Specific method for PaymentController (from OCP example)
  static PaymentController get paymentController =>
      Get.find<PaymentController>();

  // Specific method for ShapeController (from LSP example)
  static ShapeController get shapeController => Get.find<ShapeController>();

  // Specific method for NotificationController (from ISP example)
  static NotificationController get notificationController =>
      Get.find<NotificationController>();

  // Specific method for DataController (from DIP example)
  static DataController get dataController => Get.find<DataController>();
}
