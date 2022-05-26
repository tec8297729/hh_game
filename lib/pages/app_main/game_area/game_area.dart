import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ele_box/ele_box.dart';
import '../face_widget/face_widget.dart';
import '../provider/home_store.p.dart';
import '../start_game_btn/start_game_btn.dart';

class GameArea extends StatefulWidget {
  const GameArea({Key? key}) : super(key: key);

  @override
  State<GameArea> createState() => _GameAreaState();
}

class _GameAreaState extends State<GameArea> {
  late HomeStore _appStore;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initGame();
    });
  }

  initGame() {
    _appStore.init(); // 初始监听
    Timer(const Duration(seconds: 6), () {
      _appStore.setGameState(true);
      _appStore.setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    _appStore = Provider.of<HomeStore>(context);
    return Scaffold(
      body: Container(
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
            StartGameBtn(),
          ],
        ),
      ),
    );
  }
}
