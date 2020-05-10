import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hh_game/pages/AppHomePage/EleBox/EleBox.dart';
import 'package:hh_game/utils/audio_utils.dart';
import 'package:jh_debug/jh_debug.dart';
import 'package:provider/provider.dart';
// import '../../components/UpdateAppVersion/UpdateAppVersion.dart'
//     show getNewAppVer;
import '../../components/DoubleBackExitApp/DoubleBackExitApp.dart';
import 'BtnWidget/BtnWidget.dart';
import 'FaceWidget/FaceWidget.dart';
import 'provider/appHomePageStore.p.dart';

class AppHomePage extends StatefulWidget {
  final params;

  AppHomePage({
    Key key,
    this.params,
  }) : super(key: key);

  @override
  _AppHomePageState createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> with WidgetsBindingObserver {
  AppHomePageStore _appStore;
  bool isTest = false;
  final assetsAudioPlayer = AssetsAudioPlayer();
  bool musicFlag = true; // 音乐状态 true开, false关
  bool loadFlag = true; // 初始化load

  @override
  void initState() {
    super.initState();
    initTools();
    assetsAudioPlayer.loop = true; // 重复
    SystemChrome.setEnabledSystemUIOverlays([]);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initPostFrameCallback();
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    audioUtils.dispose();
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  // 页面加载后执行
  initPostFrameCallback() {
    // if (AppConfig.showJhDebugBtn) {
    //   jhDebug.showDebugBtn(); // jhDebug 调试按钮
    // }
    _appStore.init(); // 初始监听
    assetsAudioPlayer.open(Audio('asset/audios/bg.mp3'));
    Timer(Duration(seconds: 2), () {
      setState(() {
        loadFlag = false;
      });
    });
  }

  /// 初始化第三方插件插件
  initTools() {
    jhDebug.init(
      context: context,
      btnTap1: () {},
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        playMusic();
        break;
      case AppLifecycleState.paused:
        stopMusic();
        break;
      default:
        stopMusic();
        break;
    }
  }

  /// 播放背景音乐
  playMusic() {
    assetsAudioPlayer.play();
  }

  /// 暂停背景音乐
  stopMusic() {
    assetsAudioPlayer.pause();
  }

  @override
  Widget build(BuildContext context) {
    // 初始化设计稿尺寸
    ScreenUtil.init(context, width: 1080, height: 2160, allowFontScaling: true);
    _appStore = Provider.of<AppHomePageStore>(context);
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          _bodyWidget(),
          _musictBtn(),
          _loadingWidget(),
          Positioned(
            bottom: 30,
            child: DoubleBackExitApp(),
          ),
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    return Scaffold(
      body: Consumer<AppHomePageStore>(
        child: Column(
          children: <Widget>[
            FaceWidget(sliderStatus: _appStore.getSliderState),
            EleBox(),
            // testBtn(),
            BtnWidget(),
          ],
        ),
        builder: (_, store, child) {
          return Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('asset/bg/${store.bgImgUrl}.jpg'), // 游戏背景
                fit: BoxFit.cover,
              ),
            ),
            child: child,
          );
        },
      ),
    );
  }

  // 音乐开关按钮
  Widget _musictBtn() {
    return Positioned(
      top: 160.w,
      right: 5.w,
      child: Container(
        width: 200.w,
        height: 120.w,
        child: Transform.rotate(
          angle: 11,
          child: Switch(
            value: musicFlag, // 是否选中, bool值
            activeColor: Colors.cyanAccent, // 选中状态颜色
            activeTrackColor: Colors.amber, // 选中时的线条颜色
            inactiveThumbColor: Colors.deepOrange, // 未选中圆点颜色
            inactiveTrackColor: Colors.black45, // 未选中时的线条颜色
            onChanged: (val) {
              setState(() {
                musicFlag = val;
                musicFlag ? playMusic() : stopMusic(); // 音乐状态
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _loadingWidget() {
    return Offstage(
      offstage: !loadFlag,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SpinKitWave(color: Colors.blue),
            Container(
              margin: EdgeInsets.only(top: 130.w),
              child: Text(
                '初始化加载中...',
                style: TextStyle(
                  fontFamily: 'Fish',
                  fontSize: 46.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget testBtn() {
    return FlatButton(
      onPressed: () {
        stopMusic();
      },
      child: Text(
        '内容',
        style: TextStyle(color: Colors.black, fontSize: 33),
      ),
    );
  }
}
