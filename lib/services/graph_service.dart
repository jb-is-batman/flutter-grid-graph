import 'package:flutter/foundation.dart';
import 'package:flutter_grid_graph/models/coordinate_model.dart';
import 'package:flutter_grid_graph/models/grid_model.dart';

class GraphService extends ChangeNotifier{

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
		CoordinateModel(x: 100, y: 7000),
		CoordinateModel(x: 140, y: 9500),
	]; 

	Future<List<CoordinateModel>>  getCoordinates() async {
		return _coordinates;
	}

	void addCoordinate(double x, double y, String? label) {
		_coordinates.add(CoordinateModel(x: x, y: y, label: label));
		notifyListeners();
	}

  void deleteCoordinate(int index) {
    _coordinates.removeAt(index);
    notifyListeners();
  }

  void updateCoordinate(int index, double x, double y, String? label) {
    _coordinates[index] = CoordinateModel(x: x, y: y, label: label);
    notifyListeners();
  }

  void reorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final CoordinateModel item = _coordinates.removeAt(oldIndex);
    _coordinates.insert(newIndex, item);
    notifyListeners();
  }
}