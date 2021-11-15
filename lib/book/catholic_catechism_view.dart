

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:servant/book/mode/node.dart';
import 'package:flutter/services.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'dart:math';

class CatholicCatechismView extends StatefulWidget{
  const CatholicCatechismView({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState()=>_CatholicCatechismViewState();
}

class _CatholicCatechismViewState extends State<CatholicCatechismView> {

  List<Entry> entryList = [];

  Map<String,Node> dataMap = {};

  List<Node> dataList = [];

  @override
  void initState() {
    super.initState();
    getCatholicCatechismJSON();

    SchedulerBinding.instance!.addPostFrameCallback((_) => {
    });

  }

  @override
  Widget build(BuildContext context) {
    // _controller.collapseAll();
    // Scaffold 是 Material 库中提供的页面脚手架，
    // 它提供了默认的导航栏、标题和包含主屏幕 widget 树（后同“组件树”或“部件树”）的body属性，
    // 组件树可以很复杂。本书后面示例中，路由默认都是通过Scaffold创建。
    return Scaffold(
        appBar: AppBar(
          title: const Text('天主教教理'),
        ),
        body: ListView.builder(itemCount: entryList.length,
        itemBuilder: (BuildContext context,int index)=>_buildEntry(entryList[index])),
      // backgroundColor: Colors.white70,

    );
  }
  // 将Node转换成TreeNode
  List<Entry> toEntry(List<Node> nodes){
    List<Entry> list = [];
    for (var element in nodes) {
      var node = Node(element.id, element.parentId, element.type, element.name, element.leaf, [],dataList.length);
      dataMap[element.id] = node;
      dataList.add(node);
      if(!element.leaf){
        list.add(Entry(parentId: element.parentId, id: element.id, type: element.type, title: GestureDetector(child: Text(element.name,textScaleFactor: 1),
            onTap:()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ScrollablePositionedListPage(title: element.name, id: element.id, dataMap:dataMap, dataList: dataList,))).then((value) => {
              print('返回$value'),
              print('展开')

            })
        ),children: toEntry(element.children)));
      }
    }
    return list;
  }
  // 读取json文件
  void getCatholicCatechismJSON() async {
    String jsonString = await rootBundle.loadString("assets/catholicCatechism.json");
    final jsonResult = json.decode(jsonString);
    Node node = Node.fromJson(jsonResult);
    // 通知 Flutter 框架，有状态发生了改变，Flutter 框架收到通知后，会执行 build 方法来根据新的状态重新构建界面
    setState((){
      entryList = toEntry(node.children);
    });
  }

  Widget _buildEntry(Entry root){

    if(root.children!.isEmpty){
      return ListTile(title:
      Padding(padding: const EdgeInsets.all(20),
          child: root.title)
      );
    }

    return ExpansionTile(key: PageStorageKey<Entry>(root), title: Padding(padding: const EdgeInsets.all(20),
        child: root.title),
      children: root.children!.map<Widget>(_buildEntry).toList(),
      backgroundColor: Colors.amberAccent,
    );

  }

}

class Entry {
  final Widget title;
  final List<Entry>? children;
  String parentId;
  String type;
  String id;

  Entry({required this.parentId,required this.id,required this.type,required this.title,this.children});
}


const scrollDuration = Duration(seconds: 2);

class ScrollablePositionedListPage extends StatefulWidget {
  const ScrollablePositionedListPage({Key? key, required this.title, required this.id,required this.dataMap,required this.dataList}) : super(key: key);
  final Map<String,Node> dataMap;
  final List<Node> dataList;
  final String title;
  final String id;

  @override
  _ScrollablePositionedListPageState createState() =>
      _ScrollablePositionedListPageState();
}

