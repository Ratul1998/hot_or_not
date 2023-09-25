import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatelessWidget {
  final String videoUrl;
  final VideoPlayerController videoController;
  final Function() onMutePressed;
  const VideoPlayerView(
      {super.key,
      required this.videoUrl,
      required this.videoController,
      required this.onMutePressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VideoPlayer(videoController),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
              onPressed: onMutePressed,
              icon: const Icon(
                Icons.volume_mute,
                color: Colors.white,
                size: 48,
              )),
        ),
      ],
    );
  }
}
