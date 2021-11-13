// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Node _$NodeFromJson(Map<String, dynamic> json) => Node(
      json['id'] as String,
      json['parentId'] as String,
      json['type'] as String,
      json['name'] as String,
      json['leaf'] as bool,
      (json['children'] as List<dynamic>)
          .map((e) => Node.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['index'] as int?,
    );

Map<String, dynamic> _$NodeToJson(Node instance) => <String, dynamic>{
      'id': instance.id,
      'parentId': instance.parentId,
      'type': instance.type,
      'name': instance.name,
      'leaf': instance.leaf,
      'children': instance.children,
      'index': instance.index,
    };
