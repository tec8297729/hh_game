import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hh_game/pages/app_main/provider/home_store.p.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class EleItemBox extends StatefulWidget {
  const EleItemBox({required this.index, required this.boxIdx});
  final int index;
  final int boxIdx;
  @override
  _EleItemBoxState createState() => _EleItemBoxState();
}

class _EleItemBoxState extends State<EleItemBox>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<num> animation;
  late HomeStore appStore;
  double boxSize = 100.w;
  bool isEleBack = false;
  late EleData _eleData;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..addListener(() => setState(() {}));
    animation = Tween(begin: 0, end: 360.0).animate(controller);

    updataEleData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initAniShow();
      appStore.setEleBoxs(_eleData);
    });
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    updataEleData();
  }

  // 初始展示
  initAniShow() {
    Timer(const Duration(seconds: 2), () {
      controller.forward();
      Timer(const Duration(seconds: 2), () {
        controller.reset();
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// 更新当前值
  updataEleData() {
    _eleData = EleData(
      index: widget.index,
      boxIdx: widget.boxIdx,
      controller: controller,
      isClick: true,
    );
  }

  // 元素点击事件
  onClinckBox() {
    if (appStore.gameState) return; // 全局
    // 个体控制
    if (appStore.getEleBox(widget.boxIdx).isClick as bool) {
      setState(() {
        appStore.diffELe(_eleData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    appStore = Provider.of<HomeStore>(context);
    return Consumer<HomeStore>(
      builder: (_, store, __) {
        return animateBuild();
      },
    );
  }

  Widget animateBuild() {
    return AnimatedBuilder(
      animation: animation, // 定义动画效果
      child: _eleBox(),
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0001)
            ..rotateY(math.pi * animation.value / 360),
          alignment: FractionalOffset.center, // 对齐方式
          child: animation.value < 180 ? maskEleBox() : child,
        );
      },
    );
  }

  Widget maskEleBox() {
    return _eleBox(isBg: true);
  }

  Widget _eleBox({bool isBg = false}) {
    return GestureDetector(
      onTap: onClinckBox,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'asset/eleItem/${isBg ? 'elebg' : widget.index}.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
