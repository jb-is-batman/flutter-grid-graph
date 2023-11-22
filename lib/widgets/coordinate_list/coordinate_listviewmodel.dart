import 'package:flutter_grid_graph/core/baseview/baseview_model.dart';
import 'package:flutter_grid_graph/core/locator.dart';
import 'package:flutter_grid_graph/models/coordinate_model.dart';
import 'package:flutter_grid_graph/services/graph_service.dart';

class CoordinateListViewModel extends BaseViewModel {

	final GraphService	_coordinateService	= locator<GraphService>();
	List<bool> 			_isEditingList 		= [];

	List<bool> get isEditingList => _isEditingList;
	
	void toggleEdit(int index) {
		_isEditingList[index] = !_isEditingList[index];
		notifyListeners();
	}

	void disableAllEdit() {
		_isEditingList = List.generate(_coordinates.length, (index) => false);
		notifyListeners();
	}

	void saveUpdatedCoordinate(double x, double y, String? label, int index) {
		_coordinateService.updateCoordinate(index, x, y, label);
	}

  	CoordinateListViewModel() {
    	_coordinateService.addListener(_onCoordinateServiceUpdated);
  	}

	List<CoordinateModel> 	_coordinates = [];
  	List<CoordinateModel> 	get coordinates => _coordinates; 

	void _onCoordinateServiceUpdated() async {
		_coordinates 	= await _coordinateService.getCoordinates();
		_isEditingList	= List.generate(_coordinates.length, (index) => false);
		notifyListeners();
	}

	Future<void> getCoordinates() async {
		setState(ViewState.busy);
		_coordinates 	= await _coordinateService.getCoordinates();
		_isEditingList 	= List.generate(_coordinates.length, (index) => false);
		setState(ViewState.idle);
	}
	
	void reorder(int oldIndex, int newIndex) {
		_coordinateService.reorder(oldIndex, newIndex);
	}

	void deleteCoordinate(int index) {
		_coordinateService.deleteCoordinate(index);
		_isEditingList.removeAt(index);
		notifyListeners();
	}

	@override
	void dispose() {
		_coordinateService.removeListener(_onCoordinateServiceUpdated);
		super.dispose();
	}
}