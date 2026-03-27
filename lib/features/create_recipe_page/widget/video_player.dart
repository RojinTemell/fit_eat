import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../core/constants/dynamic_constants.dart';

class SingleVideoPlayer extends StatefulWidget {
  final File file;

  const SingleVideoPlayer({required this.file});

  @override
  _SingleVideoPlayerState createState() => _SingleVideoPlayerState();
}

class _SingleVideoPlayerState extends State<SingleVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        setState(() {}); // İlk kareyi göstermek için
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      width: context.dynamicWidth(0.46),
      height: context.dynamicHeight(0.12),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(_controller),
                IconButton(
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                    size: 45,
                  ),
                  onPressed: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                ),
              ],
            ),
          ),

          // Video İlerleme Çubuğu
          VideoProgressIndicator(_controller, allowScrubbing: true),
        ],
      ),
    );
  }
}
