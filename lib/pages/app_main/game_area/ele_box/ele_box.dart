import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hh_game/pages/app_main/provider/home_store.p.dart';
import 'package:provider/provider.dart';

import 'components/eleItem_box.dart';

class EleBox extends StatefulWidget {
  @override
  _EleBoxState createState() => _EleBoxState();
}

class _EleBoxState extends State<EleBox> {
  late HomeStore appStore;
  double boxSize = 900.w;
  double gridSpacing = 2.w;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initRandomEleBox();
    });
  }

  // 随机初始化对对乐
  void initRandomEleBox() {
    Timer(const Duration(seconds: 5), () {
      setState(() {
        appStore.setAnswerList();
        appStore.setGameState(false); // 开始游戏
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    appStore = Provider.of<HomeStore>(context);
    return Container(
      width: boxSize,
      height: boxSize,
      margin: EdgeInsets.only(top: 130.h),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            offset: Offset(12.0, 12.0),
            blurRadius: 4.0,
          )
        ],
      ),
      child: gridBody(),
    );
  }

  Widget gridBody() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(), // 禁止滚动
      padding: const EdgeInsets.all(0),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 230.0.w, // 每个元素的宽度
        mainAxisSpacing: gridSpacing, // 每个元素底部间隔
        crossAxisSpacing: gridSpacing,
      ),
      itemCount: 16, // 总数量
      itemBuilder: (context, int index) {
        return EleItemBox(
          index: appStore.answerList[index % 8],
          boxIdx: index,
        );
      },
    );
  }
}
