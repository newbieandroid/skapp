import 'dart:async';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './../app/index.dart';
import './../../utils/screen_utils.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import './../../store/root.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_unionad/flutter_unionad.dart' as FlutterUnionad;

enum Action { Ok, Cancel }

///打开APP首页
class SplashWidget extends StatefulWidget {
  @override
  _SplashWidgetState createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  String protocol =
      "1.本软件的数据来源原理是从各视频网站的公开服务器中拉取数据，经过对数据简单地筛选与合并后进行展示，因此本软件不对数据的准确性负责\n2.使用本软件的过程中可能会产生版权数据，对于这些版权数据，本软件不拥有它们的所有权，为了避免造成侵权，使用者务必在24小时内清除使用本软件的过程中所产生的版权数据。\n3.本软件不提供影片资源储存也不参与录制与上传，若本软件收录内容无意侵犯了贵公司版权，请联系本作者删除。\n4.本软件内使用的部分包括但不限于字体、图片等资源来源于互联网，如果出现侵权可联系本软件移除。5.由于使用本软件产生的包括由于本协议或由于使用或无法使用本软件而引起的任何性质的任何直接、间接、特殊、偶然或结果性损害（包括但不限于因商誉损失、停工、计算机故障或故障引起的损害赔偿，或任何及所有其他商业损害或损失）由使用者负责。\n6.本软件完全免费，且开源发布于 GitHub 面向全世界人用作对技术的学习交流，本软件不对软件内的技术可能存在违反当地法律法规的行为作保证，禁止在违反当地法律法规的情况下使用本软件，对于使用者在明知或不知当地法律法规不允许的情况下使用本软件所造成的任何违法违规行为由使用者承担，本软件不承担由此造成的任何直接、间接、特殊、偶然或结果性责任。\n\n若你使用了本软件，将代表你接收以上协议，请尊重版权，支持正版！";

  _checkProtocol(_global, context) {
    if (!_global.isAllowProtocol) {
      _showAlertDialog(_global, context);
    }
  }

