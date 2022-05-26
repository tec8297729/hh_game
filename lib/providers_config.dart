import 'package:hh_game/pages/app_main/provider/home_store.p.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'provider/global.p.dart';
import 'provider/theme_store.p.dart';

List<SingleChildWidget> providersConfig = [
  ChangeNotifierProvider<ThemeStore>(create: (_) => ThemeStore()),
  ChangeNotifierProvider<GlobalStore>(create: (_) => GlobalStore()),
  ChangeNotifierProvider<HomeStore>(create: (_) => HomeStore()),
];
