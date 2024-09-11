import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import the next screen

class AlbunyaanTuzeSplash extends StatefulWidget {
  @override
  _AlbunyaanTuzeSplashState createState() => _AlbunyaanTuzeSplashState();
}

class _AlbunyaanTuzeSplashState extends State<AlbunyaanTuzeSplash>
    with SingleTickerProviderStateMixin {
  // Animation controller for the logo reveal
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Set up the animation controller and animation (Speed up the animation)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Smooth animation
    );

    _controller.forward(); // Start the animation

    // Navigate to the next screen after 5 seconds
    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller when no longer needed
    super.dispose();
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
            // Plain white background
            Container(
              color: Colors.white, // Set background color to white
            ),
            // Centered content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Spacer(), // Push content towards the top

                  // Logo with animation (scale-up effect)
                  ScaleTransition(
                    scale: _animation,
                    child: Image.asset(
                      'assets/images/AlbunyaanTuze.png', // Path to the logo
                      width: screenWidth * 0.6, // Responsive size for the logo
                      height: screenHeight * 0.3,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02), // Spacing between logo and text

                  // "Beta" and Arabic text
                  Column(
                    children: [
                      Text(
                        "Beta", // English word
                        style: TextStyle(
                          fontSize: screenWidth * 0.07, // Adjust font size
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent, // Use a distinct color for Beta
                          fontFamily: "Arial", // Simple and clean font for Beta
                        ),
                      ),
                      Text(
                        "الإصدار التجريبي", // Arabic translation for "First Edition"
                        style: TextStyle(
                          fontSize: screenWidth * 0.07, // Adjust font size
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent, // Match Beta color
                          fontFamily: "Arial", // Clean font for Arabic text
                        ),
                      ),
                    ],
                  ),

                  Spacer(), // Push content towards the bottom

                  // Add the "Powered by Stichting Tarbiyah Consultancy" text
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                    child: Text(
                      "Powered by Stichting Tarbiyah Consultancy",
                      style: TextStyle(
                        fontSize: screenWidth * 0.035, // Responsive font size
                        color: Colors.black, // Change the text color to black for better visibility on white background
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