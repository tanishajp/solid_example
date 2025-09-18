import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 5. DEPENDENCY INVERSION PRINCIPLE (DIP) EXAMPLE
// Depend on abstractions, not concretions
// This example shows a data storage system with dependency inversion
// where high-level modules depend on abstractions, not concrete implementations

//  DATA STORAGE INTERFACE - Abstraction for data storage
abstract class DataStorage {
  Future<void> save(String key, String value);
  Future<String?> get(String key);
  Future<void> delete(String key);
  Future<List<String>> getAllKeys();
}

//  LOCAL STORAGE IMPLEMENTATION - Concrete implementation
class LocalStorage implements DataStorage {
  final Map<String, String> _storage = {};

  @override
  Future<void> save(String key, String value) async {
    await Future.delayed(
      const Duration(milliseconds: 100),
    ); // Simulate async operation
    _storage[key] = value;
  }

  @override
  Future<String?> get(String key) async {
    await Future.delayed(
      const Duration(milliseconds: 100),
    ); // Simulate async operation
    final value = _storage[key];
    return value;
  }

  @override
  Future<void> delete(String key) async {
    await Future.delayed(
      const Duration(milliseconds: 100),
    ); // Simulate async operation
    _storage.remove(key);
  }

  @override
  Future<List<String>> getAllKeys() async {
    await Future.delayed(
      const Duration(milliseconds: 100),
    ); // Simulate async operation
    final keys = _storage.keys.toList();
    return keys;
  }
}

//  CLOUD STORAGE IMPLEMENTATION - Concrete implementation
class CloudStorage implements DataStorage {
  @override
  Future<void> save(String key, String value) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay
  }

  @override
  Future<String?> get(String key) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay
    return 'Cloud data for $key';
  }

  @override
  Future<void> delete(String key) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay
  }

  @override
  Future<List<String>> getAllKeys() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay
    return ['cloud_key_1', 'cloud_key_2', 'cloud_key_3'];
  }
}

//  DATABASE STORAGE IMPLEMENTATION - Concrete implementation
class DatabaseStorage implements DataStorage {
  @override
  Future<void> save(String key, String value) async {
    await Future.delayed(
      const Duration(milliseconds: 200),
    ); // Simulate database operation
  }

  @override
  Future<String?> get(String key) async {
    await Future.delayed(
      const Duration(milliseconds: 200),
    ); // Simulate database operation
    return 'Database data for $key';
  }

  @override
  Future<void> delete(String key) async {
    await Future.delayed(
      const Duration(milliseconds: 200),
    ); // Simulate database operation
  }

  @override
  Future<List<String>> getAllKeys() async {
    await Future.delayed(
      const Duration(milliseconds: 200),
    ); // Simulate database operation
    return ['db_key_1', 'db_key_2', 'db_key_3'];
  }
}

//  DATA MANAGER - High-level module that depends on abstraction
class DataManager {
  final DataStorage _storage;

  DataManager(this._storage); // Dependency injection through constructor

  // High-level operations that depend on abstraction
  Future<void> saveUserData(String userId, String userData) async {
    await _storage.save('user_$userId', userData);
  }

  Future<String?> getUserData(String userId) async {
    return await _storage.get('user_$userId');
  }

  Future<void> deleteUserData(String userId) async {
    await _storage.delete('user_$userId');
  }

  Future<List<String>> getAllUserIds() async {
    final keys = await _storage.getAllKeys();
    return keys.where((key) => key.startsWith('user_')).toList();
  }

  // Business logic that works with any storage implementation
  Future<void> backupData() async {
    final keys = await _storage.getAllKeys();
  }
}

//  STORAGE FACTORY - Creates storage instances
class StorageFactory {
  static DataStorage createStorage(String type) {
    switch (type) {
      case 'local':
        return LocalStorage();
      case 'cloud':
        return CloudStorage();
      case 'database':
        return DatabaseStorage();
      default:
        return LocalStorage(); // Default to local storage
    }
  }
}

