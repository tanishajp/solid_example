import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../examples/liskov_substitution_principle_example.dart';
import '../utils/controller_finder.dart';

// 3. LSP PAGE - Liskov Substitution Principle
// This page demonstrates the Liskov Substitution Principle
// Any shape can be substituted for another without breaking the application

class LiskovSubstitutionPrinciplePage extends StatelessWidget {
  const LiskovSubstitutionPrinciplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('3. Liskov Substitution Principle (LSP)'),
        backgroundColor: Colors.purple,
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
            // Shape creation section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Create New Shape',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Shape type selection
                    Obx(() {
                      final controller = ControllerFinder.shapeController;
                      return Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Rectangle'),
                              value: 'rectangle',
                              groupValue: controller.selectedShapeType.value,
                              onChanged: (value) =>
                                  controller.selectShapeType(value!),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Circle'),
                              value: 'circle',
                              groupValue: controller.selectedShapeType.value,
                              onChanged: (value) =>
                                  controller.selectShapeType(value!),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Triangle'),
                              value: 'triangle',
                              groupValue: controller.selectedShapeType.value,
                              onChanged: (value) =>
                                  controller.selectShapeType(value!),
                            ),
                          ),
                        ],
                      );
                    }),

                    const SizedBox(height: 16),

                    // Input fields based on selected shape type
                    Obx(() {
                      final controller = ControllerFinder.shapeController;
                      final shapeType = controller.selectedShapeType.value;

                      if (shapeType == 'rectangle') {
                        return Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller.widthController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Width',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: controller.heightController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Height',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else if (shapeType == 'circle') {
                        return TextField(
                          controller: controller.radiusController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Radius',
                            border: OutlineInputBorder(),
                          ),
                        );
                      } else if (shapeType == 'triangle') {
                        return Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller.baseController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Base',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: controller.heightController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Height',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),

                    const SizedBox(height: 16),

                    // Create shape button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            ControllerFinder.shapeController.createShape(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Create Shape'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Statistics section
            Obx(() {
              final controller = ControllerFinder.shapeController;
              if (controller.shapes.isNotEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'Shape Statistics',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: StatisticsCard(
                                title: 'Total Area',
                                value: controller.totalArea.toStringAsFixed(2),
                                icon: Icons.area_chart,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: StatisticsCard(
                                title: 'Total Perimeter',
                                value: controller.totalPerimeter
                                    .toStringAsFixed(2),
                                icon: Icons.straighten,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: StatisticsCard(
                                title: 'Largest Shape',
                                value: controller.largestShape?.name ?? 'None',
                                icon: Icons.zoom_in,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: StatisticsCard(
                                title: 'Smallest Shape',
                                value: controller.smallestShape?.name ?? 'None',
                                icon: Icons.zoom_out,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: controller.calculateStatistics,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            child: Obx(() {
                              return controller.isCalculating.value
                                  ? const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                        Text('Calculating...'),
                                      ],
                                    )
                                  : const Text('Recalculate Statistics');
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            const SizedBox(height: 16),

            // Shapes list section
            Expanded(
              child: Column(
                children: [
                  const Text(
                    'Shapes (Click to select)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Obx(() {
                      final controller = ControllerFinder.shapeController;
                      if (controller.shapes.isEmpty) {
                        return const Center(
                          child: Text('No shapes created yet'),
                        );
                      }
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.8,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                        itemCount: controller.shapes.length,
                        itemBuilder: (context, index) {
                          final shape = controller.shapes[index];
                          final isSelected =
                              controller.selectedShape.value == shape;

                          return ShapeCard(
                            shape: shape,
                            isSelected: isSelected,
                            onTap: () => controller.selectShape(shape),
                            onRemove: controller.removeSelectedShape,
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
