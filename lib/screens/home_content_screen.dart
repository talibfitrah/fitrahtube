import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'video_screen.dart'; // Import the VideoScreen to show the video

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
    if (_isLoading || _isLastPage) return; // Prevent multiple calls or fetching beyond last page

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        'https://app.edratech.com:8443/api/search/all?size=10&page=$_currentPage');
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
        padding: const EdgeInsets.symmetric(vertical: 10.0), // Padding between items
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
  final String title;
  final String thumbnailUrl;
  final String videoId;
  final String publishedAt; // Added publishedAt
  final String totalViews; // Added totalViews

  VideoItem({
    required this.title,
    required this.thumbnailUrl,
    required this.videoId,
    required this.publishedAt, // Initialize publishedAt
    required this.totalViews, // Initialize totalViews
  });

  factory VideoItem.fromMap(Map<String, dynamic> map) {
    return VideoItem(
      title: map['title'] ?? '',
      thumbnailUrl: map['thumbnailUrl'] ?? '',
      videoId: map['id'] ?? '',
      publishedAt: map['publishedAt'] ?? 'Unknown date', // Example metadata
      totalViews: map['metadataValue']?.toString() ?? '0', // Example metadata
    );
  }
}
