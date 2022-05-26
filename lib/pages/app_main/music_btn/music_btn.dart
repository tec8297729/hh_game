import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class MusicBtn extends StatefulWidget {
  const MusicBtn({Key? key}) : super(key: key);

  @override
  State<MusicBtn> createState() => _MusicBtnState();
}

class _MusicBtnState extends State<MusicBtn> with WidgetsBindingObserver {
  bool musicFlag = true; // 音乐状态 true开, false关
  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initMusic();
  }

  /// 初始化音乐
  initMusic() {
    assetsAudioPlayer.open(
      Audio('asset/audios/bg.mp3'),
      loopMode: LoopMode.playlist,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  // 在热重载(hot reload)时会被调用
  @override
  void reassemble() {
    assetsAudioPlayer.dispose();
    super.reassemble();
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
}
