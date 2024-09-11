import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'playlist_videos_screen.dart';  // Import the screen to display playlist videos

class ChannelPlaylistsTab extends StatefulWidget {
  final String channelId;

  ChannelPlaylistsTab({required this.channelId});

  @override
  _ChannelPlaylistsTabState createState() => _ChannelPlaylistsTabState();
}

class _ChannelPlaylistsTabState extends State<ChannelPlaylistsTab> {
  List<PlaylistItem> _playlistItems = [];
  bool _isLoading = false;
  int _currentPage = 0;
  bool _isLastPage = false;

  @override
  void initState() {
    super.initState();
    fetchPlaylists();
  }

  Future<void> fetchPlaylists() async {
    if (_isLoading || _isLastPage) return;

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        'https://app.edratech.com:8443/api/channel/${widget.channelId}/playlists?page=$_currentPage&size=10');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedData = json.decode(utf8.decode(response.bodyBytes));
      final List<dynamic> items = decodedData['content'];

      setState(() {
        _playlistItems
            .addAll(items.map((item) => PlaylistItem.fromMap(item)).toList());
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
          fetchPlaylists(); // Fetch more playlists when scrolled to bottom
        }
        return false;
      },
      child: ListView.builder(
        itemCount: _playlistItems.length + 1,
        itemBuilder: (context, index) {
          if (index == _playlistItems.length) {
            return _isLoading
                ? Center(child: CircularProgressIndicator())
                : SizedBox.shrink();
          }
          final playlist = _playlistItems[index];
          return _buildPlaylistItem(context, playlist);
        },
      ),
    );
  }

  Widget _buildPlaylistItem(BuildContext context, PlaylistItem playlist) {
    return InkWell(
      onTap: () {
        // Navigate to the PlaylistVideosScreen when a playlist is clicked
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaylistVideosScreen(
              playlistId: playlist.playlistId,  // Pass the playlist ID
              playlistTitle: playlist.title,    // Pass the playlist title
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: Row(
          children: [
            // Playlist Thumbnail (rounded rectangle)
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                playlist.thumbnailUrl,
                width: 100,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16.0),
            // Playlist Info (Title, Published At)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playlist.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Published: ${playlist.publishedAt}",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
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

class PlaylistItem {
  final String playlistId;
  final String title;
  final String thumbnailUrl;
  final String publishedAt;

  PlaylistItem({
    required this.playlistId,
    required this.title,
    required this.thumbnailUrl,
    required this.publishedAt,
  });

  factory PlaylistItem.fromMap(Map<String, dynamic> map) {
    return PlaylistItem(
      playlistId: map['playlistId'] ?? '',
      title: map['title'] ?? '',
      thumbnailUrl: map['thumbnails'][0]['url'] ?? '',
      publishedAt: map['publishedAt'] ?? '',
    );
  }
}