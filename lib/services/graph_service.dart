import 'package:flutter_grid_graph/models/coordinate_model.dart';
import 'package:flutter_grid_graph/models/grid_model.dart';

class GraphService {

	GridModel getGridModel() {
		return GridModel(
			yLeft: AxisModel(min: 1500, max: 10000, step: 500, label: 'Y Left'),
			yRight: AxisModel(min: 0, max: 100, step: 10, label: 'Y Right'),
			xBottom: AxisModel(min: 70, max: 150, step: 10, label: 'X Bottom'),
			xTop: AxisModel(min: 0, max: 100, step: 10, label: 'X Top'),
		);
	}

  	final List<CoordinateModel> _coordinates = [
		CoordinateModel(x: 80, y: 2000),
		CoordinateModel(x: 90, y: 3500),
		CoordinateModel(x: 110, y: 6000),
		CoordinateModel(x: 120, y: 9500),
	]; 

	Future<List<CoordinateModel>>  getCoordinates() async
	{
		return _coordinates;
	}

	addCoordinate(double x, double y, String? label) {
		_coordinates.add(CoordinateModel(x: x, y: y, label: label));
	}
}