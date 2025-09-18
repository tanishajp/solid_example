import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../examples/open_closed_principle_example.dart';
import '../utils/controller_finder.dart';

// 2. OCP PAGE - Open/Closed Principle
// This page demonstrates the Open/Closed Principle
// The payment system can be extended with new payment methods
// without modifying existing code

class OpenClosedPrinciplePage extends StatelessWidget {
  const OpenClosedPrinciplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2. Open/Closed Principle (OCP)'),
        backgroundColor: Colors.green,
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
            // Amount input section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Payment Amount',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller:
                          ControllerFinder.paymentController.amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Enter amount',
                        prefixText: '\$',
                        border: OutlineInputBorder(),
                      ),
                      onChanged:
                          ControllerFinder.paymentController.updateAmount,
                    ),
                    const SizedBox(height: 16),
                    Obx(() {
                      final controller = ControllerFinder.paymentController;
                      final totalCost = controller.getTotalCost();
                      if (totalCost > 0) {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Cost (including fee):',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '\$${totalCost.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Payment methods section
            Expanded(
              child: Column(
                children: [
                  const Text(
                    'Select Payment Method',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Obx(() {
                      final controller = ControllerFinder.paymentController;
                      return ListView.builder(
                        itemCount: controller.availableMethods.length,
                        itemBuilder: (context, index) {
                          final method = controller.availableMethods[index];
                          final isSelected =
                              controller.selectedMethod.value == method;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: PaymentMethodCard(
                              method: method,
                              isSelected: isSelected,
                              onTap: () =>
                                  controller.selectPaymentMethod(method),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 16),

                  // Process payment button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Obx(() {
                      final controller = ControllerFinder.paymentController;
                      return ElevatedButton(
                        onPressed: controller.isProcessing.value
                            ? null
                            : controller.processPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
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
                                'Process Payment',
                                style: TextStyle(fontSize: 16),
                              ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // Payment history section
            Obx(() {
              final controller = ControllerFinder.paymentController;
              if (controller.paymentHistory.isNotEmpty) {
                return Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        'Payment History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.paymentHistory.length,
                          itemBuilder: (context, index) {
                            return PaymentResultCard(
                              result: controller.paymentHistory[index],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
