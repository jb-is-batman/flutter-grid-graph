import 'package:flutter_grid_graph/services/graph_service.dart';
import 'package:flutter_grid_graph/widgets/coordinate_list/coordinate_listviewmodel.dart';
import 'package:flutter_grid_graph/widgets/grid_view/grid_viewmodel.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
	// Services
	locator.registerLazySingleton(() => GraphService());

	// ViewModels
	locator.registerFactory(() => GridViewModel());
  locator.registerFactory(() => CoordinateListViewModel());
}