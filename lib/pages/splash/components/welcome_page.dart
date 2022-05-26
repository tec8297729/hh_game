import 'package:flutter/material.dart';
import '../../../routes/route_name.dart';

/// 指引页面
class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final String _info = '引导页～';

  @override
  void initState() {
    super.initState();
    _initBanner();
  }

  /// App引导页逻辑。
  void _initBanner() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(_info),
          ),
        ],
      ),
      // 欢迎页测试按钮，手动跳转
      floatingActionButton: FloatingActionButton(
        heroTag: 'welcomBtn',
        child: const Icon(Icons.navigate_next),
        onPressed: () {
          Navigator.pushReplacementNamed(context, RouteName.appMain);
        },
      ),
    );
  }
}
