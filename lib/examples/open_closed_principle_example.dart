import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 2. OPEN/CLOSED PRINCIPLE (OCP) EXAMPLE
// Software entities should be open for extension but closed for modification
// This example shows a payment processing system that can be extended
// with new payment methods without modifying existing code
// Classes should be open for extension, but closed for modification.
// You should be able to add new behavior without changing existing code.

// PAYMENT INTERFACE - Abstract base for all payment methods
abstract class PaymentMethod {
  String get name;
  String get description;
  double get processingFee;

  // This method must be implemented by all payment methods
  Future<PaymentResult> processPayment(double amount);
}

// PAYMENT RESULT - Data class for payment results
class PaymentResult {
  final bool success;
  final String message;
  final String transactionId;
  final double fee;

  PaymentResult({
    required this.success,
    required this.message,
    required this.transactionId,
    required this.fee,
  });
}

// CREDIT CARD PAYMENT - Concrete implementation
class CreditCardPayment implements PaymentMethod {
  @override
  String get name => 'Credit Card';

  @override
  String get description => 'Pay with Visa, MasterCard, or American Express';

  @override
  double get processingFee => 0.029; // 2.9% fee

  @override
  Future<PaymentResult> processPayment(double amount) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulate processing logic
    final fee = amount * processingFee;
    final transactionId = 'CC_${DateTime.now().millisecondsSinceEpoch}';

    return PaymentResult(
      success: true,
      message: 'Credit card payment processed successfully',
      transactionId: transactionId,
      fee: fee,
    );
  }
}

// PAYPAL PAYMENT - Concrete implementation
class PayPalPayment implements PaymentMethod {
  @override
  String get name => 'PayPal';

  @override
  String get description => 'Pay securely with your PayPal account';

  @override
  double get processingFee => 0.034; // 3.4% fee

  @override
  Future<PaymentResult> processPayment(double amount) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulate processing logic
    final fee = amount * processingFee;
    final transactionId = 'PP_${DateTime.now().millisecondsSinceEpoch}';

    return PaymentResult(
      success: true,
      message: 'PayPal payment processed successfully',
      transactionId: transactionId,
      fee: fee,
    );
  }
}

// BANK TRANSFER PAYMENT - Concrete implementation
class BankTransferPayment implements PaymentMethod {
  @override
  String get name => 'Bank Transfer';

  @override
  String get description => 'Direct bank transfer (ACH)';

  @override
  double get processingFee => 0.008; // 0.8% fee

  @override
  Future<PaymentResult> processPayment(double amount) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate processing logic
    final fee = amount * processingFee;
    final transactionId = 'BT_${DateTime.now().millisecondsSinceEpoch}';

    return PaymentResult(
      success: true,
      message: 'Bank transfer initiated successfully',
      transactionId: transactionId,
      fee: fee,
    );
  }
}

// CRYPTOCURRENCY PAYMENT - NEW payment method (extension without modification)
class CryptocurrencyPayment implements PaymentMethod {
  @override
  String get name => 'Cryptocurrency';

  @override
  String get description => 'Pay with Bitcoin, Ethereum, or other crypto';

  @override
  double get processingFee => 0.015; // 1.5% fee

  @override
  Future<PaymentResult> processPayment(double amount) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 3));

    // Simulate processing logic
    final fee = amount * processingFee;
    final transactionId = 'CRYPTO_${DateTime.now().millisecondsSinceEpoch}';

    return PaymentResult(
      success: true,
      message: 'Cryptocurrency payment processed successfully',
      transactionId: transactionId,
      fee: fee,
    );
  }
}

// PAYMENT PROCESSOR - Core class that doesn't need modification -main class
class PaymentProcessor {
  // This class is CLOSED for modification but OPEN for extension
  // We can add new payment methods without changing this class

