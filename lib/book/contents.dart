
import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';

class Contents extends StatelessWidget{
  const Contents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}

class ContentsPage extends StatefulWidget{
  const ContentsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState()=>_ContentsPageState();

}

class _ContentsPageState extends State<ContentsPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("目录"),),
      body: const Center(
        child: Text("1111")//buildTree(),
      ),
    );

      buildTree();
  }

  Widget buildTree() {
    return TreeView(nodes: toTreeNodes());
  }


  List<TreeNode> toTreeNodes(){
    return [TreeNode(content: const Text("1231231"))];
  }
}