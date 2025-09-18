import 'package:get/get.dart';

import '../examples/dependency_inversion_principle_example.dart';
import '../examples/interface_segregation_principle_example.dart';
import '../examples/liskov_substitution_principle_example.dart';
import '../examples/open_closed_principle_example.dart';
import '../examples/single_responsibility_principle_example.dart';

// APP BINDING - Dependency Injection
// This class handles all dependency injection for the app
// It's called when the app starts and manages controller lifecycle

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize UserController for SRP example
    Get.put<UserController>(UserController(), permanent: true);

    // Initialize PaymentController for OCP example
    Get.put<PaymentController>(PaymentController(), permanent: true);

    // Initialize ShapeController for LSP example
    Get.put<ShapeController>(ShapeController(), permanent: true);

    // Initialize NotificationController for ISP example
    Get.put<NotificationController>(NotificationController(), permanent: true);

    // Initialize DataController for DIP example
    Get.put<DataController>(DataController(), permanent: true);
  }
}
