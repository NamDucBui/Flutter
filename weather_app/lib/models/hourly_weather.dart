class HourlyWeather {
  const HourlyWeather({
    required this.icon,
    required this.temperature,
    required this.time,
  });
  final String time;
  final double temperature;
  final String icon;
}
