import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'channel_detail_screen.dart';  // Import the channel detail screen

class ChannelsScreen extends StatefulWidget {
  @override
  _ChannelsScreenState createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends State<ChannelsScreen> {
  List<ChannelItem> _channelItems = [];
  bool _isLoading = false;
  int _currentPage = 0;
  bool _isLastPage = false;

  @override
  void initState() {
    super.initState();
    fetchChannels(); // Fetch the first page of channels
  }

  Future<void> fetchChannels() async {
    if (_isLoading || _isLastPage) return; // Prevent multiple calls or loading beyond last page

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://app.edratech.com:8443/api/channel/all?page=$_currentPage&size=10');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedData = json.decode(utf8.decode(response.bodyBytes));
      final List<dynamic> items = decodedData['content'];

      setState(() {
        _channelItems.addAll(items.map((item) => ChannelItem.fromMap(item)).toList());
        _isLastPage = decodedData['last']; // Update if this is the last page
        _currentPage++; // Increment the page number
      });
    } else {
      // Handle error
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!_isLoading && !_isLastPage && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            fetchChannels(); // Fetch more channels when the user reaches the bottom
          }
          return false;
        },
        child: ListView.builder(
          itemCount: _channelItems.length + 1, // +1 for the loading indicator
          itemBuilder: (context, index) {
            if (index == _channelItems.length) {
              return _isLoading
                  ? Center(child: CircularProgressIndicator()) // Show a loading indicator at the bottom
                  : SizedBox.shrink(); // If not loading, don't show anything
            }
            final channel = _channelItems[index];
            return _buildChannelItem(context, channel);
          },
        ),
      ),
    );
  }

  Widget _buildChannelItem(BuildContext context, ChannelItem channel) {
    return InkWell(
      onTap: () {
        // Navigate to the ChannelDetailScreen when a channel is clicked
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChannelDetailScreen(
              channelId: channel.channelId,
              channelName: channel.name,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Column: Circular Thumbnail
            CircleAvatar(
              radius: 40.0, // Size of the circle avatar
              backgroundImage: NetworkImage(channel.thumbnailUrl),
              backgroundColor: Colors.grey[200], // Fallback background color if no image
            ),

            SizedBox(width: 16.0), // Spacing between image and text

            // Right Column: Channel Info (Name, Published At, Subscribers)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Channel Name
                  Text(
                    channel.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 4.0), // Spacing

                  // Published At Date
                  Text(
                    "Published: ${channel.publishedAt}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),

                  SizedBox(height: 4.0), // Spacing

                  // Total Subscribers
                  Text(
                    "${channel.totalSubscribers} subscribers",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
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

class ChannelItem {
  final String channelId;
  final String name;
  final String thumbnailUrl;
  final String publishedAt;
  final String totalSubscribers;

  ChannelItem({
    required this.channelId,
    required this.name,
    required this.thumbnailUrl,
    required this.publishedAt,
    required this.totalSubscribers,
  });

  factory ChannelItem.fromMap(Map<String, dynamic> map) {
    return ChannelItem(
      channelId: map['channelId'] ?? '',
      name: map['name'] ?? '',
      thumbnailUrl: map['thumbnails'][0]['url'] ?? '',
      publishedAt: map['publishedAt'] ?? 'Unknown',
      totalSubscribers: map['totalSubscribers']?.toString() ?? '0',
    );
  }
}