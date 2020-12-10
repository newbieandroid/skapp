import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_dlna/flutter_dlna.dart'; // 投屏插件

class DlnaPage extends StatefulWidget {
  // final DlnaPage store;
  final store;

  DlnaPage({this.store});

  @override
  _DlnaState createState() => _DlnaState();
}

class _DlnaState extends State<DlnaPage> {
  FlutterDlna manager = new FlutterDlna();
  List deviceList = List();
  //当前选择的设备
  String currentDeviceUUID = "";

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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                '投屏',
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
            // CustomGridView(vodDataLists, global),
          ],
        ),
      ), // 宽高比
    );
  }
}
