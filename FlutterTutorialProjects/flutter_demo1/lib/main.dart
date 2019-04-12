import 'package:flutter/material.dart';
import 'others/GradientDemo/GradientDemo.dart';

void main() {
  runApp(
    new HomeApp(),
  );
}

class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demo',
      home: new GradientDemo(),
    );
  }
}
