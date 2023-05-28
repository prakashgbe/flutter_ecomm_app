import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class HelpVideoComponent3 extends StatelessWidget {
  const HelpVideoComponent3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,

      title: 'Flutter Example',
      home: YoutubeLoader(),
    );
  }
}

class YoutubeLoader extends StatelessWidget {
  static String myVideoId = 'Mal-2t5gUoY';

  // Initiate the Youtube player controller
  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: myVideoId,
    flags: const YoutubePlayerFlags(
      autoPlay: false,
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