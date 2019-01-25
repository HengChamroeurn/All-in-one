import 'package:flutter/material.dart';
import 'widgets/data_table/data_table.dart';
import 'inherited_widgets/demo/homescreen.dart';
import 'tips/transform_demo.dart';

void main() {
  runApp(
    new HomeApp(),
  );
}

class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Demo',
      home: new Tip3(),
    );
  }
}
