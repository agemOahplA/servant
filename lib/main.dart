import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:servant/book/mode/node.dart';
import 'book/catholic_catechism_view.dart';
import 'model/everyday.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '日课',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '目录'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Everyday> everydayData = [];

  final List<TreeNode> treeNodes = [];

  final TreeController _controller = TreeController(allNodesExpanded: true);

  void getEveryday() async {
    try {
      var response = await Dio().get('http://127.0.0.1:8080/everyday');
      List<dynamic> data = response.data;
      for (var element in data) {
        Everyday data = Everyday.fromJson(element);
        everydayData.add(data);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    getCatholicCatechism();

    _controller.collapseAll();

    _controller.expandNode(const ValueKey("0"));
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(children: <Widget>[
        ElevatedButton(
          child: const Text("天主教教理"),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const CatholicCatechismView()))
        ),
      ])
    );
  }

  Widget buildTree() {
    print(treeNodes.length);
    return TreeView(treeController:_controller ,nodes: treeNodes);
  }


  List<TreeNode> toTreeNodes(List<Node> nodes){
    List<TreeNode> list = [];
    for (var element in nodes) {
      if(!element.leaf){
        TreeNode treeNode = TreeNode(key:Key(element.id),
            children: toTreeNodes(element.children),
            content: GestureDetector(child: Text(element.name),
            onTap:()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=> EverydayDetail(title: element.name,html: element.id)))
        )
        );

        list.add(treeNode);
      }
    }
    return list;
  }

  void getCatholicCatechism() async {

    String jsonString = await rootBundle.loadString("assets/catholicCatechism.json");
    final jsonResult = json.decode(jsonString);
    Node node = Node.fromJson(jsonResult);
    TreeNode root = TreeNode(key: Key(node.id),children: toTreeNodes(node.children),
                                        content: Text(node.name),
                            );
    if(treeNodes.length==1){
      treeNodes.clear();
    }
    treeNodes.add(root);
  }

  void detail(){

  }
}

class EverydaySub extends StatelessWidget{

  final Everyday everyday;

  const EverydaySub({Key? key, required this.everyday}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(everyday.date),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            ListTile(title:const Text('礼仪'),
              onTap: ()=>
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=> EverydayDetail(title: '礼仪',html: everyday.etiquette))),
            ),
            ListTile(title:const Text('诵读'),
              onTap: ()=>
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=> EverydayDetail(title: '诵读',html: everyday.recite))),
            ),
            ListTile(title:const Text('弥撒'),
              onTap: ()=>
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=> EverydayDetail(title: '弥撒',html: everyday.mass))),
            ),
            ListTile(title:const Text('圣人'),
              onTap: ()=>
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=> EverydayDetail(title: '圣人',html: everyday.saint))),
            ),
            ListTile(title:const Text('晨祷'),
              onTap: ()=>
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=> EverydayDetail(title: '晨祷',html: everyday.morningPrayer))),
            ),
            ListTile(title:const Text('日祷'),
              onTap: ()=>
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=> EverydayDetail(title: '日祷',html: everyday.dayPrayer))),
            ),
            ListTile(title:const Text('晚祷'),
              onTap: ()=>
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=> EverydayDetail(title: '晚祷',html: everyday.eveningPrayer))),
            ),
            ListTile(title:const Text('夜祷'),
              onTap: ()=>
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=> EverydayDetail(title: '夜祷',html: everyday.nightPrayer))),
            ),
          ],
        ),
      ),
    );
  }

}

class EverydayDetail extends StatelessWidget{

  const EverydayDetail({Key? key, required this.title, required this.html}) : super(key: key);

  final String title;

  final String html;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child:Html(
                  // 渲染错误 替换
                  data: html.replaceAll("font: 12pt/18pt Georgia,\'新细明体\'", ""),
                )
          )
//         body: ListView(
//           children: const <Widget>[
//             ListTile(title:Text("""
//             第一條
//             """)),
//             ListTile(title:Text("""
//             天主的啟示
//             """)),
//             ListTile(title:Text("""
//             一、天主啟示祂「慈愛的計畫」
//             """)),
//             ListTile(title:Text("""50. 人藉著自然的理智，能從天主的工程確實地認識天主。然而有另一種
// 知識領域，人只憑己力是絕不能達到的，那就是天主的啟示。天主藉
// 著完全自由的決定，把自己啟示並賞賜給人，透露祂的奧秘和祂自太
// 初就在基督內預定的造福人類的慈愛計畫。祂派遣了祂的愛子、我們
// 的主耶穌基督和聖神，把祂的計畫完全啟示出來。""")),
//             ListTile(title:Text("""50. 人藉著自然的理智，能從天主的工程確實地認識天主。然而有另一種
//         知識領域，人只憑己力是絕不能達到的，那就是天主的啟示。天主藉
//         著完全自由的決定，把自己啟示並賞賜給人，透露祂的奧秘和祂自太
//         初就在基督內預定的造福人類的慈愛計畫。祂派遣了祂的愛子、我們
//         的主耶穌基督和聖神，把祂的計畫完全啟示出來。""")),
//             ListTile(title:Text("""51. 「天主因著祂的仁愛和智慧，將自己啟示給人，為使人認識祂旨意的
//         奧秘。於是，人類藉著降生成人的聖言基督，在聖神內達到天父，分
//         享天主的本性」。""")),
//             ListTile(title:Text("""52. 「住在不可接近的光中」的天主(弟前 6:16)，願意通傳祂的神性生命
//         給祂自由創造的人，使他們在祂唯一的聖子內，成為義子。天主把自
//         己啟示出來，是為使人有能力去回應、認識、和愛慕祂，遠勝過他們
//         本身所能做到的。""")),
//           ],
//         )
    );
  }
}