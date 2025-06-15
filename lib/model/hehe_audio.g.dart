// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hehe_audio.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HeHeAudioCWProxy {
  HeHeAudio index(int index);

  HeHeAudio originalFilename(String originalFilename);

  HeHeAudio newFilename(String newFilename);

  HeHeAudio pathname(String pathname);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HeHeAudio(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HeHeAudio(...).copyWith(id: 12, name: "My name")
  /// ````
  HeHeAudio call({
    int index,
    String originalFilename,
    String newFilename,
    String pathname,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHeHeAudio.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHeHeAudio.copyWith.fieldName(...)`
class _$HeHeAudioCWProxyImpl implements _$HeHeAudioCWProxy {
  const _$HeHeAudioCWProxyImpl(this._value);

  final HeHeAudio _value;

  @override
  HeHeAudio index(int index) => this(index: index);

  @override
  HeHeAudio originalFilename(String originalFilename) =>
      this(originalFilename: originalFilename);

  @override
  HeHeAudio newFilename(String newFilename) => this(newFilename: newFilename);

  @override
  HeHeAudio pathname(String pathname) => this(pathname: pathname);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HeHeAudio(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HeHeAudio(...).copyWith(id: 12, name: "My name")
  /// ````
  HeHeAudio call({
    Object? index = const $CopyWithPlaceholder(),
    Object? originalFilename = const $CopyWithPlaceholder(),
    Object? newFilename = const $CopyWithPlaceholder(),
    Object? pathname = const $CopyWithPlaceholder(),
  }) {
    return HeHeAudio(
      index: index == const $CopyWithPlaceholder()
          ? _value.index
          // ignore: cast_nullable_to_non_nullable
          : index as int,
      originalFilename: originalFilename == const $CopyWithPlaceholder()
          ? _value.originalFilename
          // ignore: cast_nullable_to_non_nullable
          : originalFilename as String,
      newFilename: newFilename == const $CopyWithPlaceholder()
          ? _value.newFilename
          // ignore: cast_nullable_to_non_nullable
          : newFilename as String,
      pathname: pathname == const $CopyWithPlaceholder()
          ? _value.pathname
          // ignore: cast_nullable_to_non_nullable
          : pathname as String,
    );
  }
}

extension $HeHeAudioCopyWith on HeHeAudio {
  /// Returns a callable class that can be used as follows: `instanceOfHeHeAudio.copyWith(...)` or like so:`instanceOfHeHeAudio.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HeHeAudioCWProxy get copyWith => _$HeHeAudioCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HeHeAudio _$HeHeAudioFromJson(Map<String, dynamic> json) => HeHeAudio(
      index: (json['index'] as num).toInt(),
      originalFilename: json['originalFilename'] as String,
      newFilename: json['newFilename'] as String,
      pathname: json['pathname'] as String,
    );

Map<String, dynamic> _$HeHeAudioToJson(HeHeAudio instance) => <String, dynamic>{
      'index': instance.index,
      'originalFilename': instance.originalFilename,
      'newFilename': instance.newFilename,
      'pathname': instance.pathname,
    };
