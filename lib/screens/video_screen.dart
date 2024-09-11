import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pod_player/pod_player.dart';
import 'package:http/http.dart' as http;

class VideoScreen extends StatefulWidget {
  final String videoId;

  VideoScreen({required this.videoId});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late PodPlayerController _controller;
  Map<String, dynamic>? videoDetails; // To store fetched video details
  bool _isLoading = true; // To show loading indicator while fetching data

  @override
  void initState() {
    super.initState();
    _controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.youtube(widget.videoId),
    )..initialise();

    // Lock orientation to portrait mode initially
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // Fetch video details
    fetchVideoDetails();
  }

  Future<void> fetchVideoDetails() async {
    final url = Uri.parse('https://app.edratech.com:8443/api/video/${widget.videoId}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        videoDetails = json.decode(utf8.decode(response.bodyBytes));
        _isLoading = false; // Loading completed
      });
    } else {
      setState(() {
        _isLoading = false; // Stop loading even if there was an error
      });
    }
  }

  @override
  void dispose() {
    // Reset the orientation back to normal
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          body: orientation == Orientation.portrait
              ? Column(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: PodVideoPlayer(controller: _controller),
              ),
              // Show loading indicator while fetching video details
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : videoDetails != null
                  ? Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      // Video Title
                      Text(
                        videoDetails!['title'] ?? 'No title available',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      // Video Views and Published Date
                      Text(
                        "${videoDetails!['totalViews'] ?? 0} views • Published on ${videoDetails!['publishedAt'] ?? 'N/A'}",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Divider(),
                      // Video Description
                      Text(
                        videoDetails!['description'] ?? 'No description available',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              )
                  : Center(child: Text('Error fetching video details')), // Handle error scenario
            ],
          )
              : Center(
            child: PodVideoPlayer(controller: _controller),
          ),
        );
      },
    );
  }
}