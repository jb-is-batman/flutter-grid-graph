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
						return ReorderableListView.builder(
							onReorder: (oldIndex, newIndex) {
								model.reorder(oldIndex, newIndex);
							},
							itemCount: model.coordinates.length,
							itemBuilder: (context, index) {
								return Card(
									key: Key('$index'),
									child: ListTile(
										key: Key('$index'),
										title: Text("${index + 1} (${model.coordinates[index].x.round()}, ${model.coordinates[index].y.round()})"),
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