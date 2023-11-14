/// This file contains the [GridGraph] widget and [_GridPainter] custom painter class.
/// The [GridGraph] widget is a stateless widget that plots a grid and points on a canvas.
/// The [_GridPainter] custom painter class is used to draw the grid and points on the canvas.
/// The [_GridPainter] class extends the [CustomPainter] class and overrides the [paint] and [shouldRepaint] methods.
/// The [paint] method is responsible for drawing the grid and points on the canvas.
/// The [shouldRepaint] method is responsible for determining whether the canvas should be repainted.
import 'package:flutter/material.dart';

class GridGraph extends StatelessWidget {
  // Points to be plotted on the graph.
  final List<List<double>> points;
  const GridGraph({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          // Margin around the container.
          margin: const EdgeInsets.all(50.0),
          // CustomPaint widget used for drawing custom designs.
          color: Color.fromRGBO(22, 72, 99, 1),
          child: CustomPaint(
            // Setting size of the CustomPaint based on parent constraints.
            size: Size(constraints.maxWidth, constraints.maxHeight),
            // Custom painter class for drawing the grid and points.
            painter: _GridPainter(points: points),
          ),
        );
      },
    );
  }
}

class _GridPainter extends CustomPainter {
  final List<List<double>> points;

  _GridPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint     = Paint()
      ..color       = Color.fromRGBO(66, 125, 157, 1)
      ..strokeWidth = 0.5;

    final stepX = size.width / 100;
    final stepY = size.height / 100;

    for (double i = 0; i <= 100; i += 1) {
      // Draw horizontal grid lines
      canvas.drawLine(Offset(0, size.height - i * stepY), Offset(size.width, size.height - i * stepY), paint);
      // Draw vertical grid lines
      canvas.drawLine(Offset(i * stepX, 0), Offset(i * stepX, size.height), paint);
    }

    final blackPaint  = Paint()
      ..color         = Color.fromRGBO(66, 125, 157, 1)
      ..strokeWidth   = 1.0;

    for (double i = 0; i <= 100; i += 10) {
      // Draw horizontal grid lines
      canvas.drawLine(Offset(0, size.height - i * stepY), Offset(size.width, size.height - i * stepY), blackPaint);
      // Draw vertical grid lines
      canvas.drawLine(Offset(i * stepX, 0), Offset(i * stepX, size.height), blackPaint);
    }

    final redPaint =   Paint()
      ..color       = Color.fromRGBO(155, 190, 200, 1)
      ..strokeWidth = 2.0
      ..style       = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(points[0][0] * stepX, size.height - points[0][1] * stepY);

    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i][0] * stepX, size.height - points[i][1] * stepY);
    }

    path.close();
    canvas.drawPath(path, redPaint);

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (var point in points) {
      // Create a TextSpan with larger font size, different text and background color.
      textPainter.text = TextSpan(
        text: '(${point[0]},${point[1]})',
        style: TextStyle(
          color: Color.fromRGBO(22, 72, 99, 1), // Change text color here
          fontSize: 12.0, // Increase font size
          backgroundColor: Color.fromRGBO(221, 242, 253, 1), // Change background color here
        ),
      );

      // Layout the textPainter to get the size of the text.
      textPainter.layout();

      // Calculate the position for the text.
      Offset textPosition = Offset(point[0] * stepX - 10, size.height - point[1] * stepY - textPainter.height - 10);

      // Calculate the rectangle bounds for the background.
      Rect backgroundRect = Rect.fromLTWH(
        textPosition.dx - 5, // Left padding
        textPosition.dy - 5, // Top padding
        textPainter.width + 10, // Right padding
        textPainter.height + 10, // Bottom padding
      );

      // Define the corner radius for the rounded rectangle.
      const double cornerRadius = 8.0;

      // Draw the rounded background rectangle.
      canvas.drawRRect(
        RRect.fromRectXY(backgroundRect, cornerRadius, cornerRadius),
        Paint()..color = Color.fromRGBO(221, 242, 253, 1),
      );

      // Draw the text.
      textPainter.paint(canvas, textPosition);
    }

    final axisTextPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

// Draw labels for horizontal axis steps
for (double i = 0; i <= 100; i += 10) {
  axisTextPainter.text = TextSpan(
    text: i.toString(),
    style: const TextStyle(color: Colors.black, fontSize: 12.0),
  );

  axisTextPainter.layout();
  axisTextPainter.paint(canvas, Offset(i * stepX, size.height - axisTextPainter.height + 20));
}

// Draw labels for vertical axis steps
for (double i = 0; i <= 100; i += 10) {
  axisTextPainter.text = TextSpan(
    text: i.toString(),
    style: const TextStyle(color: Colors.black, fontSize: 12.0),
  );

  axisTextPainter.layout();
  axisTextPainter.paint(canvas, Offset(-20, size.height - i * stepY - axisTextPainter.height));
}
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}