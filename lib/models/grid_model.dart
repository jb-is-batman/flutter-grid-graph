class GridModel {
  final AxisModel yLeft;
  final AxisModel yRight;
  final AxisModel xBottom;
  final AxisModel xTop;

  GridModel({required this.yLeft, required this.yRight, required this.xBottom, required this.xTop});
}

class AxisModel {
  final double min;
  final double max;
  final double step;
  final String label;

  AxisModel({required this.min, required this.max, required this.step, required this.label});
}