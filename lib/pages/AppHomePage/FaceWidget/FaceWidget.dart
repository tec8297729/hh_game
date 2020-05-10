import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:hh_game/config/app_config.dart';
import 'package:hh_game/pages/AppHomePage/FaceWidget/components/SliderColors.dart';
import '../provider/appHomePageStore.p.dart';
import 'components/FlareController.dart';
import 'components/SliderPainter.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart' as vector;

class FaceWidget extends StatefulWidget {
  FaceWidget({Key key, @required this.sliderStatus}) : super(key: key);
  final SliderState sliderStatus;
  @override
  _FaceWidgetState createState() => _FaceWidgetState();
}

class _FaceWidgetState extends State<FaceWidget>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;
  double sliderWidth = 340;
  double sliderHeight = 50;
  FlareRateController _flareRateController; // flr动画控制器
  AnimationController _controller;
  double _dragPercent = 0.0;

  @override
  void initState() {
    super.initState();
    _flareRateController = FlareRateController();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
    )..addListener(() => setState(() {}));
    upSliderState();
  }

  @override
  void didUpdateWidget(FaceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    upSliderState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 调试--更新表情状态
  void updateDragPos(details) {
    RenderBox box = context.findRenderObject();
    Offset localOffset = box.localToGlobal(details.localPosition);
    setState(() {
      _dragPercent = (localOffset.dx / sliderWidth).clamp(0.0, 1.0);
      _flareRateController.updataPercent(_dragPercent); // 更新flr动画
      if (_dragPercent >= 0 && _dragPercent < 0.3) {
        _controller.forward(from: 0);
      } else if (_dragPercent >= 0.3 && _dragPercent < 0.7) {
        _controller.stop();
      }
    });
  }

  // 计算矩阵位置
  vector.Vector3 _shake() {
    double offest = math.sin(_controller.value * math.pi * 60);
    return vector.Vector3(offest * 2, offest * 2, 0.0);
  }

  /// 更新表情状态
  void upSliderState() {
    switch (widget.sliderStatus) {
      case SliderState.bad:
        _flareRateController.updataPercent(0.0);
        _controller.forward(from: 0);
        break;
      case SliderState.reluctantly:
        _flareRateController.updataPercent(0.27);
        _controller.forward(from: 0.3);
        break;
      case SliderState.normal:
        _flareRateController.updataPercent(0.478);
        // _flareRateController.updataPercent(0.43);
        break;
      case SliderState.notBad:
        _flareRateController.updataPercent(0.75);
        break;
      default:
        _flareRateController.updataPercent(1.0); // 更新flr动画
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      margin: EdgeInsets.only(top: 30.h),
      child: Column(
        children: <Widget>[
          _buildFlareActor(),
          if (AppConfig.DEBUG) _buildSlider(),
        ],
      ),
    );
  }

  _buildFlareActor() {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      child: Transform(
        transform: Matrix4.translation(_shake()), // 转换矩阵
        child: CircleAvatar(
          backgroundColor: backgroundTween.evaluate(
            AlwaysStoppedAnimation(_flareRateController.getPercent),
          ),
          child: faceFLr(),
          radius: 150.w,
        ),
      ),
    );
  }

  // 表情
  Widget faceFLr() {
    return SizedBox(
      width: 1100.w,
      height: 680.h,
      child: FlareActor(
        'asset/face.flr',
        artboard: 'Artboard',
        controller: _flareRateController,
      ),
    );
  }

  // 指示条
  _buildSlider() {
    return GestureDetector(
      onHorizontalDragStart: (details) => this.updateDragPos(details),
      onHorizontalDragUpdate: (details) => this.updateDragPos(details),
      child: Container(
        width: sliderWidth,
        height: sliderHeight,
        child: CustomPaint(
          painter: SliderPainter(progress: _dragPercent),
        ),
      ),
    );
  }
}
