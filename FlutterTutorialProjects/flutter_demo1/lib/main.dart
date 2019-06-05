import 'package:flutter/material.dart';
import 'widgets/Connectivity/ConnectivityDemo.dart';

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
      title: 'Flutter Tutorials',
      home: new ConnectivityDemo(),
    );
  }
}
