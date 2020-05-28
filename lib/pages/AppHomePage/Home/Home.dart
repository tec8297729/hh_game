import 'package:flutter/material.dart';
import 'components/EleItemBox.dart';
import 'dart:math' as math;

class Home extends StatefulWidget {
  Home({Key key, this.params}) : super(key: key);
  final params;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          child: gridBody(),
        ),
      ),
    );
  }

  Widget gridBody() {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(), // 禁止滚动
      padding: EdgeInsets.all(0),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 80.0, // 每个元素的宽度
        mainAxisSpacing: 2, // 每个元素底部间隔
        crossAxisSpacing: 2,
      ),
      itemCount: 16, // 总数量
      itemBuilder: (context, int index) {
        // 封装的eleBox组件
        return EleItemBox(
          index: math.Random().nextInt(5), // 随机0-5之间的值，动态显示不同图片
        );
      },
    );
  }
}