class _ScrollablePositionedListPageState
    extends State<ScrollablePositionedListPage> {
  /// Controller to scroll or jump to a particular item.
  final ItemScrollController itemScrollController = ItemScrollController();

  /// Listener that reports the position of items when the list is scrolled.
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  late List<Color> itemColors;
  bool reversed = false;

  /// The alignment to be used next time the user scrolls or jumps to an item.
  double alignment = 0;

  String appBarTitle = '';

  String chapterId = '';

  @override

  void initState() {
    super.initState();

    appBarTitle = widget.title;

    final heightGenerator = Random(328902348);
    final colorGenerator = Random(42490823);

    // itemHeights = List<double>.generate(
    //     numberOfItems,
    //         (int _) =>
    //     heightGenerator.nextDouble() * (maxItemHeight - minItemHeight) +
    //         minItemHeight);
    // itemColors = List<Color>.generate(widget.dataList.length,
            // (int _) => Color(colorGenerator.nextInt(randomMax)).withOpacity(1));

    // addPostFrameCallback 是 StatefulWidget 渲染结束的回调，只会被调用一次，之后 StatefulWidget 需要刷新 UI 也不会被调用
    SchedulerBinding.instance!.addPostFrameCallback((_) => {
      // 跳转到指定位置
      jumpTo(widget.dataMap[widget.id]!.index??0),
      listener()
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () async{
                String id = await showSearch(context: context, delegate: CustomSearchDelegate(dataList: widget.dataList));
                jumpTo(widget.dataMap[id]!.index??0);
              },
            )
          ],
          leading: IconButton(icon: const Icon(Icons.arrow_back),onPressed: (){
            Navigator.of(context).pop(chapterId);
          }),
        ),
        body: OrientationBuilder(
          builder: (context, orientation) => Column(
            children: <Widget>[
              Expanded(
                child: list(orientation),
              ),
            ],
          ),
        )
    );
  }


  Widget get alignmentControl => Row(
    mainAxisSize: MainAxisSize.max,
    children: <Widget>[
      const Text('Alignment: '),
      SizedBox(
        width: 200,
        child: SliderTheme(
          data: const SliderThemeData(
            showValueIndicator: ShowValueIndicator.always,
          ),
          child: Slider(
            value: alignment,
            label: alignment.toStringAsFixed(2),
            onChanged: (double value) => setState(() => alignment = value),
          ),
        ),
      ),
    ],
  );

  // 列表渲染
  Widget list(Orientation orientation) => ScrollablePositionedList.builder(
    itemCount: widget.dataList.length,
    itemBuilder: (context, index) => item(index, orientation),
    itemScrollController: itemScrollController,
    itemPositionsListener: itemPositionsListener,
    reverse: reversed,
    scrollDirection: orientation == Orientation.portrait
        ? Axis.vertical
        : Axis.horizontal,
  );


  void scrollTo(int index) => itemScrollController.scrollTo(
      index: index,
      duration: scrollDuration,
      curve: Curves.easeInOutCubic,
      alignment: alignment);

  void jumpTo(int index) =>
      itemScrollController.jumpTo(index: index, alignment: alignment);

  void listener()=>itemPositionsListener.itemPositions.addListener(() {

    // 更新 appBarTitle
    if (itemPositionsListener.itemPositions.value.isNotEmpty) {
      setState(() {
        Node ?node = widget.dataMap[widget.dataList[itemPositionsListener.itemPositions.value.first.index].parentId];
        if(node != null && node.type == 'chapter'){
          chapterId = node.id;
          appBarTitle = node.name;
        }

      });
    }


  });

  /// Generate item number [i].
  Widget item(int i, Orientation orientation) {
    return SizedBox(
      // height: orientation == Orientation.portrait ? itemHeights[i] : null,
      // width: orientation == Orientation.landscape ? itemHeights[i] : null,
      child: Container(
        // color: itemColors[i],
        child: Center(
          child: customContent(widget.dataList[i]),
        ),
      ),
    );
  }
  // 内容设置
  Widget customContent(Node node){
    // 字体大小
    double textScaleFactor= 1;
    // 距离 边界距离
    double all = 5.0;
    if(node.type == 'text'){

    }else if(node.type == 'sub-title'){
      textScaleFactor = 1;
      all = 5;
    }else if(node.type == 'title'){
      textScaleFactor = 1;
      all = 10;
    }else if(node.type == 'section'){
      textScaleFactor = 1.4;
    }else if(node.type == 'article'){
      textScaleFactor = 1.4;
      all = 16;
    }else if(node.type == 'chapter'){
      textScaleFactor = 1.6;
      all = 16;
    }else if(node.type == 'part'){
      textScaleFactor = 1.4;
      all = 16;
    }else if(node.type == 'volume'){
      textScaleFactor = 1.8;
      all = 16;
    }else if(node.type == 'preface'){
      textScaleFactor = 1.8;
    }

    return Padding(padding: EdgeInsets.all(all),
        child: Text(node.name,key:Key(node.id),textScaleFactor: textScaleFactor,textAlign: TextAlign.center));

  }
}

/// 搜索页面
class CustomSearchDelegate extends SearchDelegate{

  late final List<Node> dataList;

  CustomSearchDelegate({required this.dataList});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        if (query.isEmpty) {
          close(context, null);
        } else {
          query = "";
          showSuggestions(context);
        }
      },
    );
  }
  // 搜索返回匹配内容
  @override
  Widget buildResults(BuildContext context) {
    List<Widget> dataFilter = [];
    dataList.forEach((element) {
      // 匹配
      if(element.name.contains(query)){
        // 切割
        var split = element.name.split(query);
        // 匹配内容 关键字加样式
        dataFilter.add(ListTile(key: Key(element.id),title: Text.rich(TextSpan(
            children: [
              TextSpan(
                  text: split[0]
              ),
              TextSpan(
                text: query,
                style: TextStyle(
                    color: Colors.blue
                ),
              ),
              TextSpan(
                text: split[1],
              )
            ]
        )),
        onTap: (){
          // 点击选择的内容 回传参数
          close(context, element.id);
        },
        ));
      }
    });

    if(dataFilter.isNotEmpty){
      return ListView(
        children: dataFilter,
      );
    }else{
      return Center(child: Text('没有匹配内容'),);
    }

  }
  // 数据显示
  @override
  Widget buildSuggestions(BuildContext context) {
    // return ListView(
    //   children: <Widget>[
    //     for(var node in dataList)
    //       ListTile(title: Text(node.name))
    //   ],
    // );

    return Center(child: Text('全文搜索'),);
  }


}
