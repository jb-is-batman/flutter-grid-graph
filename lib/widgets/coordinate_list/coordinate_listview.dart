import 'package:flutter/material.dart';
import 'package:flutter_grid_graph/core/baseview/baseview.dart';
import 'package:flutter_grid_graph/widgets/coordinate_list/coordinate_listviewmodel.dart';

class CoordinateListView extends StatelessWidget {
  const CoordinateListView({super.key});

  @override
  Widget build(BuildContext context) {
	late List<TextEditingController> xControllers;
	late List<TextEditingController> yControllers;

    return BaseView<CoordinateListViewModel>(
			onModelReady: (CoordinateListViewModel model) async {
				await model.getCoordinates();
				xControllers = model.coordinates
					.map((coordinate) => TextEditingController(text: '${coordinate.x.round()}'))
					.toList();
				yControllers = model.coordinates
					.map((coordinate) => TextEditingController(text: '${coordinate.y.round()}'))
					.toList();
			},
			builder: (context, model, child) {
				return LayoutBuilder(
					builder: (BuildContext context, BoxConstraints constraints) {
						return ReorderableListView.builder(
							onReorder: (oldIndex, newIndex) {
								model.disableAllEdit();
								model.reorder(oldIndex, newIndex);

								if (newIndex > model.coordinates.length) {
									newIndex = model.coordinates.length;
								}

								if (oldIndex < newIndex) {
									newIndex -= 1;
								}
								// Dispose and recreate controllers for the reordered items
								TextEditingController oldXController = xControllers.removeAt(oldIndex);
								TextEditingController oldYController = yControllers.removeAt(oldIndex);
								oldXController.dispose();
								oldYController.dispose();
								
								TextEditingController newXController = TextEditingController(text: '${model.coordinates[newIndex].x.round()}');
								TextEditingController newYController = TextEditingController(text: '${model.coordinates[newIndex].y.round()}');
								
								xControllers.insert(newIndex, newXController);
								yControllers.insert(newIndex, newYController);
							},
							itemCount: model.coordinates.length,
							itemBuilder: (context, index) {
								if(index >= xControllers.length) {
									xControllers.add(TextEditingController(text: '${model.coordinates[index].x.round()}'));
									yControllers.add(TextEditingController(text: '${model.coordinates[index].y.round()}'));
								}
								
								xControllers[index].text = '${model.coordinates[index].x.round()}';
								yControllers[index].text = '${model.coordinates[index].y.round()}';
								
								TextEditingController xController = xControllers[index];
								TextEditingController yController = yControllers[index];
								return Card(
								key: Key('$index'),
								child: ListTile(
									key: Key('$index'),
									leading: CircleAvatar(
										child: Text("${index + 1}"),
									),
									title: Row(
										mainAxisSize: MainAxisSize.min,
									  	children: [

											// Text("x: ${model.coordinates[index].x.round()}"),
											Expanded(
												child: TextField(
													key: ValueKey('x-$index'), // Unique key for x TextField
													readOnly: !model.isEditingList[index],
													controller: xController,
													onChanged: (value) => xController.text = value,
													decoration: const InputDecoration(
														labelText: 'X',
													),
												),
											),
											Expanded(
												child: TextField(
													key: ValueKey('y-$index'), // Unique key for y TextField
													readOnly: !model.isEditingList[index],
													controller: yController,
													onChanged: (value) => xController.text = value,
													decoration: const InputDecoration(
														labelText: 'Y',
													),
												),
											),
											// Text("y: ${model.coordinates[index].y.round()}"),
										],
									),
									trailing: model.isEditingList[index] ? Row(
									mainAxisSize: MainAxisSize.min,
									children: [
										IconButton(
									    	icon: const Icon(Icons.check, color: Colors.green, size: 18),
									    	onPressed: () {
									    		// model.saveUpdatedCoordinate(index);
									    	},
									    ),
									    IconButton(
									    	icon: const Icon(Icons.delete, color: Colors.red, size: 18),
									    	onPressed: () {
												TextEditingController oldXController = xControllers.removeAt(index);
												TextEditingController oldYController = yControllers.removeAt(index);
												oldXController.dispose();
												oldYController.dispose();
									    		model.deleteCoordinate(index);
									    	},
									    ),
										TextButton(onPressed: (){
											model.toggleEdit(index);
										},
										child: const Text("Cancel"))
									  ],
									) : IconButton(onPressed: () => model.toggleEdit(index), icon: const Icon(Icons.edit, size: 18,)),
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