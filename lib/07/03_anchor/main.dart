import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // debugShowMaterialGrid: true,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final List<int> data = List.generate(60, (index) => index + 1);

  @override
  Widget build(BuildContext context) {
    var impl = ConstainsImpl(true,true);
    impl.setData("你好");
    impl.setData("你不好");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Viewport#anchor 测试'),
      ),
      body: Scrollable(
        viewportBuilder: _buildViewPort,
      ),
    );
  }

  Widget _buildViewPort(BuildContext context, ViewportOffset position) {
    return Viewport(
      offset: position,
      anchor: 0.5,
      cacheExtent: 0.5,
      cacheExtentStyle:CacheExtentStyle.viewport, //缓存视口,配合cacheExtent使用,代表缓存半个视口
      slivers: [
        _buildSliverList()
      ],
    );
  }

  Widget _buildSliverList() {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
          _buildItemByIndex,
          childCount: data.length,
        ));
  }

  Widget _buildItemByIndex(BuildContext context, int index) {
    return ItemBox(
      index: data[index],
    );
  }
}

class ItemBox extends StatelessWidget {
  final int index;

  ItemBox({
    Key? key,
    required this.index,
  }) : super(key: key) {
    print('----构建ItemBox-----$index--------');
  }

  Color get color => Colors.blue.withOpacity((index % 10) * 0.1);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: color,
      height: 56,
      child: Text(
        '第 $index 个',
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}

@immutable
 abstract class Constanis{

  bool get name;

  bool get id;

  String? schoolName;

}

class ConstainsImpl extends Constanis{

  ConstainsImpl(this.hasAnimal,this.hasChild);

  void setData(String? data){
    schoolName = data;
    debugPrint("schoolName:${schoolName}");
  }
  @override
  bool get id => true;

  @override
  bool get name => false;

  bool ? hasAnimal = false;

  bool ? hasChild = false;

}