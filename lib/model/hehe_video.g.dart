// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hehe_video.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HeHeVideoCWProxy {
  HeHeVideo name(String name);

  HeHeVideo id(String id);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HeHeVideo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HeHeVideo(...).copyWith(id: 12, name: "My name")
  /// ````
  HeHeVideo call({
    String name,
    String id,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHeHeVideo.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHeHeVideo.copyWith.fieldName(...)`
class _$HeHeVideoCWProxyImpl implements _$HeHeVideoCWProxy {
  const _$HeHeVideoCWProxyImpl(this._value);

  final HeHeVideo _value;

  @override
  HeHeVideo name(String name) => this(name: name);

  @override
  HeHeVideo id(String id) => this(id: id);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HeHeVideo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HeHeVideo(...).copyWith(id: 12, name: "My name")
  /// ````
  HeHeVideo call({
    Object? name = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
  }) {
    return HeHeVideo(
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
    );
  }
}

extension $HeHeVideoCopyWith on HeHeVideo {
  /// Returns a callable class that can be used as follows: `instanceOfHeHeVideo.copyWith(...)` or like so:`instanceOfHeHeVideo.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HeHeVideoCWProxy get copyWith => _$HeHeVideoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HeHeVideo _$HeHeVideoFromJson(Map<String, dynamic> json) => HeHeVideo(
      name: json['name'] as String,
      id: json['id'] as String,
    );

Map<String, dynamic> _$HeHeVideoToJson(HeHeVideo instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
    };
