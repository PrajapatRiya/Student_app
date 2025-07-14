import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoBackgroundHeader extends StatefulWidget {
  final double height;
  const VideoBackgroundHeader({Key? key, required this.height}) : super(key: key);

  @override
  State<VideoBackgroundHeader> createState() => _VideoBackgroundHeaderState();
}

class _VideoBackgroundHeaderState extends State<VideoBackgroundHeader> {
  late VideoPlayerController _controller;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/images/videoplayer.mp4');

    _controller.initialize().then((_) {
      setState(() {}); // Rebuild to show video
      _controller.setLooping(true);
      _controller.setVolume(0);
      _controller.play();
    }).catchError((error) {
      setState(() => _isError = true);
    });

    /// Extra safety: Auto replay if video completes (some devices ignore `setLooping`)
    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration &&
          !_controller.value.isPlaying) {
        _controller.seekTo(Duration.zero);
        _controller.play();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: widget.height,
      child: _isError
          ? Container(
        color: Colors.grey,
        child: const Center(
          child: Text("Failed to load video"),
        ),
      )
          : _controller.value.isInitialized
          ? FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller),
        ),
      )
          : Container(
        color: Colors.grey,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
