/*
 * @Author: zqzhan
 * @Date: 2022-05-25 19:16:32
 * @LastEditors: zqzhan
 * @LastEditTime: 2022-05-25 19:17:00
 * @Description: 
 */
import 'package:assets_audio_player/assets_audio_player.dart';

class AudioUtils {
  final assetsAudioPlayer = AssetsAudioPlayer();

  // 播放音频
  Future<void> play(String fileName) async {
    assetsAudioPlayer.open(Audio('asset/audios/$fileName'));
    assetsAudioPlayer.play();
  }

  dispose() {
    assetsAudioPlayer.dispose();
  }
}

AudioUtils audioUtils = AudioUtils();
