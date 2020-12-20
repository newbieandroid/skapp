/*
 * Created: 2020-04-07 10:43:03
 * Author : Mockingbird
 * Email : 1768385508@qq.com
 * -----
 * Description: 
 */

import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import './../dao/app_config_dao.dart';
import './../dao/app_ads_dao.dart';
import './../http/API.dart';
import './../http/http_request.dart';

/// 必须, 用于生成.g文件
part 'root.g.dart';

class Global = GlobalMobx with _$Global;

/// 步骤:
/// 1. 创建counter.dart
/// 2. 添加 part 'counter.g.dart';
/// 3. 添加 class Counter = CounterMobx with _$Counter;
/// 4. 执行命令: flutter packages pub run build_runner build
/// 5. 删除之内再生成: flutter packages pub run build_runner build --delete-conflicting-outputs
/// 6. 实时更新.g文件: flutter packages pub run build_runner watch

/// Counter可观察对象
abstract class GlobalMobx with Store {
  SharedPreferences prefs;
  var colorList = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.lightGreen,
    Colors.lime,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.blueGrey,
    Colors.indigo,
    Colors.brown,
  ];

  String url = API.APP_CONFIG;
  String adsUrl = API.APP_ADS;

  Future getThemeIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int themeIndex = prefs.getInt('themeIndex') ?? 0;
    return themeIndex;
  }

  /// 可观察的值
  @observable
  bool showAd = true; // 是否显示loading

  @observable
  bool updataApp = false; // 是否更新app

  @observable
  bool isAllowProtocol = false; // 是否同意协议

  @observable
  AppConfigDao appConfig;

  @observable
  AppAdsDao appAds;

  @observable
  String title = 'SK'; // 标题

  @observable
  Color theme; //在主题色

  @computed
  Brightness get themeMode {
    return isDark ? Brightness.dark : Brightness.light;
  }

  // 获取图片缓存数据
  @computed
  int get imageCasheSize {
    ImageCache imageCache = PaintingBinding.instance.imageCache;
    return imageCache.currentSizeBytes;
  }

  @observable
  bool isDark;

  @observable
  bool isMusic;

  @observable
  bool showPause;

  @observable
  bool isShowList = true; // 首页列表展示（默认grid展示）

  GlobalMobx(this.prefs) {
    if (this.prefs != null) {
      theme = colorList[prefs.getInt('themeIndex') ?? 5];
      isDark = prefs.getBool('isDark') ?? false;
      isMusic = prefs.getBool('isMusic') ?? false;
      isAllowProtocol = prefs.getBool('isAllowProtocol') ?? false;
      // isShowList = prefs.getBool('isShowList') ?? false;
      FlutterStatusbarcolor.setStatusBarColor(theme);
    }
  }

  @action
  void changeShowAd(bool showAd) {
    this.showAd = showAd;
  }

  @action
  void changeShowList(bool b) {
    this.isShowList = b;
  }

  @action
  void changeTheme(Color color) {
    theme = color;
    // 获取index存储
    int index = colorList.indexOf(color);
    prefs.setInt('themeIndex', index);
    FlutterStatusbarcolor.setStatusBarColor(theme);
  }

  @action
  void changeThemeMode(bool value) {
    isDark = value;
    prefs.setBool('isDark', value);
  }

  @action
  void changeAppMode(bool value) {
    isMusic = value;
    prefs.setBool('isMusic', value);
  }

  @action
  void changeProtocol(bool value) {
    isAllowProtocol = value;
    prefs.setBool('isAllowProtocol', value);
  }

  @action
  Future<dynamic> getAppConfig() async {
    var req = HttpRequest(API.BASE_SK_URL);
    final res = await req.get(url);
    this.appConfig = AppConfigDao.fromJson(res);
  }

  @action
  Future<dynamic> getAppAds() async {
    var req = HttpRequest(API.BASE_SK_URL);
    final res = await req.get(adsUrl);
    this.appAds = AppAdsDao.fromJson(res);
  }

  @action
  void changeUpdataApp() {
    updataApp = true;
  }

  @action
  void changeAppAdsPause(bool v) {
    this.showPause = v;
  }
}
