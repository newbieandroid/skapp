import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skapp/pages/search/sklist.dart';
import './../../store/root.dart';
import './../../widgets/search_text_field_widget.dart';
import './../../store/search/search.dart';
import './../../store/type/type.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final SearchStore store = SearchStore();
  final Type typeStore = Type();
  final FocusNode focus = FocusNode();
  TextEditingController searchController = TextEditingController();

  // 定义历史记录数组
  List historyArr = [];

  Future<dynamic> getHis() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List historyLists = prefs.getStringList('historySearchLists') ?? [];
    setState(() {
      historyArr = historyLists;
    });
  }

  Future<dynamic> handleHistory(String value) async {
    // status init or change
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> historyLists = prefs.getStringList('historySearchLists') ?? [];
// 循环判断是否有重复数据
    bool isRepeat = false;
    for (int i = 0; i < historyLists.length; i++) {
      var js = historyLists[i];
      if (js == value) {
        isRepeat = true;
      }
    }
    if (!isRepeat) {
      historyLists.insert(0, value);
      prefs.setStringList('historySearchLists', historyLists);
    }
  }

  search(value, _global) {
    if (value.trim() != '') {
      store.resetData();
      store.changeSearchKey(value);
      store.fetchData(searchKey: value);
      // 保存搜索历史
      handleHistory(value);

      focus.unfocus();
    }
  }

  Future<dynamic> requestAPI() async {
    await typeStore.fetchData();
    await getHis();
  }

  @override
  void initState() {
    super.initState();
    requestAPI();
  }

  renderAppBar(_global) {
    return AppBar(
      elevation: 1,
      title: Observer(
        builder: (_) => Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child: SearchTextFieldWidget(
                  controller: searchController,
                  focus: focus,
                  hintText: '输入影片名称',
                  margin: EdgeInsets.only(left: 0.0, right: 0.0),
                  onSubmitted: (value) {
                    search(value, _global);
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  search(searchController.text, _global);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    '搜索',
                    //style: Theme.of(context).textTheme.bodyText2,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
          alignment: Alignment(0.0, 0.0),
        ),
      ),
    );
  }

  renderResult(_global) {
    return Observer(
        builder: (_) => store.isLoading
            ? _global.isDark
                ? PKDarkCardListSkeleton(
                    isCircularImage: true,
                    isBottomLinesActive: true,
                  )
                : PKCardListSkeleton(
                    isCircularImage: true,
                    isBottomLinesActive: true,
                  )
            : store.first
                ? _panel(context, historyArr, _global)
                : store.searchLists.length == 0
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Container(
                            // height: ScreenUtils.screenH(context),
                            decoration: new BoxDecoration(
                              //color: Colors.grey,
                              //border: new Border.all(width: 2.0, color: Colors.red),
                              //borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
                              image: new DecorationImage(
                                image: new AssetImage(
                                    'assets/images/search_null.png'),
                                //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                                // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                              ),
                            ),
                            alignment: Alignment.center,
                          ),
                        ),
                      )
                    : SKList(store: store));
  }

  Widget _panel(context, historyLists, _global) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: ListView.separated(
        padding: new EdgeInsets.all(5.0),
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              return Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      '搜索历史',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    // top: 0,
                    bottom: -2,
                    child: IconButton(
                      iconSize: 18,
                      icon: Icon(
                        Icons.delete,
                      ),
                      padding: EdgeInsets.all(0.0),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setStringList('historySearchLists', []);
                        setState(() {
                          historyArr = [];
                        });
                      },
                    ),
                  )
                ],
              );
            case 1:
              return Padding(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: List.generate(historyLists.length, (index) {
                      return InkWell(
                        onTap: () {
                          searchController.text = historyLists[index];
                          search(searchController.text, _global);
                        },
                        child: Chip(
                          backgroundColor: _global.isDark
                              ? Theme.of(context).cardColor
                              : Theme.of(context).buttonColor,
                          label: Text(historyLists[index],
                              style: Theme.of(context).textTheme.bodyText2),
                        ),
                      );
                    }),
                  ),
                ),
              );

            default:
              return Container(
                width: 0,
                height: 0,
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

  @override
  Widget build(BuildContext context) {
    final Global _global = Provider.of<Global>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: renderAppBar(_global),
      body: SafeArea(
        child: renderResult(_global),
      ), // https://www.jianshu.com/p/86d29a939624
    );
  }
}
