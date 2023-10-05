import 'package:flutter/material.dart';

class AllVideosListItem extends StatelessWidget {
  final String title;
  final String imageUrl;

  AllVideosListItem({required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Image from the internet
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            height: 200.0, // Adjust the height as needed
          ),
          SizedBox(height: 8.0),
          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          // Other content (e.g., video duration, channel name, etc.)
          // Add any additional content as needed
        ],
      ),
    );
  }
}