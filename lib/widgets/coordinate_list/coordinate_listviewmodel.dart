import 'package:flutter_grid_graph/core/baseview/baseview_model.dart';
import 'package:flutter_grid_graph/core/locator.dart';
import 'package:flutter_grid_graph/models/coordinate_model.dart';
import 'package:flutter_grid_graph/services/graph_service.dart';

class CoordinateListViewModel extends BaseViewModel {

	final GraphService _coordinateService = locator<GraphService>();

  	CoordinateListViewModel() {
    	_coordinateService.addListener(_onCoordinateServiceUpdated);
  	}

	List<CoordinateModel> 	_coordinates = [];
  	List<CoordinateModel> 	get coordinates => _coordinates; 

	void _onCoordinateServiceUpdated() async {
		_coordinates = await _coordinateService.getCoordinates();
		notifyListeners();
	}

	Future<void> getCoordinates() async {
		setState(ViewState.busy);
		_coordinates = await _coordinateService.getCoordinates();
		setState(ViewState.idle);
	}
	
	@override
	void dispose() {
		_coordinateService.removeListener(_onCoordinateServiceUpdated);
		super.dispose();
	}
}