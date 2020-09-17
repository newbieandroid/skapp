import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skapp/http/http_request.dart';
import 'package:skapp/pages/details/widgets/webview_widget.dart';
import 'package:skapp/widgets/restart_app.dart';
import './../../http/API.dart';

//http://jx.idc126.net/jx/?url=https://v.youku.com/v_show/id_XMjI2OTc2OTE2.html?spm=a2h03.12024492.drawer3.dzj1_1&scm=20140719.rcmd.1694.show_cbfccde2962411de83b1&s=cbfccde2962411de83b1

// ignore: camel_case_types
class Store {
  String get currentUrl {
    return 'http://jx.618ge.com/?url=https://v.youku.com/v_show/id_XMjI2OTc2OTE2.html?spm=a2h03.12024492.drawer3.dzj1_1&scm=20140719.rcmd.1694.show_cbfccde2962411de83b1&s=cbfccde2962411de83b1';
  }
}

class VipVideo extends StatefulWidget {
  @override
  _VipVideoState createState() => _VipVideoState();
}

class _VipVideoState extends State<VipVideo> {
  String ip = API.BASE_SK_URL;
  bool isIp = false; // 是否是一个ip地址
  bool isAvailableIp = false; // ip是否可用
  String currentIp = ''; // 当前输入的ip地址
  String desc =
      "视频解析：如果你觉得片源太少可以自定义片源。\n\n需要满足以下条件：\n\n1.有maccms的整套环境；\n\n2.联系本app作者索要服务端源码，邮箱：1768385508@qq.com；\n\n";

  final store = new Store();

  static bool isUrl(String value) {
    return RegExp(r"^((https|http|ftp|rtsp|mms)?:\/\/)[^\s]+").hasMatch(value);
  }

  Future<dynamic> getIP() async {
    // 初始化信息
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cIp = prefs.getString('ip') ?? API.BASE_SK_URL;
    if (mounted) {
      setState(() {
        ip = cIp;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getIP();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('视频解析'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          WebViewPage(
            store: store,
          ),
          TextField(
            // autofocus: true,
            decoration: InputDecoration(
              labelText: "IP地址",
              hintText: "当前地址：$ip",
              prefixIcon: Icon(Icons.near_me),
            ),
            onChanged: (val) {
              isAvailableIp = false;
              if (isUrl(val)) {
                if (mounted) {
                  setState(() {
                    isIp = true;
                    currentIp = val;
                  });
                }
              } else {
                if (mounted) {
                  setState(() {
                    isIp = false;
                    currentIp = "";
                  });
                }
              }
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 30,
                  margin: EdgeInsets.all(20),
                  child: RaisedButton(
                    child: Text('测试连接'),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    // elevation: 10,
                    onPressed: isIp
                        ? () async {
                            try {
                              // 探测特定接口是否可以返回数据
                              Fluttertoast.showToast(
                                msg: '连接中...',
                                toastLength: Toast.LENGTH_LONG,
                              );
                              var req = HttpRequest(currentIp);
                              final res = await req.get('/sk-api/type/list');
                              Fluttertoast.cancel();
                              if (res['code'] == 200) {
                                Fluttertoast.showToast(
                                  msg: '连接成功',
                                );
                                if (mounted) {
                                  setState(() {
                                    isAvailableIp = true;
                                  });
                                }
                              } else {
                                Fluttertoast.showToast(msg: '连接失败，请确认地址是否可用');
                              }
                            } catch (_) {
                              Fluttertoast.showToast(msg: '连接失败，请确认地址是否可用');
                            }
                          }
                        : null,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 30,
                  margin: EdgeInsets.all(20),
                  child: RaisedButton(
                    child: Text('连接'),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    // elevation: 10,
                    onPressed: isAvailableIp
                        ? () async {
                            // 此时需要修改全局变量，并且重启app
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setString('ip', currentIp);
                            RestartWidget.restartApp(context);
                          }
                        : null,
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              desc,
              style: Theme.of(context).textTheme.caption,
            ),
          )
        ],
      ),
    );
  }
}
