import 'package:flutter_grid_graph/core/baseview/baseview_model.dart';
import 'package:flutter_grid_graph/core/locator.dart';
import 'package:flutter_grid_graph/models/coordinate_model.dart';
import 'package:flutter_grid_graph/models/grid_model.dart';
import 'package:flutter_grid_graph/services/graph_service.dart';

class GridViewModel extends BaseViewModel {

	final GraphService _coordinateService = locator<GraphService>();

	List<CoordinateModel> _coordinates = [];
  	List<CoordinateModel> get coordinates => _coordinates; 
	GridModel				get gridModel => _coordinateService.getGridModel();

	Future<void> getCoordinates() async {
		setState(ViewState.busy);
		_coordinates = await _coordinateService.getCoordinates();
		setState(ViewState.idle);
	}

	addCoordinate(x, y) {
		_coordinateService.addCoordinate(x, y, null);
		notifyListeners();
	}
}