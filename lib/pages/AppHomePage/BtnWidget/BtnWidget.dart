import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hh_game/pages/AppHomePage/provider/appHomePageStore.p.dart';
import 'package:hh_game/utils/audio_utils.dart';
import 'package:hh_game/utils/util.dart';
import 'package:provider/provider.dart';

class BtnWidget extends StatefulWidget {
  @override
  _BtnWidgetState createState() => _BtnWidgetState();
}

class _BtnWidgetState extends State<BtnWidget>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  String btnText = '开始游戏';
  AppHomePageStore _appStore;
  int btnImg = Util.randomFn(3);
  bool clickFlag = false; // true禁用点击动画

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
    animation = Tween(begin: 1.0, end: 0.7).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// 点击事件
  onClickBtn() async {
    clickFlag = true;
    audioUtils.play('unbelievable.mp3');
    await _appStore.restGame();
    setState(() {
      btnText = '重新开始';
      clickFlag = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _appStore = Provider.of<AppHomePageStore>(context);
    return Container(
      margin: EdgeInsets.only(top: 100.w),
      child: animateWrap(),
    );
  }

  Widget animateWrap() {
    return AnimatedBuilder(
      animation: animation,
      child: btnBg(),
      builder: (BuildContext context, Widget child) {
        return ScaleTransition(
          alignment: Alignment.center,
          scale: animation,
          child: child,
        );
      },
    );
  }

  Widget btnBg() {
    return GestureDetector(
      onTapUp: (e) async {
        if (clickFlag) return;
        await controller.forward(from: 0);
        await controller.reverse();
        await onClickBtn();
      },
      onLongPress: () {
        if (clickFlag) return;
        controller.forward(from: 0);
      },
      onLongPressUp: () async {
        if (clickFlag) return;
        controller.reverse();
        await onClickBtn();
      },
      child: Container(
        alignment: Alignment.center,
        width: 320.w,
        height: 110.w,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/btn/$btnImg.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Text(
          btnText,
          style: TextStyle(
            fontFamily: 'Fish',
            fontSize: 46.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
