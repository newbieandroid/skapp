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
import 'package:skapp/dao/vod_list_dao.dart';
import './../../http/API.dart';
import './../../http/http_request.dart';
import './../../dao/search_dao.dart';

/// 必须, 用于生成.g文件
part 'search.g.dart';

class SearchStore = SearchStoreMobx with _$SearchStore;

abstract class SearchStoreMobx with Store {
  String searchUrl = API.SEARCH_PAGES_URL;

  @observable
  bool isLoading = false;

  @observable
  bool hasNextPage = true;

  @observable
  bool first = true;

  @observable
  num qPage = 1;

  @observable
  num qLimit = 10;

  @observable
  String searchKey = '';

  @observable
  VodListDao searchData; // 获取电影列表

  @observable
  ObservableList searchLists = ObservableList();

  @action
  void changeQuery({page, limit = 10}) {
    this.qPage = page;
    qLimit = limit;
  }

  @action
  Future<dynamic> fetchData({@required searchKey}) async {
    if (qPage == 1) {
      this.isLoading = true;
    }
    this.first = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cIp = prefs.getString('ip') ?? API.BASE_SK_URL;
    String preApiUrl = API.PRE_API_URL;
    var req = HttpRequest(cIp);
    String query = '$searchKey&page=$qPage&limit=$qLimit';
    final res = await req.get(preApiUrl + searchUrl + query);
    this.searchData = VodListDao.fromJson(res);
    searchLists.addAll(this.searchData.data);
    this.isLoading = false;
    // 判断是否加载完成
    if (this.searchData.data.length < qLimit) {
      // 代表返回的数据不到要求的数据
      changeNextPage(false);
    }
  }

  @action
  void changeSearchKey(String key) {
    searchKey = key;
  }

  @action
  void changeNextPage(bool v) {
    hasNextPage = v;
  }

  @action
  void resetData() {
    qPage = 1;
    qLimit = 10;
    changeNextPage(true);
    searchLists.clear();
  }
}
