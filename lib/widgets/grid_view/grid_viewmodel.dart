import 'package:flutter_grid_graph/core/baseview/baseview_model.dart';
import 'package:flutter_grid_graph/core/locator.dart';
import 'package:flutter_grid_graph/models/coordinate_model.dart';
import 'package:flutter_grid_graph/models/grid_model.dart';
import 'package:flutter_grid_graph/services/graph_service.dart';

class GridViewModel extends BaseViewModel {

	final GraphService _coordinateService = locator<GraphService>();

	List<CoordinateModel> 	_coordinates = [];
  	List<CoordinateModel> 	get coordinates => _coordinates; 
	GridModel				get gridModel 	=> _coordinateService.getGridModel();

	Future<void> getCoordinates() async {
		setState(ViewState.busy);
		_coordinates = await _coordinateService.getCoordinates();
		setState(ViewState.idle);
	}

	addCoordinate(x, y) {
		_coordinateService.addCoordinate(x, y, null);
		notifyListeners();
	}

	// Calculations

	double getStepX({required double width}) {
		return width / (gridModel.xBottom.max - gridModel.xBottom.min);
	}

	double getStepY({required double height}) {
		return height / (gridModel.yLeft.max - gridModel.yLeft.min);
	}

	// Methods to convert real-world values to canvas coordinates
	double getCanvasX(double xValue, double stepX) {
		return (xValue - gridModel.xBottom.min) * stepX;
	}

	double getCanvasY(double yValue, double stepY, double height) {
		return height - (yValue - gridModel.yLeft.min) * stepY;
	}

	// Methods to convert canvas coordinates to real-world values
	double getRealX(double xCanvas, double stepX) {
		return xCanvas / stepX + gridModel.xBottom.min;
	}

	double getRealY(double yCanvas, double stepY, double height) {
		return (height - yCanvas) / stepY + gridModel.yLeft.min;
	}
}