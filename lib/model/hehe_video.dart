import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'hehe_video.g.dart';

@CopyWith()
@JsonSerializable(explicitToJson: true)
class HeHeVideo extends Equatable {
  const HeHeVideo({
    required this.name,
    required this.id,
  });

  final String name;
  final String id;
  String get imageUrl => 'https://lh3.googleusercontent.com/d/$id';
  String get videoUrl => 'https://drive.usercontent.google.com/download?id=$id';

  factory HeHeVideo.fromJson(Map<String, dynamic> srcJson) =>
      _$HeHeVideoFromJson(srcJson);
  Map<String, dynamic> toJson() => _$HeHeVideoToJson(this);
  @override
  List<Object?> get props => [
        id,
        name,
      ];
}
