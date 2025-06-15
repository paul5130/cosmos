import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'hehe_audio.g.dart';

@CopyWith()
@JsonSerializable(explicitToJson: true)
class HeHeAudio extends Equatable {
  const HeHeAudio({
    required this.index,
    required this.originalFilename,
    required this.newFilename,
    required this.pathname,
  });
  final int index;
  final String originalFilename;
  final String newFilename;
  final String pathname;

  factory HeHeAudio.fromJson(Map<String, dynamic> srcJson) =>
      _$HeHeAudioFromJson(srcJson);
  Map<String, dynamic> toJson() => _$HeHeAudioToJson(this);
  @override
  List<Object?> get props => [index, originalFilename, newFilename, pathname];
}
