// 初始化第三方插件
import '../../config/app_env.dart';
import '../tool/sp_util.dart';

void appSetupInit() {
  appEnv.init(); // 初始环境
  SpUtil.getInstance(); // 本地缓存初始化
}
