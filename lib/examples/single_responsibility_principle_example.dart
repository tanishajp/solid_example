import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';

// 1. SINGLE RESPONSIBILITY PRINCIPLE (SRP) EXAMPLE
// Each class should have only one reason to change
// Each class should have only one responsibility
// Don’t mix database + UI + networking in the same class.

// USER VALIDATOR - Only responsible for validating user data
class UserValidator {
  static String? validateName(String name) {
    if (name.isEmpty) {
      return 'Name cannot be empty';
    }
    if (name.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!email.contains('@')) {
      return 'Email must contain @ symbol';
    }
    return null;
  }
}

// USER REPOSITORY - Only responsible for data storage operations
class UserRepository {
  final List<User> _users = [];

  // Add user to storage
  void addUser(User user) {
    _users.add(user);
  }

  // Get all users from storage
  List<User> getAllUsers() {
    return List.from(_users);
  }

  // Find user by ID
  User? findUserById(String id) {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }
}

// USER CONTROLLER - Only responsible for business logic coordination
class UserController extends GetxController {
  final UserRepository _userRepository = UserRepository();

  // Observable list for reactive UI updates
  final RxList<User> users = <User>[].obs;

  // Form fields for user input
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadUsers(); // Load existing users when controller initializes
  }

  // Load all users from repository
  void loadUsers() {
    users.value = _userRepository.getAllUsers();
  }

  // Add new user with validation
  void addUser() {
    // Get input values
    final name = nameController.text.trim();
    final email = emailController.text.trim();

    // Validate input using UserValidator
    final nameError = UserValidator.validateName(name);
    final emailError = UserValidator.validateEmail(email);

    // If validation fails, show error and return
    if (nameError != null || emailError != null) {
      Get.snackbar(
        'Validation Error',
        nameError ?? emailError ?? 'Invalid input',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Create new user
    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      createdAt: DateTime.now(),
    );

    // Add to repository
    _userRepository.addUser(newUser);

    // Update observable list
    loadUsers();

    // Clear form
    nameController.clear();
    emailController.clear();

    // Show success message
    Get.snackbar(
      'Success',
      'User added successfully!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}

// USER UI WIDGET - Only responsible for displaying user information
class UserCard extends StatelessWidget {
  final User user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              user.email,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              'Created: ${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
