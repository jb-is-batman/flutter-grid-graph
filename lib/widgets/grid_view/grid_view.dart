import 'package:flutter/material.dart';
import 'package:flutter_grid_graph/core/baseview/baseview.dart';
import 'package:flutter_grid_graph/core/baseview/baseview_model.dart';
import 'package:flutter_grid_graph/models/coordinate_model.dart';
import 'package:flutter_grid_graph/widgets/grid_view/grid_viewmodel.dart';

class GridGraph extends StatelessWidget {
	const GridGraph({super.key});
	@override
	Widget build(BuildContext context) {
		return BaseView<GridViewModel>(
			onModelReady: (GridViewModel model) => model.getCoordinates(),
			builder: (context, model, child) {
				return LayoutBuilder(
					builder: (BuildContext context, BoxConstraints constraints) {
						return GestureDetector(
							onTapDown: (TapDownDetails details) {
								_onCanvasTap(context, details, constraints, model);
							},
							child: Container(
								// Margin around the container.
								// margin: const EdgeInsets.all(50.0),
								// CustomPaint widget used for drawing custom designs.
								color: const Color.fromRGBO(22, 72, 99, 1),
								child: CustomPaint(	
								// Setting size of the CustomPaint based on parent constraints.
									size: Size(constraints.maxWidth, constraints.maxHeight),
									// Custom painter class for drawing the grid and points.
									painter: _GridPainter(gridViewModel: model),
								),
							),
						);
					},
				);
			}
		);
	}

	void _onCanvasTap(BuildContext context, TapDownDetails details, BoxConstraints constraints, GridViewModel model) {
		final RenderBox renderBox 		= context.findRenderObject() as RenderBox;
		final Offset 	localPosition	= renderBox.globalToLocal(details.globalPosition);
		final Size 		size 			= Size(constraints.maxWidth, constraints.maxHeight);

		final double 	stepX 			= size.width / (model.gridModel.xBottom.max - model.gridModel.xBottom.min);
		final double	stepY 			= size.height / (model.gridModel.yLeft.max - model.gridModel.yLeft.min);
		final double 	realX			= model.getRealX(localPosition.dx, stepX);
		final double 	realY 			= model.getRealY(localPosition.dy, stepY, size.height);
		Offset graphCoordinates 		= Offset(realX, realY);
		model.addCoordinate(graphCoordinates.dx, graphCoordinates.dy);
  }
}

class _GridPainter extends CustomPainter {
  final GridViewModel gridViewModel;

  _GridPainter({required this.gridViewModel});

