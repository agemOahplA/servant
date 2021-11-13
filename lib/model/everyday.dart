import 'package:json_annotation/json_annotation.dart';
part 'everyday.g.dart';

@JsonSerializable()
class Everyday{

  Everyday(this.date,this.etiquette,this.saint,this.mass,this.recite,this.morningPrayer,this.dayPrayer,this.eveningPrayer,this.nightPrayer);

  // 日期
  String date;
  // 礼仪
  String etiquette;
  // 圣人
  String saint;
  // 弥撒
  String mass;
  // 涌祷
  String recite;
  // 晨祷
  String morningPrayer;
  // 日祷
  String dayPrayer;
  // 晚祷
  String eveningPrayer;
  // 夜祷
  String nightPrayer;

  factory Everyday.fromJson(Map<String, dynamic> json) => _$EverydayFromJson(json);
  Map<String, dynamic> toJson() => _$EverydayToJson(this);
}