  final List<PaymentMethod> _availableMethods = [
    CreditCardPayment(),
    PayPalPayment(),
    BankTransferPayment(),
    CryptocurrencyPayment(), // New method added without modifying existing code
  ];

  // Get all available payment methods
  List<PaymentMethod> get availableMethods => List.from(_availableMethods);

  // Process payment using any payment method
  Future<PaymentResult> processPayment({
    required PaymentMethod method,
    required double amount,
  }) async {
    try {
      // The processor doesn't need to know about specific payment types
      // It just calls the processPayment method on any PaymentMethod
      return await method.processPayment(amount);
    } catch (e) {
      return PaymentResult(
        success: false,
        message: 'Payment failed: ${e.toString()}',
        transactionId: '',
        fee: 0.0,
      );
    }
  }

  // Calculate total cost including fees
  double calculateTotalCost(PaymentMethod method, double amount) {
    return amount + (amount * method.processingFee);
  }
}

// PAYMENT CONTROLLER - GetX controller for UI
class PaymentController extends GetxController {
  // This class has ONE responsibility: manage payment UI state
  final PaymentProcessor _paymentProcessor = PaymentProcessor();

  // Observable variables for reactive UI
  final RxList<PaymentMethod> availableMethods = <PaymentMethod>[].obs;
  final Rx<PaymentMethod?> selectedMethod = Rx<PaymentMethod?>(null);
  final RxDouble amount = 0.0.obs;
  final RxBool isProcessing = false.obs;
  final RxList<PaymentResult> paymentHistory = <PaymentResult>[].obs;

  // Form controller for amount input
  final amountController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadPaymentMethods();
  }

  // Load available payment methods
  void loadPaymentMethods() {
    availableMethods.value = _paymentProcessor.availableMethods;
  }

  // Select payment method
  void selectPaymentMethod(PaymentMethod method) {
    selectedMethod.value = method;
  }

  // Update amount
  void updateAmount(String value) {
    final parsedAmount = double.tryParse(value) ?? 0.0;
    amount.value = parsedAmount;
  }

  // Process payment
  Future<void> processPayment() async {
    if (selectedMethod.value == null) {
      Get.snackbar(
        'Error',
        'Please select a payment method',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (amount.value <= 0) {
      Get.snackbar(
        'Error',
        'Please enter a valid amount',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isProcessing.value = true;

    try {
      final result = await _paymentProcessor.processPayment(
        method: selectedMethod.value!,
        amount: amount.value,
      );

      paymentHistory.insert(0, result);

      if (result.success) {
        Get.snackbar(
          'Success',
          result.message,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Clear form
        amountController.clear();
        amount.value = 0.0;
        selectedMethod.value = null;
      } else {
        Get.snackbar(
          'Payment Failed',
          result.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isProcessing.value = false;
    }
  }

  // Calculate total cost
  double getTotalCost() {
    if (selectedMethod.value == null || amount.value <= 0) return 0.0;
    return _paymentProcessor.calculateTotalCost(
      selectedMethod.value!,
      amount.value,
    );
  }
}

// PAYMENT METHOD CARD - Widget for displaying payment methods
class PaymentMethodCard extends StatelessWidget {
  final PaymentMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected ? Colors.blue.shade50 : Colors.white,
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
                  color: isSelected ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.blue : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      method.description,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Fee: ${(method.processingFee * 100).toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: Colors.blue, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// PAYMENT RESULT CARD - Widget for displaying payment results
class PaymentResultCard extends StatelessWidget {
  final PaymentResult result;

  const PaymentResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: result.success ? Colors.green.shade50 : Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  result.success ? Icons.check_circle : Icons.error,
                  color: result.success ? Colors.green : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  result.success ? 'Payment Successful' : 'Payment Failed',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: result.success ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(result.message, style: const TextStyle(fontSize: 14)),
            if (result.success) ...[
              const SizedBox(height: 4),
              Text(
                'Transaction ID: ${result.transactionId}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                'Fee: \$${result.fee.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
