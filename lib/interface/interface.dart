import 'package:flutter/animation.dart';

/// 表情类型
enum SliderState { bad, reluctantly, normal, notBad, good }

/// 点击ele事件类型
class EleData {
  int index;
  int boxIdx; // 列表渲染索引
  bool isClick;
  AnimationController controller; // 控制器

  EleData({this.index, this.controller, this.boxIdx, this.isClick});
}
