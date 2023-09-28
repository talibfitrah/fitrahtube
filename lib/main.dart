import 'package:fitrahtube/splash_screen.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const FitrahTubeApp());
}

class FitrahTubeApp extends StatelessWidget {
  const FitrahTubeApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FitrahTubeSplash(),
    );
  }
}
