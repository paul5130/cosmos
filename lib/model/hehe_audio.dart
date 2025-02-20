import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'hehe_audio.g.dart';

@CopyWith()
@JsonSerializable(explicitToJson: true)
class HeHeAudio extends Equatable {
  const HeHeAudio({
    required this.index,
    required this.filename,
  });
  final int index;
  final String filename;
  String get name => filename.split('.').first.replaceAll('-星際隕石團隊', '');

  factory HeHeAudio.fromJson(Map<String, dynamic> srcJson) =>
      _$HeHeAudioFromJson(srcJson);
  Map<String, dynamic> toJson() => _$HeHeAudioToJson(this);
  @override
  List<Object?> get props => [
        index,
        filename,
      ];
}
