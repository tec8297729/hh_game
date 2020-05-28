import 'package:flutter/material.dart';
import 'dart:math' as math;

class EleItemBox extends StatefulWidget {
  EleItemBox({@required this.index});
  final int index;
  @override
  _EleItemBoxState createState() => _EleItemBoxState();
}

class _EleItemBoxState extends State<EleItemBox>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..addListener(() => this.setState(() {})); // 监听动画变更，更新页面

    // 定义动画更新区间的值
    animation = Tween<double>(begin: 0, end: 360.0).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return animateBuild();
  }

  // 动画小部件
  Widget animateBuild() {
    return AnimatedBuilder(
      animation: animation, // 动画效果
      child: _eleBox(),
      builder: (BuildContext context, Widget child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0001) // 第三参数定义视图距离，值越小物体就离你越远，看着就有立体感
            // 旋转Y轴角度，pi为圆半径，animation.value为动态获取的动画值
            ..rotateY(math.pi * animation.value / 360),
          alignment: FractionalOffset.center, // 以轴中心开始动画
          child: animation.value < 180 ? maskEleBox() : child,
        );
      },
    );
  }

  void onClickEleBox() {
    if (animation.value < 360) {
      controller.forward();
      return;
    }
    controller.reverse(from: 360);
  }

  Widget maskEleBox() {
    return GestureDetector(
      onTap: onClickEleBox,
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/eleItem/elebg.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _eleBox() {
    return GestureDetector(
      // 点击事件
      onTap: onClickEleBox,
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/eleItem/${widget.index}.png'), // 动态图片，添加部份
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
