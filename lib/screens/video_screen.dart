import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {
  final String videoId;

  VideoScreen({required this.videoId});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        controlsVisibleAtStart: false, // Show controls initially
        hideControls: false, // Show controls while playing
        autoPlay: true,
        mute: false,
        disableDragSeek: true, // Disable drag to seek
        loop: false,
        forceHD: true,
        enableCaption: false, // Disable captions
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Screen'),
      ),
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          onReady: () {
            _controller.removeListener(() {});
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}