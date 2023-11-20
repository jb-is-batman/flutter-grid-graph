import 'package:flutter_grid_graph/services/graph_service.dart';
import 'package:flutter_grid_graph/views/grid_view/grid_viewmodel.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
	// Services
	locator.registerLazySingleton(() => GraphService());

	// Models
	locator.registerFactory(() => GridViewModel());
}