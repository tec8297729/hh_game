import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'components/FlareRateController.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart' as vector;

class Home extends StatefulWidget {
  Home({Key key, this.params}) : super(key: key);
  final params;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  FlareRateController _flareRateController; // flr动画控制器
  double sliderValue = 0; // 当前滑动的值
  AnimationController _controller; // 表情整体动画控制器

  // 添加颜色区间值，flr动画依次0-1之间显示的颜色
  Animatable<Color> backgroundTween = TweenSequence<Color>([
    TweenSequenceItem(
      tween: ColorTween(
        begin: Color(0xFFFF0000),
        end: Color(0xFF70C100),
      ),
      weight: 1.0,
    ),
    TweenSequenceItem(
      tween: ColorTween(
        begin: Color(0xFF70C100),
        end: Color(0xFFFFFFFF),
      ),
      weight: 1.0,
    ),
    TweenSequenceItem(
      tween: ColorTween(
        begin: Color(0xFFFFFFFF),
        end: Color(0xFFFFFFFF),
      ),
      weight: 1.0,
    ),
    TweenSequenceItem(
      tween: ColorTween(
        begin: Color(0xFFFFFFFF),
        end: Color(0xFFF8ECBD),
      ),
      weight: 1.0,
    ),
    TweenSequenceItem(
      tween: ColorTween(
        begin: Color(0xFFF8ECBD),
        end: Color(0xFF20BEFD),
      ),
      weight: 1.0,
    ),
  ]);

  @override
  void initState() {
    super.initState();
    _flareRateController = FlareRateController();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 计算矩阵位置
  vector.Vector3 _shake() {
    double offest = math.sin(_controller.value * math.pi * 60);
    return vector.Vector3(offest * 2, offest * 2, 0.0);
  }

  // 更新表情状态效果
  void updateDragPos(double details) {
    setState(() {
      _flareRateController.updataPercent(details); // 更新flr动画
      // 指定范围振动
      if (details >= 0 && details < 0.3) {
        _controller.forward(from: 0);
      } else if (details >= 0.3 && details < 0.7) {
        _controller.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildFlareActor(),
          sliderWidget(),
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Text('jonhuu.com'),
          ),
          btnWidget('生气', 0), // 生气
          btnWidget('一般', 0.3), // 一般
          btnWidget('普通', 0.5), // 普通
          btnWidget('开心', 0.7), // 开心
          btnWidget('高兴', 1), // 高兴
        ],
      ),
    );
  }

  // 把flr包裹成圆脸蛋
  Widget _buildFlareActor() {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      child: Transform(
        transform: Matrix4.translation(_shake()), // 转换矩阵
        child: CircleAvatar(
          // 添加颜色，并且getPercent给的值是Flr当前动画的具体值0-1之间
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
    return Center(
      child: SizedBox(
        width: 500.w,
        height: 380.h,
        child: FlareActor(
          'asset/face.flr',
          artboard: 'Artboard', // 画板名称
          controller: _flareRateController,
        ),
      ),
    );
  }

  // 测试滑块
  Widget sliderWidget() {
    return Slider(
      value: sliderValue, // 当前拖动的值
      min: 0,
      max: 1,
      onChanged: (v) {
        setState(() {
          sliderValue = v;
          this.updateDragPos(v);
        });
      },
    );
  }

  // 按钮
  Widget btnWidget(String text, double sliderData) {
    return RaisedButton(
      child: Text(text),
      color:
          Colors.primaries[(sliderData * 30).toInt() % Colors.primaries.length],
      onPressed: () {
        this.updateDragPos(sliderData);
      },
    );
  }
}
