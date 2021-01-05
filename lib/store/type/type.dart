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

import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './../../dao/type_dao.dart';
import './../../http/API.dart';
import './../../http/http_request.dart';

/// 必须, 用于生成.g文件
part 'type.g.dart';

class Type = TypeMobx with _$Type;

abstract class TypeMobx with Store {
  String url = API.TYPE_URL;

  @observable
  bool isLoading = true;

  @observable
  SkType type; // 分类

  @observable
  SkType typeIndex; // 首页分类

  @observable
  ObservableList typeAll = ObservableList();

  @observable
  var movieAll;

  @observable
  int currentSearchTypeIndex = 0;

  @action
  Future<dynamic> fetchData() async {
    this.isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cIp = prefs.getString('ip') ?? API.BASE_SK_URL;
    String preApiUrl = API.PRE_API_URL;
    var req = HttpRequest(cIp);
    final res = await req.get(preApiUrl + url);
    this.type = SkType.fromJson(res);
    /* 
      首页
      data['type_id'] = this.typeId;
      data['type_name'] = this.typeName;
      data['type_en'] = this.typeEn;
     */
    var home = {'type_id': 10000, 'type_name': '首页', 'type_en': 'homepage'};
    this.type.data.insert(0, Data.fromJson(home));
  }

  // 获取首页分类
  @action
  Future<dynamic> fetchIndexData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cIp = prefs.getString('ip') ?? API.BASE_SK_URL;
    String preApiUrl = API.PRE_API_URL;
    var req = HttpRequest(cIp);
    final res = await req.get(preApiUrl + url);
    this.typeIndex = SkType.fromJson(res);
  }

  // 获取所有分类信息
  @action
  Future<dynamic> fetchAllTypeData() async {
    this.isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cIp = prefs.getString('ip') ?? API.BASE_SK_URL;
    String preApiUrl = API.PRE_API_URL;
    var req = HttpRequest(cIp);
    final res = await req.get(preApiUrl + API.TYPE_ALL);
    typeAll.addAll(res['data']);
  }

  // 获取影片信息
  @action
  Future<dynamic> fetchMovieInfo() async {
    this.isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cIp = prefs.getString('ip') ?? API.BASE_SK_URL;
    String preApiUrl = API.PRE_API_URL;
    var req = HttpRequest(cIp);
    final res = await req.get(preApiUrl + API.MOVIE_ALL);
    movieAll = res['data'];
  }

  @action
  void changeLoading() {
    this.isLoading = false;
  }

  @action
  void changeCurrentSearchTypeIndex(int index) {
    this.currentSearchTypeIndex = index;
  }
}
