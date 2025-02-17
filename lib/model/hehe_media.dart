import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'hehe_media.g.dart';

@CopyWith()
@JsonSerializable(explicitToJson: true)
class HeHeMedia extends Equatable {
  const HeHeMedia({
    required this.name,
    this.audioId,
    this.videoId,
  });

  final String name;
  final String? audioId;
  final String? videoId;
  String? get imageUrl =>
      videoId != null ? 'https://lh3.googleusercontent.com/d/$videoId' : null;
  String? get audioUrl => audioId != null
      ? 'https://drive.usercontent.google.com/download?id=$audioId'
      : null;
  String? get videoUrl => videoId != null
      ? 'https://drive.usercontent.google.com/download?id=$videoId'
      : null;

  factory HeHeMedia.fromJson(Map<String, dynamic> srcJson) =>
      _$HeHeMediaFromJson(srcJson);
  Map<String, dynamic> toJson() => _$HeHeMediaToJson(this);
  @override
  List<Object?> get props => [
        name,
        audioId,
        videoId,
      ];
}
