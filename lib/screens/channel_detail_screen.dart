import 'package:flutter/material.dart';
import 'channel_videos_tab.dart';
import 'channel_playlists_tab.dart';

class ChannelDetailScreen extends StatelessWidget {
  final String channelId;
  final String channelName;

  ChannelDetailScreen({required this.channelId, required this.channelName});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // We have two tabs: Videos and Playlists
      child: Scaffold(
        appBar: AppBar(
          title: Text(channelName), // Display the channel's name
          bottom: TabBar(
            tabs: [
              Tab(text: "Videos"),
              Tab(text: "Playlists"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChannelVideosTab(channelId: channelId), // Videos Tab
            ChannelPlaylistsTab(channelId: channelId), // Playlists Tab
          ],
        ),
      ),
    );
  }
}