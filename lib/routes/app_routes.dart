import 'package:get/get.dart';

import '../pages/dependency_inversion_principle_page.dart';
import '../pages/home_page.dart';
import '../pages/interface_segregation_principle_page.dart';
import '../pages/liskov_substitution_principle_page.dart';
import '../pages/open_closed_principle_page.dart';
import '../pages/single_responsibility_principle_page.dart';

// APP ROUTES - GetX Routing Configuration
// This class defines all the routes in the application
// It provides a centralized place to manage navigation

class AppRoutes {
  // Route names - constants for better maintainability
  static const String home = '/';
  static const String srp = '/srp';
  static const String ocp = '/ocp';
  static const String lsp = '/lsp';
  static const String isp = '/isp';
  static const String dip = '/dip';

  // GetX pages configuration
  static final List<GetPage> pages = [
    // Home page
    GetPage(name: home, page: () => const HomePage()),

    // Single Responsibility Principle
    GetPage(name: srp, page: () => const SingleResponsibilityPrinciplePage()),

    // Open/Closed Principle
    GetPage(name: ocp, page: () => const OpenClosedPrinciplePage()),

    // Liskov Substitution Principle
    GetPage(name: lsp, page: () => const LiskovSubstitutionPrinciplePage()),

    // Interface Segregation Principle
    GetPage(name: isp, page: () => const InterfaceSegregationPrinciplePage()),

    // Dependency Inversion Principle
    GetPage(name: dip, page: () => const DependencyInversionPrinciplePage()),
  ];
}
