import 'package:flutter/material.dart';

import '../../model/hehe_media.dart';

class AudioListScreen extends StatelessWidget {
  final List<HeHeMedia> audioList;

  const AudioListScreen({
    super.key,
    required this.audioList,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(itemBuilder: (context, index) {
        final audio = audioList[index];
        return ListTile(
            title: Text(audio.name),
            leading: const Icon(
              Icons.music_video_rounded,
              color: Colors.blueAccent,
            ),
            trailing: const Icon(
              Icons.favorite_border,
              color: Colors.black,
            ),
            onTap: () {
              debugPrint('play audio${audio.name}');
            });
      }),
    );
  }
}