//  DATA CONTROLLER - GetX controller for UI
class DataController extends GetxController {
  // This class has ONE responsibility: manage data UI state
  DataManager? _dataManager;
  final RxString selectedStorageType = 'local'.obs;
  final RxBool isProcessing = false.obs;
  final RxList<String> dataHistory = <String>[].obs;

  // Form controllers for data input
  final userIdController = TextEditingController();
  final userDataController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _initializeStorage();
  }

  // Initialize storage based on selected type
  void _initializeStorage() {
    final storage = StorageFactory.createStorage(selectedStorageType.value);
    _dataManager = DataManager(storage);
  }

  // Select storage type
  void selectStorageType(String type) {
    selectedStorageType.value = type;
    _initializeStorage();
    _addToHistory('Switched to ${type.toUpperCase()} storage');
  }

  // Save user data
  Future<void> saveUserData() async {
    try {
      final userId = userIdController.text.trim();
      final userData = userDataController.text.trim();

      if (userId.isEmpty || userData.isEmpty) {
        _showError('Please enter user ID and data');
        return;
      }

      isProcessing.value = true;
      await _dataManager!.saveUserData(userId, userData);
      _addToHistory(
        '${selectedStorageType.value.toUpperCase()}: user_$userId = $userData',
      );
      _clearForm();
      _showSuccess('User data saved successfully!');
    } catch (e) {
      _showError('Error saving data: ${e.toString()}');
    } finally {
      isProcessing.value = false;
    }
  }

  // Get user data
  Future<void> getUserData() async {
    try {
      final userId = userIdController.text.trim();

      if (userId.isEmpty) {
        _showError('Please enter user ID');
        return;
      }

      isProcessing.value = true;
      final userData = await _dataManager!.getUserData(userId);

      if (userData != null) {
        userDataController.text = userData;
        _addToHistory(
          '${selectedStorageType.value.toUpperCase()}: Retrieved user_$userId',
        );
        _showSuccess('User data retrieved successfully!');
      } else {
        _showError('User data not found');
      }
    } catch (e) {
      _showError('Error retrieving data: ${e.toString()}');
    } finally {
      isProcessing.value = false;
    }
  }

  // Delete user data
  Future<void> deleteUserData() async {
    try {
      final userId = userIdController.text.trim();

      if (userId.isEmpty) {
        _showError('Please enter user ID');
        return;
      }

      isProcessing.value = true;
      await _dataManager!.deleteUserData(userId);
      _addToHistory(
        '${selectedStorageType.value.toUpperCase()}: Deleted user_$userId',
      );
      _clearForm();
      _showSuccess('User data deleted successfully!');
    } catch (e) {
      _showError('Error deleting data: ${e.toString()}');
    } finally {
      isProcessing.value = false;
    }
  }

  // Backup data
  Future<void> backupData() async {
    try {
      isProcessing.value = true;
      await _dataManager!.backupData();
      _addToHistory(
        '${selectedStorageType.value.toUpperCase()}: Data backed up',
      );
      _showSuccess('Data backup completed!');
    } catch (e) {
      _showError('Error backing up data: ${e.toString()}');
    } finally {
      isProcessing.value = false;
    }
  }

  // Clear form
  void _clearForm() {
    userIdController.clear();
    userDataController.clear();
  }

  // Add to history
  void _addToHistory(String message) {
    dataHistory.insert(0, message);
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

// DATA CARD - Widget for displaying data operations
class DataCard extends StatelessWidget {
  final String operation;
  final int index;

  const DataCard({super.key, required this.operation, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Operation content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    operation,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getTimeAgo(),
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

  String _getTimeAgo() {
    final minutes = index * 2; // Simulate time difference
    if (minutes < 60) return '${minutes}m ago';
    final hours = minutes ~/ 60;
    return '${hours}h ago';
  }
}
