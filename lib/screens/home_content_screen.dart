import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  List<VideoItem> _videoItems = [];
  int _currentPage = 0;
  bool _isLoading = false;
  bool _hasMoreData = true;
  bool _isLastPage = false;

  @override
  void initState() {
    super.initState();
    fetchVideos(); // Fetch the first page of videos
  }

  Future<void> fetchVideos() async {
    if (_isLoading || _isLastPage)
      return; // Prevent multiple calls or fetching beyond last page

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        'http://192.168.1.47:8080/api/search/all?size=10&page=$_currentPage');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedData = json.decode(utf8.decode(response.bodyBytes));
      final items = decodedData['content'] as List<dynamic>;

      setState(() {
        _videoItems
            .addAll(items.map((item) => VideoItem.fromMap(item)).toList());
        _isLastPage = decodedData['last'];
        _currentPage++;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!_isLoading &&
            !_isLastPage &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          fetchVideos();
        }
        return false;
      },
      child: ListView.builder(
        itemCount: _videoItems.length + 1, // +1 for the loading indicator
        itemBuilder: (context, index) {
          if (index == _videoItems.length) {
            return _isLoading
                ? Center(child: CircularProgressIndicator())
                : SizedBox.shrink();
          }
          final video = _videoItems[index];
          return ListTile(
            title: Text(video.title),
            leading: Image.network(video.thumbnailUrl),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoScreen(videoId: video.videoId),
                ),
              );
            },
          );
        },
      ),
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
      title: map['title'] ?? '',
      thumbnailUrl: map['thumbnailUrl'] ?? '',
      videoId: map['id'] ?? '',
    );
  }
}
