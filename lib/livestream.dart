import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

YoutubePlayerController _controller = YoutubePlayerController(
  initialVideoId: 'ETW30Fg7KsE',
  flags: const YoutubePlayerFlags(
    isLive: true,
    autoPlay: true,
  ),
);

class YouTubeLiveStream extends StatelessWidget {
  const YouTubeLiveStream({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Camera'),
      ),
      body: Column(
        children: [
          Expanded(
            child: YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: _controller,
                bottomActions: [
                  CurrentPosition(),
                  ProgressBar(isExpanded: true),
                  RemainingDuration(),
                  FullScreenButton(),
                ],
              ),
              builder: (context, player) {
                return Column(
                  children: [
                    player,
                    // More of your widgets
                  ],
                );
              },
            ),
          ),
          GestureDetector(
            onTapDown: (_) async {
              //await startRecordingAndPublishing();
            },
            onTapUp: (_) async {
              //await stopRecordingAndPublishing();
            },
            child: Container(
              color: Colors.blue,
              width: double.infinity,
              height: 60,
              child: Center(
                child: Icon(Icons.mic, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
