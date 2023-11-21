import 'package:flutter/material.dart';
import 'package:flutter_grid_graph/core/baseview/baseview.dart';
import 'package:flutter_grid_graph/widgets/coordinate_list/coordinate_listviewmodel.dart';

class CoordinateListView extends StatelessWidget {
  const CoordinateListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<CoordinateListViewModel>(
			onModelReady: (CoordinateListViewModel model) => model.getCoordinates(),
			builder: (context, model, child) {
				return LayoutBuilder(
					builder: (BuildContext context, BoxConstraints constraints) {
						return ListView.builder(
							itemCount: model.coordinates.length,
							itemBuilder: (context, index) {
								return Card(
									child: ListTile(
										title: Text("X: ${model.coordinates[index].x.round()} Y: ${model.coordinates[index].y.round()}"),
									),
								);
							},
						);
					},
				);
			}
		);
  	}
}