import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 3. LISKOV SUBSTITUTION PRINCIPLE (LSP) EXAMPLE
// Objects of a superclass should be replaceable with objects of its subclasses
// without breaking the application. This example shows a shape hierarchy
// where any shape can be substituted for another without issues.
// Subclasses must be substitutable for their parent class without breaking behavior.
// A child class should not remove functionality or throw exceptions where parent works.
// If S is a subtype of T, then objects of type T may be replaced with objects of type S.

// SHAPE INTERFACE - Base contract for all shapes
abstract class Shape {
  String get name;
  String get description;
  double get area;
  double get perimeter;
  Color get color;

  // This method must be implemented by all shapes
  Widget buildWidget();

  // Common behavior that all shapes should have
  String getInfo() {
    return '$name: Area = ${area.toStringAsFixed(2)}, Perimeter = ${perimeter.toStringAsFixed(2)}';
  }
}

//  RECTANGLE - Concrete implementation
class Rectangle implements Shape {
  final double width;
  final double height;
  @override
  final Color color;

  Rectangle({
    required this.width,
    required this.height,
    this.color = Colors.blue,
  });

  @override
  String get name => 'Rectangle';

  @override
  String get description => 'A rectangle with width $width and height $height';

  @override
  double get area => width * height;

  @override
  double get perimeter => 2 * (width + height);

