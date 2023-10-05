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
    // Get screen width and height
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            // Gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Centered content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Spacer to push content to the top
                  Spacer(),
                  // Add the text "FITRAH" and "TUBE" along with the heart icon
                  Column(
                    children: [
                      // Add the text "Fitrah Tube"
                      Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "FITRAH",
                              style: TextStyle(
                                fontSize: screenWidth * 0.1, // Responsive font size
                                color: Colors.white,
                                fontFamily: "CoCoGoose",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: " TUBE",
                              style: TextStyle(
                                fontSize: screenWidth * 0.1, // Responsive font size
                                color: Colors.white,
                                fontFamily: "CoCoGoose",
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Add a space between text and heart icon
                      SizedBox(height: screenHeight * 0.03), // Responsive spacing
                      // Use a Stack to overlay the heart icon on top of the text
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // White heart icon
                          Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: screenWidth * 0.15, // Responsive icon size
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Spacer to push content to the bottom
                  Spacer(),
                  // Add the "Powered by Stichting Tarbiyah Consultancy" text
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.03), // Responsive padding
                    child: Text(
                      "Powered by Stichting Tarbiyah Consultancy",
                      style: TextStyle(
                        fontSize: screenWidth * 0.035, // Responsive font size
                        color: Colors.white,
                        fontFamily: "YourThinFont", // Replace with your thin font
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}