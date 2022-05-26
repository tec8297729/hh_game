import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../provider/home_store.p.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  late HomeStore _appStore;

  @override
  Widget build(BuildContext context) {
    _appStore = Provider.of<HomeStore>(context);
    return Offstage(
      offstage: !_appStore.loading,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: loadingContext(),
        ),
      ),
    );
  }

  // loading内容体
  loadingContext() {
    return [
      const SpinKitWave(color: Colors.blue),
      Container(
        margin: EdgeInsets.only(top: 130.w),
        child: Text(
          '初始化加载中...',
          style: TextStyle(
            fontFamily: 'Fish',
            fontSize: 46.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ];
  }
}
