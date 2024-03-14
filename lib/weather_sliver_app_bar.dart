import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WeatherSliverAppBar extends StatelessWidget {
  final AsyncCallback? onRefresh;

  const WeatherSliverAppBar({
    this.onRefresh,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      stretch: true,
      backgroundColor: Colors.blue[300],
      expandedHeight: 200.0,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.fadeTitle,
          StretchMode.blurBackground,
        ],
        title: const Text('Weather App'),
        background: DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.center,
              colors: <Color>[Colors.blue[300]!, Colors.transparent],
            ),
          ),
          child: Image.asset(
            'assets/Clearsky.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}