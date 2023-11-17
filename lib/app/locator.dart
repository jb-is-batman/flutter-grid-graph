import 'package:flutter_grid_graph/views/grid_view/grid_viewmodel.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerFactory(() => GridViewModel());
}