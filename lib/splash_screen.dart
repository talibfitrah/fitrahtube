import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import the next screen

class FitrahTubeSplash extends StatefulWidget {
  @override
  _FitrahTubeSplashState createState() => _FitrahTubeSplashState();
}

class _FitrahTubeSplashState extends State<FitrahTubeSplash> {
  @override
  void initState() {
    super.initState();
    // Add a delay of 5 seconds before navigating to the next screen
    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Change to your desired background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Add the gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(50.0),
                child: Text(
                  "Fitrah Tube",
                  style: TextStyle(
                    fontSize: 36.0,
                    color: Colors.white, // Text color
                    fontFamily: "YourCoolFont", // Replace with your desired font
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Add the heart icon
            SizedBox(height: 20.0),
            Icon(
              Icons.favorite, // Use the heart icon from Flutter's built-in icons
              color: Colors.red, // Heart icon color
              size: 50.0, // Adjust the size as needed
            ),
          ],
        ),
      ),
    );
  }
}
