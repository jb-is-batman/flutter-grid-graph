import 'package:flutter_grid_graph/models/coordinate_model.dart';

class GraphService {

  	final List<CoordinateModel> _coordinates = [
		CoordinateModel(x: 20, y: 20),
		CoordinateModel(x: 30, y: 30),
		CoordinateModel(x: 40, y: 40),
		CoordinateModel(x: 50, y: 50),
	]; 

	Future<List<CoordinateModel>>  getCoordinates() async
	{
		// await Future.delayed(const Duration(milliseconds: 500));
		return _coordinates;
	}

	addCoordinate(double x, double y, String? label) {
		_coordinates.add(CoordinateModel(x: x, y: y, label: label));
	}
}