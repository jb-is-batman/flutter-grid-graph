import 'package:flutter_grid_graph/app/baseview/baseview_model.dart';
import 'package:flutter_grid_graph/models/coordinate_model.dart';

class GridViewModel extends BaseViewModel {
  	final List<CoordinateModel> _coordinates = [
		CoordinateModel(x: 20, y: 20),
		CoordinateModel(x: 30, y: 30),
		CoordinateModel(x: 40, y: 40),
		CoordinateModel(x: 50, y: 50),

	]; 

  	List<CoordinateModel> get coordinates => _coordinates;

	addCoordinate(x, y) {
		_coordinates.add(CoordinateModel(x: x, y: y));
		notifyListeners();
	}
}