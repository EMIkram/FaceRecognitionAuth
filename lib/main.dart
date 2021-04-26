import 'package:FaceNetAuthentication/pages/home.dart';
import 'package:FaceNetAuthentication/pages/qr_generator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:
      QRGenerator(),
      // MyHomePage(),
    );
  }
}
