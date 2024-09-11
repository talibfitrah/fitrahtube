import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'video_screen.dart';  // Import the VideoScreen to show the video

class PlaylistVideosScreen extends StatefulWidget {
  final String playlistId;
  final String playlistTitle;

  PlaylistVideosScreen({required this.playlistId, required this.playlistTitle});

  @override
  _PlaylistVideosScreenState createState() => _PlaylistVideosScreenState();
}

class _PlaylistVideosScreenState extends State<PlaylistVideosScreen> {
  List<VideoItem> _videoItems = [];
  bool _isLoading = false;
  int _currentPage = 0;
  bool _isLastPage = false;

  @override
  void initState() {
    super.initState();
    fetchVideos(); // Fetch the first page of videos
  }

  Future<void> fetchVideos() async {
    if (_isLoading || _isLastPage) return;

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        'https://app.edratech.com:8443/api/playlist/${widget.playlistId}/videos?page=$_currentPage&size=10');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedData = json.decode(utf8.decode(response.bodyBytes));
      final List<dynamic> items = decodedData['content'];

      setState(() {
        _videoItems.addAll(
            items.map((item) => VideoItem.fromMap(item)).toList());
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlistTitle), // Display the playlist title
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!_isLoading &&
              !_isLastPage &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            fetchVideos(); // Fetch more videos when scrolled to bottom
          }
          return false;
        },
        child: ListView.builder(
          itemCount: _videoItems.length + 1,
          itemBuilder: (context, index) {
            if (index == _videoItems.length) {
              return _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox.shrink();
            }
            final video = _videoItems[index];
            return _buildVideoItem(context, video);
          },
        ),
      ),
    );
  }

  Widget _buildVideoItem(BuildContext context, VideoItem video) {
    if (!video.isVisible) return SizedBox.shrink(); // Skip non-visible videos

    return InkWell(
      onTap: () {
        // Navigate to VideoScreen when a video is clicked
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoScreen(videoId: video.videoId),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                video.thumbnailUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8),
            Text(
              video.title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              "${video.publishedAt} • ${video.totalViews} views",
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class VideoItem {
  final String videoId;
  final String title;
  final String thumbnailUrl;
  final String publishedAt;
  final String totalViews;
  final bool isVisible;

  VideoItem({
    required this.videoId,
    required this.title,
    required this.thumbnailUrl,
    required this.publishedAt,
    required this.totalViews,
    required this.isVisible,
  });

  factory VideoItem.fromMap(Map<String, dynamic> map) {
    return VideoItem(
      videoId: map['videoId'] ?? '',
      title: map['title'] ?? '',
      thumbnailUrl: map['thumbnails'][0]['url'] ?? '',
      publishedAt: map['publishedAt'] ?? '',
      totalViews: map['totalViews']?.toString() ?? '0',
      isVisible: map['visible'] ?? false,
    );
  }
}
