import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skapp/store/details/details.dart';
import 'package:skapp/utils/screen_utils.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:webview_flutter/webview_flutter.dart';
import './widget/tencent_player_bottom_widget.dart';
import './widget/tencent_player_gesture_cover.dart';
import './widget/tencent_player_loading.dart';
import 'package:screen/screen.dart';
import 'package:flutter_tencentplayer/flutter_tencentplayer.dart';
import './main.dart';
// import './util/forbidshot_util.dart';
import 'package:skapp/store/root.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class FullVideoPage extends StatefulWidget {
  final Global global;
  final DetailsStore store;
  PlayType playType;
  String dataSource;
  TencentPlayerController controller;

  //UI
  bool showBottomWidget;
  bool showClearBtn;

  FullVideoPage(
      {this.global,
      this.store,
      this.controller,
      this.showBottomWidget = true,
      this.showClearBtn = true,
      this.dataSource,
      this.playType = PlayType.network});

  @override
  _FullVideoPageState createState() => _FullVideoPageState();
}

class _FullVideoPageState extends State<FullVideoPage> {
  TencentPlayerController controller;
  VoidCallback listener;

  bool isLock = false;
  bool showCover = false;
  Timer timer;

  _FullVideoPageState() {
    listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _initController();
    controller.addListener(listener);
    hideCover();
    // ForbidShotUtil.initForbid(context);
    Screen.keepOn(true);
  }

