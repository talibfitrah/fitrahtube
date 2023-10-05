import 'package:fitrahtube/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const FitrahTubeApp());
}

class FitrahTubeApp extends StatelessWidget {
  const FitrahTubeApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Fitrah Tube',
      debugShowCheckedModeBanner: false,
      home: FitrahTubeSplash(),
    );
  }
}
