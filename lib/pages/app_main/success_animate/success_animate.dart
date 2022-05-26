import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hh_game/config/common_config.dart';
import 'package:hh_game/pages/app_main/provider/home_store.p.dart';
import 'package:hh_game/utils/audio_utils.dart';
import 'package:hh_game/interface/interface.dart' show SliderState;
import 'package:provider/provider.dart';

/// 显示成功动画
showSuccess() {
  showGeneralDialog(
    context: commonConfig.getGlobalContext,
    barrierLabel: "sussWidget",
    barrierColor: Colors.black38, // 遮罩层背景色
    barrierDismissible: false,
    transitionDuration: const Duration(milliseconds: 400),
    transitionBuilder: (context, animation1, animation2, Widget child) {
      return ScaleTransition(
        scale: Tween<double>(begin: 0, end: 1).animate(animation1),
        child: child,
      );
    },
    // 弹层显示的组件
    pageBuilder: (buildContext, animation, secondaryAnimation) {
      return SuccessAnimate();
    },
  );
}

class SuccessAnimate extends StatefulWidget {
  @override
  _SuccessAnimateState createState() => _SuccessAnimateState();
}

class _SuccessAnimateState extends State<SuccessAnimate> {
  double boxSize = 700.w;
  bool isBack = false;
  HomeStore? _appStore;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      audioUtils.play('good.mp3');
      _appStore?.saveSliderState(SliderState.good);
      Timer(const Duration(seconds: 3), () {
        Navigator.of(context).pop();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _appStore = Provider.of<HomeStore>(context);

    return WillPopScope(
      onWillPop: () async {
        return isBack;
      },
      child: Stack(
        children: <Widget>[
          _logSuss(),
        ],
      ),
    );
  }

  /// 成功图片组件
  Widget _logSuss() {
    return Positioned(
      top: (MediaQuery.of(context).size.height - boxSize) / 2,
      left: (MediaQuery.of(context).size.width - boxSize) / 2,
      child: Container(
        alignment: Alignment.center,
        height: boxSize,
        width: boxSize,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/bg/successful.png'),
          ),
        ),
      ),
    );
  }
}
