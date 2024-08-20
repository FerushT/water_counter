import 'package:flutter/material.dart';
import 'package:water_counter/src/features/feature1/presentation/homeScreen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wasserzähler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WaterCounter(),
    );
  }
}
