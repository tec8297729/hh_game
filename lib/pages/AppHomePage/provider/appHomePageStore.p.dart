import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hh_game/interface/interface.dart';
import 'package:hh_game/pages/AppHomePage/SuccessAnimate/SuccessAnimate.dart';
import 'package:hh_game/utils/audio_utils.dart';
import 'package:hh_game/utils/util.dart';
export 'package:hh_game/interface/interface.dart';

class AppHomePageStore extends ChangeNotifier {
  SliderState _sliderState = SliderState.normal; // 表情状态
  bool _gameStop = true;
  List<int> _answerList = [0, 1, 2, 3, 4, 5, 2, 3]; // 渲染块数据
  int _userSuccess = 0;
  List<EleData> _eleBoxs = List(16); // 块item元素信息
  List<EleData> _loopEleData = [];
  StreamController<EleData> _eleStrem = StreamController<EleData>();
  int bgImgUrl = Util.randomFn(6); // 游戏背景

  void init() {
    _eleStrem.stream.listen((EleData eleData) async {
      eleData.controller.forward(); // 翻开动画
      _loopEleData.add(eleData);
      if (_loopEleData.length < 2) {
        saveSliderState(SliderState.normal);
        return;
      }

      setGameState(true);
      int len = _loopEleData.length;
      EleData currData = _loopEleData[len - 1];
      EleData lastData = _loopEleData[len - 2] ?? EleData();
      List<EleData> delList = [];
      bool sliderStatusBadFlag = false; // 表情控制

      for (var i = 0; i < len; i++) {
        if (i.isOdd) {
          currData = _loopEleData[i];
          lastData = _loopEleData[i - 1];
          if (currData.index == lastData.index) {
            await currData.controller.forward();
            _userSuccess++;
            _eleBoxs[currData.boxIdx].isClick = false; // 关闭点击
            _eleBoxs[lastData.boxIdx].isClick = false;
            sliderStatusBadFlag = true;
            delList.addAll([lastData, currData]);
            audioUtils.play('bulingbuling.mp3'); // 音乐
          } else {
            await Future.delayed(Duration(milliseconds: 600));
            lastData.controller.reverse(); // 关闭动画
            currData.controller.reverse();
            delList.addAll([lastData, currData]);
            sliderStatusBadFlag = false;
          }
        }
      }

      sliderStatusBadFlag
          ? saveSliderState(SliderState.notBad)
          : saveSliderState(SliderState.bad);

      // 移除数据，保持loop队列
      delList.forEach((data) {
        _loopEleData.remove(data);
      });

      // 成功
      if (_userSuccess == _answerList.length) {
        saveSliderState(SliderState.good);
        // restGame();
        showSuccess(); // 提示成功
        return;
      }
      setGameState(false);
    });
  }

  void closeStrem() => _eleStrem.close();

  /// 获取游戏状态
  bool get gameState => _gameStop;

  /// 设置游戏状态, true暂停
  void setGameState(bool flag) => _gameStop = flag;

  // 重置游戏
  Future<void> restGame() async {
    setGameState(true);
    _userSuccess = 0;
    saveSliderState(SliderState.normal);
    for (var i = 0; i < _eleBoxs.length; i++) {
      _eleBoxs[i].controller.reset();
      _eleBoxs[i].isClick = true;
      Timer(Duration(milliseconds: 300), () {
        _eleBoxs[i].controller.forward();
        Timer(Duration(seconds: 2), () {
          _eleBoxs[i].controller.reset();
        });
      });
    }
    setBgImgUrlRandom();
    await Future.delayed(Duration(seconds: 3));
    setAnswerList();
    setGameState(false); // 开始游戏
  }

  List<int> get answerList => _answerList;

  /// 随机设置游戏背景
  void setBgImgUrlRandom() {
    bgImgUrl = Util.randomFn(6);
    notifyListeners();
  }

  /// 更新elebox所有的位置，随机值
  void setAnswerList() {
    _answerList[6] = Util.randomFn(5);
    _answerList[7] = Util.randomFn(5);
    _answerList.shuffle();
    notifyListeners();
  }

  /// 设置表情
  void saveSliderState(SliderState status) {
    _sliderState = status;
    notifyListeners();
  }

  /// 获取表情状态
  SliderState get getSliderState => _sliderState;

  /// 保存当前elebox元素信息
  void setEleBoxs(EleData eleData) {
    _eleBoxs[eleData.boxIdx] = eleData;
  }

  /// 获取elebox元素信息
  EleData getEleBox(int index) {
    return _eleBoxs[index];
  }

  /// 处理点击元素判断
  void diffELe(EleData eleData) {
    int len = _loopEleData.length;
    bool ckFlag = !_eleBoxs[eleData.boxIdx].isClick;
    // 过滤重复点击或已经正确的
    if (len > 0 && eleData.boxIdx == _loopEleData[len - 1].boxIdx || ckFlag) {
      return;
    }
    _eleStrem.sink.add(eleData);
  }
}
