// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'everyday.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Everyday _$EverydayFromJson(Map<String, dynamic> json) => Everyday(
      json['date'] as String,
      json['etiquette'] as String,
      json['saint'] as String,
      json['mass'] as String,
      json['recite'] as String,
      json['morningPrayer'] as String,
      json['dayPrayer'] as String,
      json['eveningPrayer'] as String,
      json['nightPrayer'] as String,
    );

Map<String, dynamic> _$EverydayToJson(Everyday instance) => <String, dynamic>{
      'date': instance.date,
      'etiquette': instance.etiquette,
      'saint': instance.saint,
      'mass': instance.mass,
      'recite': instance.recite,
      'morningPrayer': instance.morningPrayer,
      'dayPrayer': instance.dayPrayer,
      'eveningPrayer': instance.eveningPrayer,
      'nightPrayer': instance.nightPrayer,
    };