  _showAlertDialog(_global, BuildContext context) {
    //设置按钮
    Widget cancelButton = FlatButton(
      child: Text("取消"),
      onPressed: () {
        Navigator.pop(context, Action.Cancel);
        SystemNavigator.pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("确定"),
      onPressed: () async {
        _global.changeProtocol(true);
        Navigator.pop(context, Action.Ok);
        _global.changeShowAd(false);
      },
    );

    //设置对话框
    AlertDialog alert = AlertDialog(
      title: Text("软件协议"),
      content: Text(protocol),
      scrollable: true,
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    //显示对话框
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // 初始化穿山甲

  @override
  void initState() {
    super.initState();
    _initRegister();
  }

  void _initRegister() async {
    // 初始化穿山甲
    await FlutterUnionad.register(
      androidAppId: "5130527", //穿山甲广告 Android appid 必填
      iosAppId: "5130527", //穿山甲广告 ios appid 必填
      useTextureView:
          true, //使用TextureView控件播放视频,默认为SurfaceView,当有SurfaceView冲突的场景，可以使用TextureView 选填
      appName: "sk", //appname 必填
      allowShowNotify: true, //是否允许sdk展示通知栏提示 选填
      allowShowPageWhenScreenLock: true, //是否在锁屏场景支持展示广告落地页 选填
      debug: false, //测试阶段打开，可以通过日志排查问题，上线时去除该调用 选太难
      supportMultiProcess: true, //是否支持多进程，true支持 选填
      directDownloadNetworkType: [
        FlutterUnionad.NETWORK_STATE_2G,
        FlutterUnionad.NETWORK_STATE_3G,
        FlutterUnionad.NETWORK_STATE_4G,
        FlutterUnionad.NETWORK_STATE_WIFI
      ],
    ); //允许直接下载的网络状态集合 选填
    // await FlutterUnionad.getSDKVersion();
    // await FlutterUnionad.requestPermissionIfNecessary();
  }

  @override
  Widget build(BuildContext context) {
    final Global _global = Provider.of<Global>(context);
    Timer(Duration(seconds: 1), () => _checkProtocol(_global, context));
    if (_global.appAds != null &&
        _global.appAds.loading.show == false &&
        _global.appAds.splash.show == false &&
        _global.appAds.splashCsj.show == false) {
      _global.changeShowAd(false);
    }
    // if (_global.appAds.loading == null) {
    //   return Container(
    //     child: Text('2222'),
    //   );
    // }
    return Stack(
      children: <Widget>[
        Observer(
          builder: (_) => Offstage(
            child: App(),
            offstage: _global.showAd,
          ),
        ),
        Observer(builder: (_) {
          if (_global.appAds != null) {
            if ((_global.appAds.splash.show == true) &&
                (_global.isAllowProtocol == true)) {
              return Offstage(
                  offstage: !_global.showAd,
                  child: SafeArea(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: ScreenUtils.screenW(context),
                          height: ScreenUtils.screenH(context),
                          color: Theme.of(context).cardColor,
                          child: GestureDetector(
                            onTap: () {
                              if (_global.appAds.splash.href != '') {
                                launch(_global.appAds.splash.href);
                              }
                            },
                            child: _global.appAds.splash.type == 'img'
                                ? ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0)),
                                    child: FadeInImage(
                                      fadeInDuration:
                                          Duration(milliseconds: 100),
                                      placeholder:
                                          MemoryImage(kTransparentImage),
                                      image: CachedNetworkImageProvider(
                                        _global.appAds.splash.src,
                                      ),
                                      fit: BoxFit.fill,
                                    ))
                                : Container(
                                    color: Colors.black,
                                    child: WebView(
                                      initialUrl:
                                          _global.appAds.splash.src, // 加载的url
                                    ),
                                  ),
                          ),
                        ),
                        Positioned(
                            top: 10,
                            right: 10,
                            child: GestureDetector(
                              onTap: () {
                                _global.changeShowAd(false);
                              },
                              child: CountDownWidget(
                                show: true,
                                timer: _global.appAds.splash.timer,
                                onCountDownFinishCallBack: (bool value) {
                                  if (value) {
                                    _global.changeShowAd(false);
                                  }
                                },
                              ),
                            )),
                      ],
                    ),
                  ));
            } else if ((_global.appAds.loading.show == true) &&
                (_global.isAllowProtocol == true)) {
              return Offstage(
                child: Container(
                  color: Theme.of(context).cardColor,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment(0.0, 0.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              radius: ScreenUtils.screenW(context) / 4,
                              backgroundImage:
                                  AssetImage('assets/images/home.jpg'),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 20.0,
                                top: 20.0,
                                right: 20.0,
                                bottom: 0,
                              ),
                              child: Text('何必如此认真？\nWHY SO SERIOUS? ',
                                  textAlign: TextAlign.center,
                                  maxLines: 6,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.caption),
                            )
                          ],
                        ),
                      ),
                      SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CountDownWidget(
                              show: false,
                              timer: _global.appAds.loading.timer,
                              onCountDownFinishCallBack: (bool value) {
                                if (value) {
                                  _global.changeShowAd(false);
                                }
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 40.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/ic_launcher.png',
                                    width: 50.0,
                                    height: 50.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      'SK',
                                      style: Theme.of(context).textTheme.title,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  width: ScreenUtils.screenW(context),
                  height: ScreenUtils.screenH(context),
                ),
                offstage: !_global.showAd,
              );
            } else if ((_global.appAds.splashCsj.show == true) &&
                (_global.isAllowProtocol == true)) {
              return Offstage(
                child: Container(
                  child: FlutterUnionad.splashAdView(
                    androidCodeId: _global
                        .appAds.splashCsj.androidId, //android 开屏广告广告id 必填
                    iosCodeId: _global.appAds.splashCsj.iosId, //ios 开屏广告广告id 必填
                    supportDeepLink: true, //是否支持 DeepLink 选填
                    expressViewWidth:
                        ScreenUtils.screenW(context), // 期望view 宽度 dp 必填
                    expressViewHeight:
                        ScreenUtils.screenH(context), //期望view高度 dp 必填
                    callBack: (FlutterUnionad.FlutterUnionadState state) {
                      //广告事件回调 选填
                      //广告事件回调 选填
                      //type onShow广告成功显示  onFail广告加载失败 onAplashClick开屏广告点击 onAplashSkip开屏广告跳过
                      //  onAplashFinish开屏广告倒计时结束 onAplashTimeout开屏广告加载超时
                      //params 详细说明
                      print("到这里 ${state.tojson()}");
                      switch (state.type) {
                        case FlutterUnionad.onShow:
                          print(state.tojson());
                          break;
                        case FlutterUnionad.onFail:
                          _global.changeShowAd(false);
                          break;
                        case FlutterUnionad.onAplashClick:
                          print(state.tojson());
                          break;
                        case FlutterUnionad.onAplashSkip:
                          print(state.tojson());
                          _global.changeShowAd(false);
                          break;
                        case FlutterUnionad.onAplashFinish:
                          print(state.tojson());
                          _global.changeShowAd(false);
                          break;
                        case FlutterUnionad.onAplashTimeout:
                          print(state.tojson());
                          _global.changeShowAd(false);
                          break;
                      }
                    },
                  ),
                  width: ScreenUtils.screenW(context),
                  height: ScreenUtils.screenH(context),
                ),
                offstage: !_global.showAd,
              );
            } else {
              return CountDownWidget(
                show: false,
                timer: 0,
                onCountDownFinishCallBack: (bool value) {
                  if (value) {
                    _global.changeShowAd(false);
                  }
                },
              );
            }
          } else {
            return Container(
              width: 0,
              height: 0,
            );
          }
        })
      ],
    );
  }
}

class CountDownWidget extends StatefulWidget {
  final onCountDownFinishCallBack;
  final int timer;
  final bool show;

  CountDownWidget(
      {Key key,
      @required this.timer,
      @required this.onCountDownFinishCallBack,
      @required this.show})
      : super(key: key);

  @override
  _CountDownWidgetState createState() => _CountDownWidgetState();
}

class _CountDownWidgetState extends State<CountDownWidget> {
  Timer _timer;
  int _seconds;
  @override
  void initState() {
    super.initState();
    _seconds = widget.timer;
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return widget.show
        ? ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            child: Container(
              padding: EdgeInsets.all(4),
              color: Theme.of(context).primaryColor,
              child: Text(
                '跳过(${_seconds}s)',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ))
        : Text('');
  }

  /// 启动倒计时的计时器。
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
      if (_seconds <= 1) {
        widget.onCountDownFinishCallBack(true);
        _cancelTimer();
        return;
      }
      _seconds--;
    });
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    _timer?.cancel();
  }
}
