import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jh_debug/jh_debug.dart';
import 'package:provider/provider.dart';
import '../../routes/route_name.dart';
// import '../../components/update_app/check_app_version.dart'
//     show checkAppVersion;
import '../../config/app_env.dart' show appEnv, ENV_TYPE;
import '../../config/app_config.dart';
import '../../components/exit_app_interceptor/exit_app_interceptor.dart';
import '../../provider/global.p.dart';
import 'btn_widget/btn_widget.dart';
import 'ele_box/ele_box.dart';
import 'face_widget/face_widget.dart';
import 'provider/home_page_store.p.dart';

class AppMain extends StatefulWidget {
  final dynamic params;

  const AppMain({
    Key? key,
    this.params,
  }) : super(key: key);

  @override
  _AppMainState createState() => _AppMainState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('params', params));
  }
}

class _AppMainState extends State<AppMain>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  bool isTest = false;
  final assetsAudioPlayer = AssetsAudioPlayer();
  bool musicFlag = true; // 音乐状态 true开, false关
  bool loadFlag = true; // 初始化load
  late GlobalStore appPageStore;
  late AppHomePageStore _appStore;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    initTools();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (AppConfig.showJhDebugBtn) {
        jhDebug.showDebugBtn(); // jhDebug 调试按钮
      }
      initGame();
      // checkAppVersion(); // 更新APP版本检查

      /// 调试阶段，直接跳过此组件
      if (AppConfig.notSplash &&
          AppConfig.directPageName.isNotEmpty &&
          AppConfig.directPageName != RouteName.appMain) {
        Navigator.pushNamed(context, AppConfig.directPageName);
      }
    });
  }

  // 页面加载后执行
  initGame() {
    _appStore.init(); // 初始监听
    assetsAudioPlayer.open(Audio('asset/audios/bg.mp3'));
    Timer(const Duration(seconds: 6), () {
      _appStore.setGameState(true);
      setState(() {
        loadFlag = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    assetsAudioPlayer.dispose();
  }

  /// 初始化第三方插件插件
  initTools() {
    // jhDebug插件初始化
    jhDebug.init(
      context: context,
      btnTitle1: '开发',
      btnTap1: () {
        appEnv.setEnv = ENV_TYPE.DEV;
        AppConfig.host = appEnv.baseUrl;
      },
      btnTitle2: '调试',
      btnTap2: () {},
      btnTitle3: '生产',
      btnTap3: () {
        appEnv.setEnv = ENV_TYPE.PROD;
        AppConfig.host = appEnv.baseUrl;
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (musicFlag) playMusic();
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
    super.build(context);
    appPageStore = Provider.of<GlobalStore>(context);

    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        appPageStore.getGrayTheme
            ? const Color(0xff757575)
            : Colors.transparent,
        BlendMode.color,
      ),
      child: _scaffoldBody(),
    );
  }

  /// 页面Scaffold层组件
  Widget _scaffoldBody() {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          _bodyWidget(),
          _musictBtn(),
          _loadingWidget(),
          const Positioned(
            bottom: 30,
            child: ExitAppInterceptor(),
          ),
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    return Scaffold(
      body: ChangeNotifierProvider<AppHomePageStore>(
        create: (context) => AppHomePageStore(),
        builder: (_, child) {
          _appStore = Provider.of<AppHomePageStore>(_);

          return Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('asset/bg/${_appStore.bgImgUrl}.jpg'), // 游戏背景
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: <Widget>[
                FaceWidget(sliderStatus: _appStore.getSliderState),
                EleBox(),
                BtnWidget(),
              ],
            ),
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
      child: SizedBox(
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
            const SpinKitWave(color: Colors.blue),
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
}
