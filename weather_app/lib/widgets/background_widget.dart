import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key, required this.icon});
  final String icon;
  String getBackground() {
    if (icon.startsWith('01')) return 'sunny.jpg';
    if (icon.startsWith('02') || icon.startsWith('03')) return 'cloudy.jpg';
    if (icon.startsWith('09') || icon.startsWith('10')) return 'rain.jpg';
    if (icon.startsWith('11')) return 'storm.jpg';
    if (icon.startsWith('13')) return 'snow.jpg';
    return 'assets/images/sunny.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/${getBackground()}'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