  @override
  Widget buildWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: const Center(
        child: Text(
          'Rectangle',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  String getInfo() {
    return '$name: Area = ${area.toStringAsFixed(2)}, Perimeter = ${perimeter.toStringAsFixed(2)}';
  }
}

// CIRCLE - Concrete implementation
class Circle implements Shape {
  final double radius;
  @override
  final Color color;

  Circle({required this.radius, this.color = Colors.red});

  @override
  String get name => 'Circle';

  @override
  String get description => 'A circle with radius $radius';

  @override
  double get area => 3.14159 * radius * radius;

  @override
  double get perimeter => 2 * 3.14159 * radius;

  @override
  Widget buildWidget() {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: const Center(
        child: Text(
          'Circle',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  String getInfo() {
    return '$name: Area = ${area.toStringAsFixed(2)}, Perimeter = ${perimeter.toStringAsFixed(2)}';
  }
}

// TRIANGLE - Concrete implementation
class Triangle implements Shape {
  final double base;
  final double height;
  @override
  final Color color;

  Triangle({
    required this.base,
    required this.height,
    this.color = Colors.green,
  });

  @override
  String get name => 'Triangle';

  @override
  String get description => 'A triangle with base $base and height $height';

  @override
  double get area => 0.5 * base * height;

  @override
  double get perimeter {
    // For simplicity, assuming equilateral triangle
    return 3 * base;
  }

  @override
  Widget buildWidget() {
    return CustomPaint(
      size: Size(base, height),
      painter: TrianglePainter(color: color),
    );
  }

  @override
  String getInfo() {
    return '$name: Area = ${area.toStringAsFixed(2)}, Perimeter = ${perimeter.toStringAsFixed(2)}';
  }
}

// TRIANGLE PAINTER - Custom painter for triangle
class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, 0); // Top point
    path.lineTo(0, size.height); // Bottom left
    path.lineTo(size.width, size.height); // Bottom right
    path.close();

    canvas.drawPath(path, paint);

    // Draw border
    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path, borderPaint);

    // Draw text
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Triangle',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// SHAPE CALCULATOR - Service that works with any shape
class ShapeCalculator {
  // This class demonstrates LSP - it can work with ANY shape
  // without knowing the specific type

  // Calculate total area of multiple shapes
  double calculateTotalArea(List<Shape> shapes) {
    return shapes.fold(0.0, (sum, shape) => sum + shape.area);
  }

  // Calculate total perimeter of multiple shapes
  double calculateTotalPerimeter(List<Shape> shapes) {
    return shapes.fold(0.0, (sum, shape) => sum + shape.perimeter);
  }

  // Find the largest shape by area
  Shape? findLargestShape(List<Shape> shapes) {
    if (shapes.isEmpty) return null;

    return shapes.reduce(
      (current, next) => current.area > next.area ? current : next,
    );
  }

  // Find the smallest shape by area
  Shape? findSmallestShape(List<Shape> shapes) {
    if (shapes.isEmpty) return null;

    return shapes.reduce(
      (current, next) => current.area < next.area ? current : next,
    );
  }

  // Get shapes sorted by area (ascending)
  List<Shape> getShapesSortedByArea(List<Shape> shapes) {
    final sortedShapes = List<Shape>.from(shapes);
    sortedShapes.sort((a, b) => a.area.compareTo(b.area));
    return sortedShapes;
  }

  // Get shapes sorted by perimeter (descending)
  List<Shape> getShapesSortedByPerimeter(List<Shape> shapes) {
    final sortedShapes = List<Shape>.from(shapes);
    sortedShapes.sort((a, b) => b.perimeter.compareTo(a.perimeter));
    return sortedShapes;
  }
}

// SHAPE CONTROLLER - GetX controller for UI
class ShapeController extends GetxController {
  // This class has ONE responsibility: manage shape UI state
  final ShapeCalculator _calculator = ShapeCalculator();

  // Observable variables for reactive UI
  final RxList<Shape> shapes = <Shape>[].obs;
  final Rx<Shape?> selectedShape = Rx<Shape?>(null);
  final RxBool isCalculating = false.obs;

  // Form controllers for shape creation
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  final radiusController = TextEditingController();
  final baseController = TextEditingController();

  // Shape type selection
  final RxString selectedShapeType = 'rectangle'.obs;

  @override
  void onInit() {
    super.onInit();
    // Add some default shapes to demonstrate
    _addDefaultShapes();
  }

  // Add default shapes for demonstration
  void _addDefaultShapes() {
    shapes.addAll([
      Rectangle(width: 100, height: 80, color: Colors.blue),
      Circle(radius: 50, color: Colors.red),
      Triangle(base: 80, height: 60, color: Colors.green),
    ]);
  }

  // Select shape type
  void selectShapeType(String type) {
    selectedShapeType.value = type;
  }

  // Create new shape based on selected type
  void createShape() {
    try {
      Shape newShape;

      switch (selectedShapeType.value) {
        case 'rectangle':
          final width = double.tryParse(widthController.text) ?? 0;
          final height = double.tryParse(heightController.text) ?? 0;
          if (width <= 0 || height <= 0) {
            _showError('Please enter valid width and height');
            return;
          }
          newShape = Rectangle(width: width, height: height);
          break;

        case 'circle':
          final radius = double.tryParse(radiusController.text) ?? 0;
          if (radius <= 0) {
            _showError('Please enter valid radius');
            return;
          }
          newShape = Circle(radius: radius);
          break;

        case 'triangle':
          final base = double.tryParse(baseController.text) ?? 0;
          final height = double.tryParse(heightController.text) ?? 0;
          if (base <= 0 || height <= 0) {
            _showError('Please enter valid base and height');
            return;
          }
          newShape = Triangle(base: base, height: height);
          break;

        default:
          _showError('Please select a shape type');
          return;
      }

      shapes.add(newShape);
      _clearForm();
      _showSuccess('${newShape.name} created successfully!');
    } catch (e) {
      _showError('Error creating shape: ${e.toString()}');
    }
  }

  // Select a shape
  void selectShape(Shape shape) {
    selectedShape.value = shape;
  }

  // Remove selected shape
  void removeSelectedShape() {
    if (selectedShape.value != null) {
      shapes.remove(selectedShape.value);
      selectedShape.value = null;
      _showSuccess('Shape removed successfully!');
    }
  }

  // Calculate statistics
  void calculateStatistics() {
    isCalculating.value = true;

    // Simulate calculation delay
    Future.delayed(const Duration(milliseconds: 500), () {
      isCalculating.value = false;
      _showSuccess('Statistics calculated!');
    });
  }

  // Clear form
  void _clearForm() {
    widthController.clear();
    heightController.clear();
    radiusController.clear();
    baseController.clear();
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

  // Get calculated statistics
  double get totalArea => _calculator.calculateTotalArea(shapes);
  double get totalPerimeter => _calculator.calculateTotalPerimeter(shapes);
  Shape? get largestShape => _calculator.findLargestShape(shapes);
  Shape? get smallestShape => _calculator.findSmallestShape(shapes);
  List<Shape> get shapesByArea => _calculator.getShapesSortedByArea(shapes);
  List<Shape> get shapesByPerimeter =>
      _calculator.getShapesSortedByPerimeter(shapes);
}

// SHAPE CARD - Widget for displaying shapes
class ShapeCard extends StatelessWidget {
  final Shape shape;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const ShapeCard({
    super.key,
    required this.shape,
    required this.isSelected,
    required this.onTap,
    required this.onRemove,
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
          child: Column(
            children: [
              // Shape visualization
              SizedBox(
                width: 100,
                height: 100,
                child: Center(child: shape.buildWidget()),
              ),
              const SizedBox(height: 8),

              // Shape info
              Text(
                shape.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.blue : Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                shape.description,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Shape statistics
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  children: [
                    Text(
                      'Area: ${shape.area.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Perimeter: ${shape.perimeter.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),

              // Remove button
              if (isSelected)
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Remove shape',
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// STATISTICS CARD - Widget for displaying statistics
class StatisticsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatisticsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
