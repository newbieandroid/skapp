import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import 'package:provider/provider.dart';
import 'package:skapp/http/http_request.dart';
import 'package:skapp/store/details/details.dart';
import 'package:skapp/store/root.dart';
// import 'package:skapp/widgets/flutter_tencentplayer_example/download_page.dart';
import 'package:skapp/widgets/flutter_tencentplayer_example/window_video_page.dart';
import './../../http/API.dart';

//http://jx.idc126.net/jx/?url=https://v.youku.com/v_show/id_XMjI2OTc2OTE2.html?spm=a2h03.12024492.drawer3.dzj1_1&scm=20140719.rcmd.1694.show_cbfccde2962411de83b1&s=cbfccde2962411de83b1

class VipVideo extends StatefulWidget {
  @override
  _VipVideoState createState() => _VipVideoState();
}

class _VipVideoState extends State<VipVideo> {
  String ip = API.BASE_SK_URL;
  bool isIp = false; // 是否是一个ip地址
  String currentIp = ''; // 当前输入的ip地址
  String dropdownValue = '';
  bool globalLoading = true;
  // 视频解析接口
  var vipList = [];
  var vipObj = {};
  String desc =
      "视频解析操作步骤：\n1.打开浏览器找到想要播放的视频；\n2.复制视频地址到上面的输入框；\n3.点击“开始解析”按钮即可播放；\n4.部分视频可能会出现解析失败现象，可以切换解析路径重新解析";

  final DetailsStore store = DetailsStore();

  static bool isUrl(String value) {
    return RegExp(r"^((https|http|ftp|rtsp|mms)?:\/\/)[^\s]+").hasMatch(value);
  }

  // 获取解析地址
  Future<dynamic> getIP() async {
    var req = HttpRequest(ip);
    final res = await req.get(API.APP_VIDEO_INFO);

    var a = "";
    var b = [];
    var c = {};
    // 初始化信息
    if (mounted) {
      if (res.length == 0) {
        setState(() {
          dropdownValue = "无可用线路";
          vipList = ["无可用线路"];
          globalLoading = false;
        });
      } else {
        a = res[0]['name'];
        for (var i = 0; i < res.length; i++) {
          b.add(res[i]['name']);
          c[res[i]['name']] = res[i];
        }
        setState(() {
          dropdownValue = a;
          vipList = b;
          vipObj = c;
          globalLoading = false;
        });
      }
    }
  }

  Future<dynamic> getVideoInfo(String url) async {
    // 构造新的url
    String fullurl = r'HD高清$' + url;
    store.formatPD(fullurl);
    store.changeShowAd(false);
  }

  @override
  void initState() {
    super.initState();
    getIP();
    // getVideoInfo();
  }

  @override
  Widget build(BuildContext context) {
    final Global _global = Provider.of<Global>(context);
    return Observer(
      builder: (_) => Scaffold(
        // appBar: AppBar(
        //   title: Text('视频解析'),
        // ),
        resizeToAvoidBottomInset: false,
        body: globalLoading
            ? _global.isDark
                ? PKDarkCardProfileSkeleton(
                    isCircularImage: false,
                    isBottomLinesActive: true,
                  )
                : PKCardProfileSkeleton(
                    isCircularImage: false,
                    isBottomLinesActive: true,
                  )
            : SafeArea(
                child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  // 触摸收起键盘
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    store.isLoading
                        ? AspectRatio(
                            aspectRatio: 16.0 / 9.0, // 宽高比
                            child: Container(
                              decoration: new BoxDecoration(
                                color: Colors.black,
                              ),
                            ))
                        : WindowVideoPage(store: store, global: _global),
                    Expanded(
                      child: Column(
                        children: [
                          // ListTile(
                          //   title: Text('下载视频'),
                          //   onTap: () {
                          //     Navigator.of(context).push(CupertinoPageRoute(
                          //         builder: (_) => DownloadPage()));
                          //   },
                          // ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: dropdownValue,
                                    onChanged: (String newValue) {
                                      changedropdownValue(newValue);
                                    },
                                    items: vipList
                                        .map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    // autofocus: true,
                                    decoration: InputDecoration(
                                      labelText: "输入要解析的视频地址",
                                      hintText: "",
                                      border: InputBorder.none,
                                      // prefixIcon: Icon(Icons.near_me),
                                    ),
                                    onChanged: (val) {
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
                                )
                              ],
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  height: 40,
                                  margin: EdgeInsets.all(20),
                                  child: RaisedButton(
                                    child: Text('开始解析'),
                                    color: Theme.of(context).primaryColor,
                                    textColor: Colors.white,
                                    // elevation: 10,
                                    onPressed: isIp
                                        ? () async {
                                            try {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());

                                              // 探测特定接口是否可以返回数据
                                              store.isLoading = true;
                                              Fluttertoast.showToast(
                                                msg: '努力加载中...',
                                                toastLength: Toast.LENGTH_LONG,
                                              );
                                              var req = HttpRequest(
                                                  vipObj[dropdownValue]
                                                      ['prefix']);
                                              final res = await req.get(
                                                  vipObj[dropdownValue]['url'] +
                                                      currentIp);
                                              store.isLoading = false;
                                              Fluttertoast.cancel();
                                              if (res['code'] == 200) {
                                                Fluttertoast.showToast(
                                                  msg: '连接成功,即将开始播放',
                                                );
                                                getVideoInfo(res['url']);
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg: '连接失败，请更换解析地址或解析视频');
                                              }
                                            } catch (_) {
                                              Fluttertoast.showToast(
                                                  msg: '连接失败，请确认地址是否可用');
                                            }
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
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
      ),
    );
  }

  void changedropdownValue(String newValue) {
    setState(() {
      dropdownValue = newValue;
    });
  }
}
