import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'video_screen.dart'; // Import the VideoScreen to show the video

class ChannelVideosTab extends StatefulWidget {
  final String channelId;

  ChannelVideosTab({required this.channelId});

  @override
  _ChannelVideosTabState createState() => _ChannelVideosTabState();
}

class _ChannelVideosTabState extends State<ChannelVideosTab> {
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
    if (_isLoading || _isLastPage) return; // Prevent multiple calls or fetching beyond last page

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        'https://app.edratech.com:8443/api/channel/${widget.channelId}/videos?page=$_currentPage&size=10');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedData = json.decode(utf8.decode(response.bodyBytes));
      final items = decodedData['content'] as List<dynamic>;

      setState(() {
        _videoItems.addAll(items.map((item) => VideoItem.fromMap(item)).toList());
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
          return _buildVideoItem(context, video); // Pass the context to handle navigation
        },
      ),
    );
  }

  Widget _buildVideoItem(BuildContext context, VideoItem video) {
    return InkWell(
      onTap: () {
        // Navigate to the VideoScreen when a video item is clicked
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoScreen(videoId: video.videoId),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0), // Padding between items
        child: Column(
          children: [
            // Video card with shadow and margin
            FractionallySizedBox(
              widthFactor: 0.95, // 95% of the screen width
              child: Card(
                elevation: 4.0, // Add some shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded edges for the card
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0), // Padding inside the card
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Thumbnail with rounded corners
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0), // Rounded corners for the thumbnail
                        child: Image.network(
                          video.thumbnailUrl,
                          width: double.infinity, // Thumbnail spans full width within card
                          height: 150, // Fixed height
                          fit: BoxFit.cover, // Cover the thumbnail space
                        ),
                      ),
                      SizedBox(height: 8), // Spacing between thumbnail and text

                      // Video title
                      Text(
                        video.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      // Video metadata (published date and total views)
                      Text(
                        "Published: ${video.publishedAt} • ${video.totalViews} views",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Divider between items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding for the divider
              child: Divider(
                thickness: 1, // Thickness of the divider
                color: Colors.grey[300], // Light grey divider color
              ),
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

  VideoItem({
    required this.videoId,
    required this.title,
    required this.thumbnailUrl,
    required this.publishedAt,
    required this.totalViews,
  });

  factory VideoItem.fromMap(Map<String, dynamic> map) {
    return VideoItem(
      videoId: map['videoId'] ?? '',
      title: map['title'] ?? '',
      thumbnailUrl: map['thumbnails'][0]['url'] ?? '',
      publishedAt: map['publishedAt'] ?? '',
      totalViews: map['totalViews']?.toString() ?? '0',
    );
  }
}