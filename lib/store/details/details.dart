/*
 * Created: 2020-04-07 15:55:59
 * Author : Mockingbird
 * Email : 1768385508@qq.com
 * -----
 * Description:
              1. 执行命令: flutter packages pub run build_runner build
              2. 删除之内再生成: flutter packages pub run build_runner build --delete-conflicting-outputs
              3. 实时更新.g文件: flutter packages pub run build_runner watch
 */

import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './../../dao/vod_dao.dart';
import './../../http/API.dart';
import './../../http/http_request.dart';

/// 必须, 用于生成.g文件
part 'details.g.dart';

class DetailsStore = DetailsStoreMobx with _$DetailsStore;

abstract class DetailsStoreMobx with Store {
  String playSplit = r'$$$'; // 播放器
  String singleSplit = r'#'; // 每一集
  String split = r'$'; // 每一集再分
  String detailsUrl = API.VOD_DETAILS_URL; // 详情

  @observable
  bool isLoading = true;

  @observable
  bool showAd = true; // 是否显示loading

  @observable
  bool isDlna = false; // 是否投屏

  @observable
  bool pickColor = false;

  @observable
  String vodId;

  @observable
  VodDao vod;

  @observable
  ObservableList players = ObservableList();

  @observable
  ObservableList pTabs = ObservableList();

  @observable
  ObservableList vipLists = ObservableList();

  @observable
  int currentTabs = 0; // sid

  @observable
  int currentPlayers = 0; // nid

  @observable
  bool isClickPlayers = false; // 是否点击了切换

  // @computed
  // String get currentUrl {
  //   return players[currentTabs][currentPlayers]['url'] ?? '';
  // }
  @observable
  String currentUrl = '';

  @action
  void changeShowAd(bool showAd) {
    this.showAd = showAd;
  }

  @action
  void formatPD(String vodPlayUrl) {
    players.clear();
    List a = vodPlayUrl.split(playSplit);
    for (var index = 0; index < a.length; index++) {
      players.add([]);
      // 判断是不是有集数
      if (a[index].indexOf(singleSplit) >= 0) {
        List c = a[index].split(singleSplit);
        c.forEach((v) {
          List d = v.split(split);
          players[index].add({
            'label': d[0],
            'url': d[1],
          });
        });
      } else {
        List e = a[index].split(split);
        if (e.length == 1) {
          players[index].add({
            'label': '高清',
            'url': e[0],
          });
        } else {
          players[index].add({
            'label': e[0],
            'url': e[1],
          });
        }
      }
    }
    // 更改当前播放路径
    setCurrentUrl('init');
  }

  @action
  void formatPDTbas(String vodPlayFrom) {
    pTabs.addAll(vodPlayFrom.split(playSplit));
  }

  @action
  void changeVodId(String vodId) {
    this.vodId = vodId;
  }

  @action
  void changePickColor(bool v) {
    this.pickColor = v;
  }

  @action
  Future<dynamic> fetchVodData() async {
    this.isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cIp = prefs.getString('ip') ?? API.BASE_SK_URL;
    bool isMusic = prefs.getBool('isMusic') ?? false;
    String preApiUrl = isMusic ? API.PRE_MUSIC_API_URL : API.PRE_API_URL;
    var req = HttpRequest(cIp);
    final res = await req.get(preApiUrl + detailsUrl + vodId);
    this.vod = VodDao.fromJson(res['data']);
    // 获取解析接口
    if (!isMusic) {
      await getVipInfo();
    }
    this.isLoading = false;
  }

  // 获取解析地址
  Future<dynamic> getVipInfo() async {
    var req = HttpRequest(API.BASE_SK_URL);
    final res = await req.get(API.APP_VIDEO_INFO);
    vipLists.addAll(res);
  }

  @action
  void changeCurrentTabs(int current) {
    currentTabs = current;
  }

  @action
  void changeCurrentPlayers(int current) {
    isClickPlayers = true;
    currentPlayers = current;
    currentUrl = "";
    setCurrentUrl('change');
  }

  @action
  void changeIsClickPlayers() {
    isClickPlayers = false;
  }

  @action
  void changeDlna(bool v) {
    isDlna = v;
  }

  // 自动播放下一集
  @action
  void playNext() {
    // 判断当前和总数
    if (currentPlayers < players[currentTabs].length - 1) {
      currentPlayers = currentPlayers + 1;
      Future.delayed(Duration(milliseconds: 600), () {
        changeCurrentPlayers(currentPlayers);
      });
    }
  }

  @action
  Future<dynamic> setCurrentUrl(String status) async {
    // 保存历史记录
    await handleHistory(status);
    currentUrl = "";
    String url = players[currentTabs][currentPlayers]['url'];
    // test
    //String url = r"高清$http://v.youku.com/v_show/id_XNDk3OTY0OTkwNA==.html";
    bool isvip = isVipVideo(url);
    if (isvip) {
      // 请求解析接口
      if (vipLists.length == 0) {
        Fluttertoast.showToast(
          msg: '没有找到资源，请切换播放源',
          toastLength: Toast.LENGTH_LONG,
        );
      } else {
        // Fluttertoast.showToast(
        //   msg: '努力加载中...',
        //   toastLength: Toast.LENGTH_LONG,
        // );
        var req = HttpRequest(vipLists[0]['prefix']);
        final res = await req.get(vipLists[0]['url'] + url);
        /* 
        code: 404|200
        type: hls
      */
        if (int.parse(res['code']) == 200) {
          // Fluttertoast.showToast(
          //   msg: '连接成功,即将开始播放',
          // );
          currentUrl = res['url'];
        } else {
          Fluttertoast.showToast(msg: '没有找到资源，请切换播放源');
        }
      }
    } else {
      // 延迟
      Future.delayed(Duration(milliseconds: 600), () {
        currentUrl = url;
      });
    }
  }

  Future<dynamic> handleHistory(String status) async {
    // status init or change
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> historyLists = prefs.getStringList('historyLists') ?? [];
    // 判断是否重复
    // if (historyLists.length >= 200) {
    //     Fluttertoast.showToast(
    //       msg: '',
    //       toastLength: Toast.LENGTH_LONG,
    //     );
    //   } else {
// 循环判断是否有重复数据
    bool isRepeat = false;
    for (int i = 0; i < historyLists.length; i++) {
      var js = json.decode(historyLists[i]);
      if (js['vodId'] == vodId) {
        // 电影重复，历史记录中有这条记录
        if (status == 'init') {
          currentTabs = js['sid'] ?? 0;
          currentPlayers = js['nid'] ?? 0;
        } else if (status == 'change') {
          js['sid'] = currentTabs;
          js['nid'] = currentPlayers;
          //historyLists.fillRange(i, i, json.encode(js));
          historyLists[i] = json.encode(js);
          prefs.setStringList('historyLists', historyLists);
        }

        isRepeat = true;
      }
    }
    if (!isRepeat) {
      // 重新构造数据
      var obj = {
        'sid': currentTabs,
        'nid': currentPlayers,
        'vodId': vodId,
        'vod': vod
      };
      historyLists.insert(0, json.encode(obj));
      prefs.setStringList('historyLists', historyLists);
    } else {}
    //}
  }

  static bool isVipVideo(String url) {
    RegExp checkUrl = new RegExp(
        r'(tv.cctv.com)|(www.le.com)|(www.mgtv.com)|(v.youku.com)|(v.qq.com)|(www.iqiyi.com)|(tv.sohu.com)|(www.m1905.com)|(v.pptv.com)');
    return checkUrl.hasMatch(url);
  }
}
