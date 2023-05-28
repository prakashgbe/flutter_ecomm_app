import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class VideoComponent extends StatelessWidget {
  const VideoComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,

      title: 'Wilsonart',
      home: YoutubeLoader(),
    );
  }
}

class YoutubeLoader extends StatelessWidget {
  static String myVideoId = '1kCJD2xdL8w';

  // Initiate the Youtube player controller
  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: myVideoId,
    flags: const YoutubePlayerFlags(
      autoPlay: true,
      mute: false,
    ),
  );

  YoutubeLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
          controller: _controller,
          liveUIColor: Colors.amber,
        );
  }
}