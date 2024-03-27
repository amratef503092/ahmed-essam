import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../pod_player_custom/pod_player.dart';

class Fullscreen extends StatefulWidget {
  const Fullscreen({super.key, required this.controller});
  final PodPlayerController controller;

  @override
  State<Fullscreen> createState() => _FullscreenState();
}

class _FullscreenState extends State<Fullscreen> {
  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Screen'),
      ),
      body: Center(
        child: PodVideoPlayer(
          controller: widget.controller,
        ),
      ),
    );
  }
}
