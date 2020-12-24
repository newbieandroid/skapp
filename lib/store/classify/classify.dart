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

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './../../dao/classify_type_dao.dart';
import './../../dao/vod_list_dao.dart';
import './../../http/API.dart';
import './../../http/http_request.dart';

/// 必须, 用于生成.g文件
part 'classify.g.dart';

class ClassifyStore = ClassifyStoreMobx with _$ClassifyStore;

abstract class ClassifyStoreMobx with Store {
  String typeUrl = API.CLASSIFY_TYPE_URL; // 子分类
  String vodUrl = API.VOD_LIST_URL; // 列表

  @observable
  bool isLoading = true;

  @observable
  bool isVodLoading = true;

  @observable
  ClassifyTypeDao type; // 分类

  @observable
  VodListDao vodData; // 获取电影列表

  @observable
  VodListDao vodSameData; // 获取电影列表

  @observable
  VodListDao vodSameActorData; // 获取电影列表

  @observable
  bool hasNextPage = true;

  @observable
  ObservableList vodDataLists = ObservableList(); // 获取电影列表

  @observable
  ObservableList vodDataSameLists = ObservableList(); // 相似推荐

  @observable
  ObservableList vodDataSameActorLists = ObservableList(); // 相同主演

  @observable
  num qPage = 1;

  @observable
  num qLimit = 15;

  @observable
  String qType = 'updateTime';

  @action
  Future<dynamic> fetchTypeData({@required typeId}) async {
    this.isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cIp = prefs.getString('ip') ?? API.BASE_SK_URL;
    String preApiUrl = API.PRE_API_URL;
    var req = HttpRequest(cIp);
    final res = await req.get(preApiUrl + typeUrl + typeId.toString());
    this.type = ClassifyTypeDao.fromJson(res);
  }

  @action
  Future<dynamic> fetchVodData({@required typeId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cIp = prefs.getString('ip') ?? API.BASE_SK_URL;
    String preApiUrl = API.PRE_API_URL;
    var req = HttpRequest(cIp);
    String query = '?typeId=$typeId&page=$qPage&limit=$qLimit&type=$qType';
    final res = await req.get(preApiUrl + vodUrl + query);
    this.vodData = VodListDao.fromJson(res);
    vodDataLists.addAll(this.vodData.data);
    // 判断是否加载完成
    if (this.vodData.data.length < qLimit) {
      // 代表返回的数据不到要求的数据
      hasNextPage = false;
    }
  }

  // 相似推荐(人气)
  @action
  Future<dynamic> fetchVodSameData({@required typeId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cIp = prefs.getString('ip') ?? API.BASE_SK_URL;
    String preApiUrl = API.PRE_API_URL;
    var req = HttpRequest(cIp);
    String query = '?typeId=$typeId&page=1&limit=9&type=monthHits';
    final res = await req.get(preApiUrl + vodUrl + query);
    this.vodSameData = VodListDao.fromJson(res);
    vodDataSameLists.addAll(this.vodSameData.data);
  }

  // 相同主演
  @action
  Future<dynamic> fetchVodSameActorData({@required actor}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cIp = prefs.getString('ip') ?? API.BASE_SK_URL;
    String preApiUrl = API.PRE_API_URL;
    var req = HttpRequest(cIp);
    String query = '?page=1&limit=9&type=monthHits&actor=$actor';
    final res = await req.get(preApiUrl + vodUrl + query);
    this.vodSameActorData = VodListDao.fromJson(res);
    vodDataSameActorLists.addAll(this.vodSameActorData.data);
  }

  @action
  void changeQuery({page, limit = 10, type = 'hot'}) {
    this.qPage = page;
    qLimit = limit;
    qType = type;
  }

  @action
  void changeLoading() {
    this.isLoading = false;
  }

  @action
  void changeVodLoading() {
    this.isVodLoading = false;
  }

  @action
  void resetData() {
    qPage = 1;
    qLimit = 10;
    qType = 'updateTime';
    vodDataLists.clear();
  }
}
