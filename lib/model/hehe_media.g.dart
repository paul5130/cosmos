// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hehe_media.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HeHeMediaCWProxy {
  HeHeMedia name(String name);

  HeHeMedia audioId(String? audioId);

  HeHeMedia videoId(String? videoId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HeHeMedia(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HeHeMedia(...).copyWith(id: 12, name: "My name")
  /// ````
  HeHeMedia call({
    String name,
    String? audioId,
    String? videoId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHeHeMedia.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHeHeMedia.copyWith.fieldName(...)`
class _$HeHeMediaCWProxyImpl implements _$HeHeMediaCWProxy {
  const _$HeHeMediaCWProxyImpl(this._value);

  final HeHeMedia _value;

  @override
  HeHeMedia name(String name) => this(name: name);

  @override
  HeHeMedia audioId(String? audioId) => this(audioId: audioId);

  @override
  HeHeMedia videoId(String? videoId) => this(videoId: videoId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HeHeMedia(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HeHeMedia(...).copyWith(id: 12, name: "My name")
  /// ````
  HeHeMedia call({
    Object? name = const $CopyWithPlaceholder(),
    Object? audioId = const $CopyWithPlaceholder(),
    Object? videoId = const $CopyWithPlaceholder(),
  }) {
    return HeHeMedia(
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      audioId: audioId == const $CopyWithPlaceholder()
          ? _value.audioId
          // ignore: cast_nullable_to_non_nullable
          : audioId as String?,
      videoId: videoId == const $CopyWithPlaceholder()
          ? _value.videoId
          // ignore: cast_nullable_to_non_nullable
          : videoId as String?,
    );
  }
}

extension $HeHeMediaCopyWith on HeHeMedia {
  /// Returns a callable class that can be used as follows: `instanceOfHeHeMedia.copyWith(...)` or like so:`instanceOfHeHeMedia.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HeHeMediaCWProxy get copyWith => _$HeHeMediaCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HeHeMedia _$HeHeMediaFromJson(Map<String, dynamic> json) => HeHeMedia(
      name: json['name'] as String,
      audioId: json['audioId'] as String?,
      videoId: json['videoId'] as String?,
    );

Map<String, dynamic> _$HeHeMediaToJson(HeHeMedia instance) => <String, dynamic>{
      'name': instance.name,
      'audioId': instance.audioId,
      'videoId': instance.videoId,
    };
