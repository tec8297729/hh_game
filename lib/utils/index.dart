import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math' as math;
export 'tool/sp_util.dart' show SpUtil;
export 'tool/perm_util.dart' show PermUtil;
export 'tool/log_util.dart' show LogUtil;

/// 防抖函数
Function debounce(Function fn, [int t = 30]) {
  Timer? _debounce;
  return (data) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(Duration(milliseconds: t), () {
      fn(data);
    });
  };
}

/// 是否是手机号
bool isPhone(String value) {
  return RegExp(r"^1(3|4|5|7|8)\d{9}$").hasMatch(value);
}

int randomFn(int scopeNum) {
  return math.Random().nextInt(scopeNum);
}

double randomDoubleFn(double scopeNum) {
  return math.Random().nextDouble() * scopeNum;
}

/// tosat提示
void toastTips(String text) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    // gravity: ToastGravity.CENTER, // 提示位置
    fontSize: 18, // 提示文字大小
  );
}
