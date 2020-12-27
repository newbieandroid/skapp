import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:skapp/store/root.dart';
import 'package:flutter_unionad/flutter_unionad.dart' as FlutterUnionad;
import './../../../widgets/custom_gridview_widget.dart';

class Like extends StatelessWidget {
  final ObservableList vodDataLists;
  final Global global;
  const Like({Key key, this.vodDataLists, this.global}) : super(key: key);

  Widget bannerWidget(_global) {
    return FlutterUnionad.bannerAdView(
        androidCodeId:
            _global.appAds.bannerCsj.androidId, //andrrid banner广告id 必填
        iosCodeId: _global.appAds.bannerCsj.iosId, //ios banner广告id 必填
        supportDeepLink: true, //是否支持 DeepLink 选填
        expressAdNum: 1, //一次请求广告数量 大于1小于3 选填
        expressTime: 30, //轮播间隔事件 秒  选填
        expressViewWidth: 600.5, // 期望view 宽度 dp 必填
        expressViewHeight: 120.5, //期望view高度 dp 必填
        callBack: (FlutterUnionad.FlutterUnionadState state) {
          //广告事件回调 选填
          //type onShow广告成功显示 onDislike不感兴趣 onFail广告加载失败
          //params 详细说明
          switch (state.type) {
            case FlutterUnionad.onShow:
              print(state.tojson());
              break;
            case FlutterUnionad.onFail:
              print(state.tojson());
              break;
            case FlutterUnionad.onDislike:
              print(state.tojson());
              break;
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            global.appAds.expressCsj.show == true
                ? Container(
                    margin: EdgeInsets.only(top: 20),
                    color: Colors.white,
                    child: bannerWidget(global),
                  )
                : Container(
                    width: 0,
                    height: 0,
                  ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                '猜你喜欢',
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
            CustomGridView(vodDataLists, global),
          ],
        ),
      ),
    );
  }
}
