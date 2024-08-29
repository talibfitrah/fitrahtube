import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pod_player/pod_player.dart';

class VideoScreen extends StatefulWidget {
  final String videoId;

  VideoScreen({required this.videoId});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late PodPlayerController _controller;

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
              // Additional UI elements like video title, description, etc.
              Expanded(
                child: Center(
                  child: Text(
                    widget.videoId,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
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