  @override
  Future dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    controller.removeListener(listener);
    if (widget.controller == null) {
      controller.dispose();
    }
    //ForbidShotUtil.disposeForbid();
    Screen.keepOn(false);
  }

  _initController() {
    if (widget.controller != null) {
      controller = widget.controller;
      return;
    }
    switch (widget.playType) {
      case PlayType.network:
        controller = TencentPlayerController.network(widget.dataSource);
        break;
      case PlayType.asset:
        controller = TencentPlayerController.asset(widget.dataSource);
        break;
      case PlayType.file:
        controller = TencentPlayerController.file(widget.dataSource);
        break;
      case PlayType.fileId:
        controller = TencentPlayerController.network(null,
            playerConfig: PlayerConfig(
                auth: {"appId": 1252463788, "fileId": widget.dataSource}));
        break;
    }
    controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    // 监听是否播放完毕
    if ((controller.value.position == controller.value.duration) &&
        (controller.value.position.inSeconds != 0)) {
      Navigator.of(context).pop();
      // widget.store.playNext();
    }

    return Scaffold(
        body: SafeArea(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          //if (isLock == false) {
          hideCover();
          //}
        },
        onDoubleTap: () {
          if (!widget.showBottomWidget || isLock) return;
          if (controller.value.isPlaying) {
            controller.pause();
          } else {
            controller.play();
          }
        },
        child: Container(
          color: Colors.black,
          child: Stack(
            overflow: Overflow.visible,
            alignment: Alignment.center,
            children: <Widget>[
              /// 视频
              controller.value.initialized
                  ? AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: TencentPlayer(controller),
                    )
                  : Container(
                      width: 0,
                      height: 0,
                    ),

              /// 支撑全屏
              Container(
                width: 0,
                height: 0,
              ),

              /// 半透明浮层
              showCover
                  ? Container(color: Color(0x1f000000))
                  : Container(color: Colors.transparent),

              /// 处理滑动手势
              Offstage(
                offstage: isLock,
                child: TencentPlayerGestureCover(
                  controller: controller,
                  showBottomWidget: widget.showBottomWidget,
                  behavingCallBack: delayHideCover,
                ),
              ),

              /// 加载loading
              TencentPlayerLoading(
                controller: controller,
                iconW: 53,
              ),

              /// 头部浮层
              !isLock && showCover
                  ? Positioned(
                      top: 0,
                      left: MediaQuery.of(context).padding.top,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 14, left: 10),
                          child: Image.asset(
                            'assets/images/icon_back.png',
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      width: 0,
                      height: 0,
                    ),

              /// 锁
              showCover
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              isLock = !isLock;
                            });
                          }
                          delayHideCover();
                          // if (Platform.isAndroid) {
                          //   DeviceOrientation deviceOrientation =
                          //       controller.value.orientation < 180
                          //           ? DeviceOrientation.landscapeRight
                          //           : DeviceOrientation.landscapeLeft;
                          //   if (isLock) {
                          //     SystemChrome.setPreferredOrientations(
                          //         [deviceOrientation]);
                          //   } else {
                          //     SystemChrome.setPreferredOrientations([
                          //       DeviceOrientation.landscapeLeft,
                          //       DeviceOrientation.landscapeRight,
                          //     ]);
                          //   }
                          // }
                        },
                        child: Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top,
                            right: 20,
                            bottom: 20,
                            left: 12,
                          ),
                          child: Icon(
                            isLock ? Icons.lock_outline : Icons.lock_open,
                            color: Colors.white,
                          ),
                          // Image.asset(
                          //   isLock
                          //       ? 'assets/images/player_lock.png'
                          //       : 'assets/images/player_unlock.png',
                          //   width: 38,
                          //   height: 38,
                          // ),
                        ),
                      ),
                    )
                  : Container(
                      width: 0,
                      height: 0,
                    ),

              /// 进度、清晰度、速度
              !isLock && showCover
                  ? Offstage(
                      offstage: !widget.showBottomWidget,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).padding.top,
                            right: MediaQuery.of(context).padding.bottom),
                        child: TencentPlayerBottomWidget(
                          isShow: showCover,
                          showCover: showCover,
                          currentUrl: widget.dataSource,
                          controller: controller,
                          showClearBtn: widget.showClearBtn,
                          showFullBtn: false,
                          store: widget.store,
                          behavingCallBack: () {
                            delayHideCover();
                          },
                          changeClear: (int index) {
                            changeClear(index);
                          },
                        ),
                      ),
                    )
                  : Container(
                      width: 0,
                      height: 0,
                    ),

              controller.value.isPlaying
                  ? Container(
                      width: 0,
                      height: 0,
                    )
                  : widget.global.showPause
                      ? Center(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                width: ScreenUtils.screenW(context) / 2,
                                height: ScreenUtils.screenW(context) / 3,
                                child: GestureDetector(
                                  onTap: () {
                                    if (widget.global.appAds.pause.href != '') {
                                      launch(widget.global.appAds.pause.href);
                                    }
                                  },
                                  child: widget.global.appAds.pause.type ==
                                          'img'
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0)),
                                          child: FadeInImage(
                                            placeholder:
                                                MemoryImage(kTransparentImage),
                                            image: CachedNetworkImageProvider(
                                              widget.global.appAds.pause.src,
                                            ),
                                            fit: BoxFit.fill,
                                          ))
                                      : Container(
                                          color: Colors.black,
                                          child: WebView(
                                            initialUrl: widget.global.appAds
                                                .pause.src, // 加载的url
                                          ),
                                        ),
                                ),
                              ),
                              Positioned(
                                right: -8,
                                top: -8,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: IconButton(
                                    iconSize: 18,
                                    icon: Icon(
                                      Icons.close,
                                    ),
                                    padding: EdgeInsets.all(0.0),
                                    onPressed: () {
                                      widget.global.changeAppAdsPause(false);
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : Container(
                          width: 0,
                          height: 0,
                        )
            ],
          ),
        ),
      ),
    ));
  }

  List<String> clearUrlList = [
    'http://1252463788.vod2.myqcloud.com/95576ef5vodtransgzp1252463788/e1ab85305285890781763144364/v.f10.mp4',
    'http://1252463788.vod2.myqcloud.com/95576ef5vodtransgzp1252463788/e1ab85305285890781763144364/v.f20.mp4',
    'http://1252463788.vod2.myqcloud.com/95576ef5vodtransgzp1252463788/e1ab85305285890781763144364/v.f30.mp4',
  ];

  changeClear(int urlIndex, {int startTime}) {
    controller?.removeListener(listener);
    controller?.pause();
    controller = TencentPlayerController.network(clearUrlList[urlIndex],
        playerConfig: PlayerConfig(
            startTime: startTime ?? controller.value.position.inSeconds));
    controller?.initialize()?.then((_) {
      if (mounted) setState(() {});
    });
    controller?.addListener(listener);
  }

  hideCover() {
    if (!mounted) return;
    setState(() {
      showCover = !showCover;
    });
    delayHideCover();
  }

  delayHideCover() {
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
    if (showCover) {
      timer = new Timer(Duration(seconds: 6), () {
        if (!mounted) return;
        setState(() {
          showCover = false;
        });
      });
    }
  }
}
