import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerHandler extends BaseAudioHandler {
  final AudioPlayer _audioPlayer = AudioPlayer();
  @override
  Future<void> stop() async => await _audioPlayer.stop();
  @override
  Future<void> pause() async => _audioPlayer.pause();
  @override
  Future<void> play() async => _audioPlayer.play();
}
