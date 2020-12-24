import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dlna/flutter_dlna.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skapp/iconfont/IconFont.dart';
import 'package:skapp/store/root.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../../store/details/details.dart';

class DlnaPage extends StatefulWidget {
  // final DlnaPage store;
  final Global global;
  final DetailsStore store;
  final PanelController pc;
  DlnaPage({Key key, this.store, this.pc, this.global}) : super(key: key);

  @override
  _DlnaState createState() => _DlnaState();
}

class _DlnaState extends State<DlnaPage> {
  FlutterDlna manager = new FlutterDlna();
  List deviceList = List();
  //当前选择的设备
  String currentDeviceUUID = "";

  double _panelHeightOpen;
  double _panelHeightClosed = 0;

  @override
  void initState() {
    super.initState();
    manager.init();
    manager.setSearchCallback((devices) {
      if (devices != null && devices.length > 0) {
        this.setState(() {
          this.deviceList = devices;
        });
      }
    });
    manager.search();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height -
        ((MediaQuery.of(context).size.width / 16.0) * 9.0) -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom -
        MediaQueryData.fromWindow(window).padding.top;
    // if ios need -34 (unknown)
    if (Platform.isIOS) {
      // _panelHeightOpen = _panelHeightOpen - 34;
    }
    return Observer(builder: (_) {
      return SingleChildScrollView(
        child: SlidingUpPanel(
          controller: widget.pc,
          maxHeight: _panelHeightOpen,
          minHeight: _panelHeightClosed,
          parallaxEnabled: false,
          parallaxOffset: 0,
          color: Theme.of(context).cardColor,
          panelBuilder: (sc) => _panel(sc, context, widget.store),
          defaultPanelState: PanelState.CLOSED,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0), topRight: Radius.circular(0)),
        ),
      );
    });
  }

  Widget _panel(ScrollController sc, context, DetailsStore store) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: ListView.separated(
        padding: new EdgeInsets.all(5.0),
        itemCount: deviceList.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '选择投屏设备',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                ),
                // IconButton(
                //   iconSize: 18,
                //   icon: Icon(
                //     Icons.close,
                //   ),
                //   padding: EdgeInsets.all(0.0),
                //   onPressed: () {
                //     widget.pc.close();
                //   },
                // ),
                Positioned(
                  right: 0,
                  child: RaisedButton.icon(
                    icon: IconFont(IconNames.icontouping, size: 18),
                    color: Colors.transparent,
                    elevation: 0,
                    label: Text(
                      '退出投屏',
                      style: TextStyle(
                          color: widget.global.isDark
                              ? Colors.white
                              : Theme.of(context).primaryColorDark),
                    ),
                    onPressed: () {
                      widget.pc.close();
                      // if (!widget.controller.value.isPlaying) {
                      //   widget.controller.play();
                      // }
                      store.changeDlna(false);
                      this.manager.stop();
                    },
                  ),
                )
              ],
            );
          } else {
            var e = deviceList[index - 1];
            return InkWell(
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      height: 55,
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            e["name"],
                            maxLines: 1,
                            style: Theme.of(context).textTheme.subtitle2,
                          )),
                        ],
                      )),
                  // Divider(
                  //   color: Color(0xFFEEEEEE),
                  //   height: 0.5,
                  //   endIndent: 2,
                  //   indent: 2,
                  // )
                ],
              ),
              onTap: () async {
                if ((store.currentUrl.indexOf('.m3u8') >= 0) ||
                    (store.currentUrl.indexOf('.mp4') >= 0) ||
                    (store.currentUrl.indexOf('rtmp:') >= 0) ||
                    (store.currentUrl.indexOf('.flv') >= 0)) {
                  if (this.currentDeviceUUID == e["id"]) {
                    return;
                  }
                  // 投屏后所播放视频暂停
                  // if (widget.controller.value.isPlaying) {
                  //   widget.controller.pause();
                  // }
                  store.changeDlna(true);
                  await this.manager.setDevice(e["id"]);
                  await this
                      .manager
                      .setVideoUrlAndName(store.currentUrl, store.vod.vodName);
                  await this.manager.startAndPlay();
                } else {
                  Fluttertoast.showToast(
                    msg: '不支持的视频格式',
                  );
                }
              },
            );
          }
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: .1,
            indent: 0,
            color: Theme.of(context).dividerColor,
          );
        },
      ),
    );
  }
}
