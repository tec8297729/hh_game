import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SliderPainter extends CustomPainter {
  SliderPainter({this.progress});
  double progress; // 移动的位置

  @override
  void paint(Canvas canvas, Size size) {
    double trackHeight = 1.0;
    double thunbRadius = 28; // 线边距
    // 单条线--画板属性定义
    var trackPaint = Paint()
      ..color = Colors.black26
      ..strokeWidth = 1.0;

    var thunbPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke // 样式
      ..strokeWidth = 5.0;

    // 画矩形，单线
    canvas.drawRect(
        Rect.fromLTWH(thunbRadius, (size.height - trackHeight) / 2,
            size.width - thunbRadius * 2, trackHeight),
        trackPaint);

    // 画圆点(圆的位置，圆半径，paint画布属性)
    canvas.drawCircle(
      Offset(
        thunbRadius + (size.width - thunbRadius * 2) * progress,
        (size.height - trackHeight) / 2,
      ),
      5,
      Paint()..color = Colors.black,
    );

    // 画矩形
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          (size.width - thunbRadius * 2) * progress,
          (size.height / 2) - thunbRadius,
          thunbRadius * 2,
          thunbRadius * 2,
        ),
        Radius.circular(16), // 圆度
      ),
      thunbPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
