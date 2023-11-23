import 'package:flutter/material.dart';
import 'package:flutter_grid_graph/core/baseview/baseview.dart';
import 'package:flutter_grid_graph/widgets/coordinate_list/coordinate_listviewmodel.dart';

class CoordinateListView extends StatelessWidget {
  const CoordinateListView({super.key});

  @override
  Widget build(BuildContext context) {
	late List<TextEditingController> xControllers;
	late List<TextEditingController> yControllers;
	late List<TextEditingController> labelControllers;
	InputDecoration txtInputDecorationX = const InputDecoration(
		contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
		labelText: 'X',
	);
	InputDecoration txtInputDecorationY = const InputDecoration(
		contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
		labelText: 'Y'
	);
	InputDecoration txtInputDecorationLabel = const InputDecoration(
		contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
		labelText: 'Label'
	);

    return BaseView<CoordinateListViewModel>(
			onModelReady: (CoordinateListViewModel model) async {
				await model.getCoordinates();
				xControllers = model.coordinates
					.map((coordinate) => TextEditingController(text: '${coordinate.x.round()}'))
					.toList();
				yControllers = model.coordinates
					.map((coordinate) => TextEditingController(text: '${coordinate.y.round()}'))
					.toList();
				labelControllers = model.coordinates
					.map((coordinate) => TextEditingController(text: coordinate.label ?? ""))
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
								TextEditingController oldXController 		= xControllers.removeAt(oldIndex);
								TextEditingController oldYController 		= yControllers.removeAt(oldIndex);
								TextEditingController oldLabelController	= labelControllers.removeAt(oldIndex);
								
								oldXController.dispose();
								oldYController.dispose();
								oldLabelController.dispose();
								
								TextEditingController newXController 		= TextEditingController(text: '${model.coordinates[newIndex].x.round()}');
								TextEditingController newYController 		= TextEditingController(text: '${model.coordinates[newIndex].y.round()}');
								TextEditingController newLabelController	= TextEditingController(text: '${model.coordinates[newIndex].label}');
								
								xControllers.insert(newIndex, newXController);
								yControllers.insert(newIndex, newYController);
								labelControllers.insert(newIndex, newLabelController);
							},
							itemCount: model.coordinates.length,
							itemBuilder: (context, index) {
								if(index >= xControllers.length) {
									xControllers.add(TextEditingController(text: '${model.coordinates[index].x.round()}'));
									yControllers.add(TextEditingController(text: '${model.coordinates[index].y.round()}'));
									labelControllers.add(TextEditingController(text: model.coordinates[index].label ?? ""));
								}
								
								xControllers[index].text 				= '${model.coordinates[index].x.round()}';
								yControllers[index].text 				= '${model.coordinates[index].y.round()}';
								labelControllers[index].text			= model.coordinates[index].label ?? "";
								
								TextEditingController xController 		= xControllers[index];
								TextEditingController yController 		= yControllers[index];
								TextEditingController labelController 	= labelControllers[index];
								return Card(
								key: Key('c-$index'),
								child: ListTile(
									key: Key('lt-$index'),
									leading: CircleAvatar(
										child: Text("${index + 1}"),
									),
									title: Row(
										mainAxisSize: MainAxisSize.min,
									  	children: [
											Expanded(
												child: TextField(
													key: ValueKey('x-$index'), // Unique key for x TextField
													enabled: model.isEditingList[index],
													controller: xController,
													// onChanged: (value) => xController.text = value,
													decoration: txtInputDecorationX
												),
											),
											Container(width: 5,),
											Expanded(
												child: TextField(
													key: ValueKey('y-$index'), // Unique key for y TextField
													enabled: model.isEditingList[index],
													controller: yController,
													// onChanged: (value) => yController.text = value,
													decoration: txtInputDecorationY
												),
											),
											Container(width: 5,),
											Expanded(
												child: TextField(
													key: ValueKey('label-$index'), // Unique key for y TextField
													enabled: model.isEditingList[index],
													controller: labelController,
													// onChanged: (value) => yController.text = value,
													decoration: txtInputDecorationLabel,
												),
											),
										],
									),
									trailing: model.isEditingList[index] ? Row(
									mainAxisSize: MainAxisSize.min,
									children: [
										IconButton(
									    	icon: const Icon(Icons.check, color: Colors.green, size: 18),
									    	onPressed: () {
									    		model.saveUpdatedCoordinate(index, double.parse(xController.text), double.parse(yController.text), labelController.text);
									    	},
									    ),
									    IconButton(
									    	icon: const Icon(Icons.delete, color: Colors.red, size: 18),
									    	onPressed: () {
												TextEditingController oldXController 		= xControllers.removeAt(index);
												TextEditingController oldYController 		= yControllers.removeAt(index);
												TextEditingController oldLabelController	= labelControllers.removeAt(index);
												oldXController.dispose();
												oldYController.dispose();
												oldLabelController.dispose();
									    		model.deleteCoordinate(index);
									    	},
									    ),
										TextButton(onPressed: (){
											model.toggleEdit(index);
										},
										child: const Text("Cancel"))
									  ],
									) : IconButton(onPressed: () {
										model.disableAllEdit();
										model.toggleEdit(index);
									}, icon: const Icon(Icons.edit, size: 18,)),
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