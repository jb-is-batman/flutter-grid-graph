import 'package:flutter/material.dart';
import 'package:flutter_grid_graph/core/baseview/baseview_model.dart';
import 'package:flutter_grid_graph/core/locator.dart';
import 'package:provider/provider.dart';


class BaseView<T extends BaseViewModel> extends StatefulWidget {
	final Widget Function(BuildContext context, T model, Widget? child) builder;
	final Function(T)? onModelReady;

	const BaseView({required this.builder, this.onModelReady, Key? key}) : super(key: key);

	@override
	// ignore: library_private_types_in_public_api
	_BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseViewModel> extends State<BaseView<T>> {
	T model = locator<T>();

	@override
	void initState() {
		if (widget.onModelReady != null) {
			widget.onModelReady!(model);
		}
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		return ChangeNotifierProvider<T>(
			create: (context) => model,
			child: Consumer<T>(builder: widget.builder)
		);
	}
}