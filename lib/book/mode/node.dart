import 'package:json_annotation/json_annotation.dart';
part 'node.g.dart';

@JsonSerializable()
class Node{

  Node(this.id,this.parentId,this.type,this.name,this.leaf,this.children,this.index);

   String id;
   String parentId;
   String type;
   String name;
   bool leaf;
   List<Node> children;
   int ?index;

  factory Node.fromJson(Map<String, dynamic> json) => _$NodeFromJson(json);
  Map<String, dynamic> toJson() => _$NodeToJson(this);
}