import 'package:audio_service/audio_service.dart';
import 'package:cosmos/pages/video_player/audio/audio_player_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/video_list/video_list_screen.dart';

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    debugPrint('''
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$newValue"
}''');
  }
}

late AudioHandler audioHandler;
late AudioPlayerHandler audioPlayerHandler;

Future<void> runMainApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  audioPlayerHandler = AudioPlayerHandler();
  audioHandler = await AudioService.init(
    builder: () => audioPlayerHandler,
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.paulyswen.channel.audio',
      androidNotificationChannelName: 'He He Videos',
      androidNotificationOngoing: true,
    ),
  );
  runApp(
    ProviderScope(
      observers: [
        Logger(),
      ],
      child: MaterialApp(
        home: VideoListScreen(),
      ),
    ),
  );
}
