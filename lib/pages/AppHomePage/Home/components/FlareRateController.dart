import 'package:flare_flutter/flare.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'dart:math' as math;

// 实现控制器类中的具体方法
class FlareRateController extends FlareController {
  ActorAnimation _actorAnimation;
  double _slidePercent = 0.0;
  double _currentSlide = 0.0;
  double _snoothTine = 5.0;

  // 更新flr动画当前值
  void updataPercent(double val) {
    _slidePercent = val;
  }

  double get getPercent => _slidePercent;

  // 初始化
  @override
  void initialize(FlutterActorArtboard artboard) {
    // 判断flr画板的名称
    if (artboard.name.compareTo('Artboard') == 0) {
      _actorAnimation = artboard.getAnimation('slide'); // 获取动画的画板名称
    }
  }

  // 动画运行时持续触发函数
  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    // 判断flr画板的名称
    if (artboard.name.compareTo('Artboard') == 0) {
      _currentSlide +=
          (_slidePercent - _currentSlide) * math.min(1, elapsed * _snoothTine);
      // 指定动画当前时间，画板，最小值
      _actorAnimation.apply(
          _currentSlide * _actorAnimation.duration, artboard, 1);
    }
    return true;
  }

  @override
  void setViewTransform(Mat2D viewTransform) {}
}
