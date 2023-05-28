import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class HelpVideoComponent1 extends StatelessWidget {
  const HelpVideoComponent1({Key? key}) : super(key: key);

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
  static String myVideoId = 'Yo7E9YRPMrM';

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