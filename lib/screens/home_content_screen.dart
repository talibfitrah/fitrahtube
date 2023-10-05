import 'package:flutter/material.dart';
import 'all_videos_list_item.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'video_screen.dart';

class HomeContentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomListView(), // Use a custom ListView
    );
  }
}

class CustomListView extends StatefulWidget {
  @override
  _CustomListViewState createState() => _CustomListViewState();
}

class _CustomListViewState extends State<CustomListView> {
  // Replace with your YouTube API key
  final String apiKey = 'AIzaSyCG1DCcB9ADW0iCs72-DPQ_JnvL2ql04Ok';
  final String playlistId = 'PLriFofF1xij6AlFYtwqvjg7G__Mj1y-L3'; // Replace with your playlist ID
  List<VideoItem> _videoItems = [];
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    fetchVideos();
    _controller = YoutubePlayerController(
      initialVideoId: '', // Set to an empty string initially
      flags: YoutubePlayerFlags(
        autoPlay: true,
      ),
    );
  }

  Future<void> fetchVideos() async {
    final url = Uri.parse(
        'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=20&playlistId=$playlistId&key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      final items = decodedData['items'] as List<dynamic>;

      setState(() {
        _videoItems = items
            .map((item) => VideoItem.fromMap(item['snippet']))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _videoItems.length,
      itemBuilder: (context, index) {
        final video = _videoItems[index];
        return ListTile(
          title: Text(video.title),
          leading: Image.network(video.thumbnailUrl),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoScreen(
                  videoId: video.videoId,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class VideoItem {
  final String title;
  final String thumbnailUrl;
  final String videoId;

  VideoItem({
    required this.title,
    required this.thumbnailUrl,
    required this.videoId,
  });

  factory VideoItem.fromMap(Map<String, dynamic> map) {
    return VideoItem(
      title: map['title'],
      thumbnailUrl: map['thumbnails']['medium']['url'],
      videoId: map['resourceId']['videoId'],
    );
  }
}

