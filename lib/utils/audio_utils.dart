import 'package:assets_audio_player/assets_audio_player.dart';

class AudioUtils {
  final assetsAudioPlayer = AssetsAudioPlayer();

  // 播放音频
  Future play(String fileName) async {
    assetsAudioPlayer.open(Audio('asset/audios/$fileName'));
    assetsAudioPlayer.play();
  }

  dispose() {
    assetsAudioPlayer.dispose();
  }
}

AudioUtils audioUtils = AudioUtils();
