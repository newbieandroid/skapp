import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import 'package:provider/provider.dart';
import 'package:skapp/dao/vod_list_dao.dart';
import 'package:skapp/http/http_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skapp/pages/classify/skitem.dart';
import 'package:skapp/store/details/details.dart';
import 'package:skapp/store/root.dart';
// import 'package:skapp/widgets/flutter_tencentplayer_example/download_page.dart';
import 'package:skapp/widgets/flutter_tencentplayer_example/window_video_page.dart';
import './../../http/API.dart';

//http://jx.idc126.net/jx/?url=https://v.youku.com/v_show/id_XMjI2OTc2OTE2.html?spm=a2h03.12024492.drawer3.dzj1_1&scm=20140719.rcmd.1694.show_cbfccde2962411de83b1&s=cbfccde2962411de83b1

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool globalLoading = true;

  final DetailsStore store = DetailsStore();

  // 定义历史记录数组
  List historyArr = [];

  Future<dynamic> getHis() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List historyLists = prefs.getStringList('historyLists') ?? [];
    setState(() {
      historyArr = historyLists;
      globalLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getHis();
    // getVideoInfo();
  }

  @override
  Widget build(BuildContext context) {
    final Global _global = Provider.of<Global>(context);
    return Observer(
      builder: (_) => Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: AppBar(
          title: Text(
            '观影历史',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: globalLoading
            ? _global.isDark
                ? PKDarkCardListSkeleton(
                    isCircularImage: false,
                    isBottomLinesActive: true,
                  )
                : PKCardListSkeleton(
                    isCircularImage: false,
                    isBottomLinesActive: true,
                  )
            : SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                                style: Theme.of(context).textTheme.caption,
                                children: <InlineSpan>[
                                  TextSpan(text: '已观看'),
                                  TextSpan(
                                      text: historyArr.length.toString(),
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 18)),
                                  TextSpan(text: '部影片'),
                                  TextSpan(
                                      text: '(左滑影片删除)',
                                      style: TextStyle(fontSize: 11)),
                                ]),
                          ),
                          RaisedButton.icon(
                            icon: Icon(Icons.delete,
                                color: _global.isDark
                                    ? Colors.white
                                    : Color.fromRGBO(128, 128, 128, 1)),
                            color: Theme.of(context).cardColor,
                            elevation: 0,
                            label: Text(
                              '全部',
                              style: TextStyle(
                                color: _global.isDark
                                    ? Colors.white
                                    : Color.fromRGBO(128, 128, 128, 1),
                              ),
                            ),
                            onPressed: () {
                              // 删除全部历史记录
                              // 判断使用有数据
                              if (historyArr.length > 0) {
                                showDialog(
                                    context: context,
                                    builder: (_) => AssetGiffyDialog(
                                          buttonRadius: 4.0,
                                          key: Key("AssetDialog"),
                                          image: Image.asset(
                                            "assets/images/gif12.gif",
                                            fit: BoxFit.cover,
                                          ),
                                          entryAnimation: EntryAnimation.BOTTOM,
                                          buttonOkText: Text('确定',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          buttonCancelText: Text('取消',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          //buttonOkColor: Colors.redAccent,
                                          title: Text(
                                            '确定删除全部观影记录？',
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                          description: Text(
                                            'Are you sure to delete all viewing records ?',
                                            textAlign: TextAlign.center,
                                          ),
                                          onOkButtonPressed: () async {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setStringList(
                                                'historyLists', []);
                                            setState(() {
                                              historyArr = [];
                                              Navigator.of(context).pop();
                                            });
                                          },
                                        ));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: historyArr.length == 0
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Container(
                                  decoration: new BoxDecoration(
                                    //color: Colors.grey,
                                    //border: new Border.all(width: 2.0, color: Colors.red),
                                    //borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
                                    image: new DecorationImage(
                                      image: new AssetImage(
                                          'assets/images/result_null.png'),
                                      //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                                      // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor),
                              child: ListView.separated(
                                padding: new EdgeInsets.all(5.0),
                                itemCount: historyArr.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final item = historyArr[index];
                                  return Column(
                                    children: <Widget>[
                                      Dismissible(
                                          onDismissed: (_) async {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            List historyLists = prefs
                                                .getStringList('historyLists');
                                            historyLists.removeAt(index);
                                            prefs.setStringList(
                                                'historyLists', historyLists);
                                            setState(() {
                                              historyArr = historyLists;
                                            });
                                            Fluttertoast.showToast(
                                              msg: '已删除',
                                              toastLength: Toast.LENGTH_LONG,
                                            );
                                          }, // 监听
                                          movementDuration:
                                              Duration(milliseconds: 100),
                                          key: Key(item),
                                          child: SKItem(
                                            vod: Data.fromJson(json.decode(
                                                historyArr[index])['vod']),
                                            type: 'details',
                                          ))
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Divider(
                                    height: 0.0,
                                    thickness: 0.0,
                                    indent: 0,
                                    color: Theme.of(context).dividerColor,
                                  );
                                },
                              ),
                            ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
