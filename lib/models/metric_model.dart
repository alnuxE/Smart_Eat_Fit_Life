class MetricData {
  final double x;
  final double y;

  MetricData({required this.x, required this.y});
}

class Metric {
  final String title;
  final String unit;
  final String currentValue;
  final List<MetricData> history;

  Metric({
    required this.title,
    required this.unit,
    required this.currentValue,
    required this.history,
  });
}