  @override
  void paint(Canvas canvas, Size size) {

	final stepX = gridViewModel.getStepX(width: size.width);
	final stepY = gridViewModel.getStepY(height: size.height);

	final gridLinePaint = Paint()
	..color = const Color.fromRGBO(66, 125, 157, 0.5)
	..strokeWidth = 1.0;

	// Draw horizontal grid lines
	for (double i = gridViewModel.gridModel.yLeft.min; i <= gridViewModel.gridModel.yLeft.max; i += gridViewModel.gridModel.yLeft.step) {
		double yPos = size.height - (i - gridViewModel.gridModel.yLeft.min) * stepY;
		canvas.drawLine(Offset(0, yPos), Offset(size.width, yPos), gridLinePaint);
	}

	// Draw vertical grid lines
	for (double i = gridViewModel.gridModel.xBottom.min; i <= gridViewModel.gridModel.xBottom.max; i += gridViewModel.gridModel.xBottom.step) {
		double xPos = (i - gridViewModel.gridModel.xBottom.min) * stepX;
		canvas.drawLine(Offset(xPos, 0), Offset(xPos, size.height), gridLinePaint);
	}

	if(gridViewModel.state != ViewState.busy) {
		_drawCoordinates(canvas, size, gridViewModel.coordinates, stepX, stepY);
		_drawCoordinateLabels(canvas, size, gridViewModel.coordinates, stepX, stepY);
	}

	_drawAxisLabels(canvas, size, stepX, stepY);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

	// Method to convert real-world values to canvas coordinates
	Offset toCanvasCoordinates(double xValue, double yValue, Size size, double stepX, double stepY) {
		double xPos = gridViewModel.getCanvasX(xValue, stepX);
		double yPos = gridViewModel.getCanvasY(yValue, stepY, size.height);
		return Offset(xPos, yPos);
	}

	// Method to convert canvas coordinates to real-world values
	Offset fromCanvasCoordinates(double xCanvas, double yCanvas, Size size, double stepX, double stepY) {
		double xValue = gridViewModel.getRealX(xCanvas, stepX);
		double yValue = gridViewModel.getRealY(yCanvas, stepY, size.height);
		return Offset(xValue, yValue);
	}

	void _drawCoordinates(Canvas canvas, Size size, List<CoordinateModel> coordinates, double stepX, double stepY) {
		final coordinatePathPaint = Paint()
			..color = const Color.fromRGBO(155, 190, 200, 1)
			..strokeWidth = 1.0
			..style = PaintingStyle.stroke;

		final path = Path();
		Offset firstPoint = toCanvasCoordinates(gridViewModel.coordinates[0].x, gridViewModel.coordinates[0].y, size, stepX, stepY);
		path.moveTo(firstPoint.dx, firstPoint.dy);

		for (var i = 1; i < gridViewModel.coordinates.length; i++) {
			Offset point = toCanvasCoordinates(gridViewModel.coordinates[i].x, gridViewModel.coordinates[i].y, size, stepX, stepY);
			path.lineTo(point.dx, point.dy);
		}

		canvas.drawPath(path, coordinatePathPaint);
	}

	void _drawCoordinateLabels(Canvas canvas, Size size, List<CoordinateModel> coordinates, double stepX, double stepY) {
		final textPainter = TextPainter(
			textDirection: TextDirection.ltr,
		);

		for (var coordinate in coordinates) {
			// Create a TextSpan with larger font size, different text and background color.
			textPainter.text = TextSpan(
				text: '(${coordinate.x.round()},${coordinate.y.round()})',
				style: const TextStyle(
					color: Color.fromRGBO(22, 72, 99, 1),
					fontSize: 12.0,
					backgroundColor: Color.fromRGBO(221, 242, 253, 1),
				),
			);

			// Layout the textPainter to get the size of the text.
			textPainter.layout();

			// Use toCanvasCoordinates to calculate the position for the text.
			Offset canvasPosition = toCanvasCoordinates(coordinate.x, coordinate.y, size, stepX, stepY);
			Offset textPosition = Offset(canvasPosition.dx - 10, canvasPosition.dy - textPainter.height - 10);

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
				Paint()..color = const Color.fromRGBO(221, 242, 253, 1),
			);

			// Draw the text.
			textPainter.paint(canvas, textPosition);
		}
	}

	void _drawAxisLabels(Canvas canvas, Size size, double stepX, double stepY) {
		final axisTextPainter = TextPainter(
			textDirection: TextDirection.ltr,
		);

		// Draw labels for horizontal axis steps
		for (double i = gridViewModel.gridModel.xBottom.min; i <= gridViewModel.gridModel.xBottom.max; i += gridViewModel.gridModel.xBottom.step) {
			axisTextPainter.text = TextSpan(
				text: i.toString(),
				style: const TextStyle(color: Colors.black, fontSize: 12.0),
			);

			axisTextPainter.layout();
			axisTextPainter.paint(canvas, Offset((i - gridViewModel.gridModel.xBottom.min) * stepX - 10, size.height - axisTextPainter.height + 20));
		}

		// Draw labels for vertical axis steps
		for (double i = gridViewModel.gridModel.yLeft.min; i <= gridViewModel.gridModel.yLeft.max; i += gridViewModel.gridModel.yLeft.step) {
			axisTextPainter.text = TextSpan(
				text: i.toString(),
				style: const TextStyle(color: Colors.black, fontSize: 12.0),
			);

			axisTextPainter.layout();
			axisTextPainter.paint(canvas, Offset(-50, size.height - (i - gridViewModel.gridModel.yLeft.min) * stepY - axisTextPainter.height + 7));
		}
	}
}
