import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hh_game/pages/app_main/game_area/game_area.dart';
import 'package:hh_game/pages/app_main/loading/loading.dart';
import 'package:hh_game/pages/app_main/music_btn/music_btn.dart';
import 'package:jh_debug/jh_debug.dart';
import 'package:provider/provider.dart';
import '../../routes/route_name.dart';
// import '../../components/update_app/check_app_version.dart'
//     show checkAppVersion;
import '../../config/app_env.dart' show appEnv, ENV;
import '../../config/app_config.dart';
import '../../components/exit_app_interceptor/exit_app_interceptor.dart';
import '../../provider/global.p.dart';

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

class _AppMainState extends State<AppMain> with AutomaticKeepAliveClientMixin {
  late GlobalStore appPageStore;

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
      // checkAppVersion(); // 更新APP版本检查
      /// 调试阶段，直接跳过此组件
      if (AppConfig.notSplash &&
          AppConfig.directPageName.isNotEmpty &&
          AppConfig.directPageName != RouteName.appMain) {
        Navigator.pushNamed(context, AppConfig.directPageName);
      }
    });
  }

  /// 初始化第三方插件插件
  initTools() {
    // jhDebug插件初始化
    jhDebug.init(
      context: context,
      btnTitle1: '开发',
      btnTap1: () {
        appEnv.setEnv = ENV.DEV;
        AppConfig.host = appEnv.baseUrl;
      },
      btnTitle2: '调试',
      btnTap2: () {},
      btnTitle3: '生产',
      btnTap3: () {
        appEnv.setEnv = ENV.PROD;
        AppConfig.host = appEnv.baseUrl;
      },
    );
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
        children: const <Widget>[
          GameArea(),
          MusicBtn(), // 背景音乐组件
          Loading(), // 页面loading
          Positioned(
            bottom: 30,
            child: ExitAppInterceptor(),
          ),
        ],
      ),
    );
  }
}
