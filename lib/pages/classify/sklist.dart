import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import 'package:provider/provider.dart';
import 'package:skapp/pages/classify/skgriditem.dart';
import 'package:skapp/store/root.dart';
import 'package:skapp/utils/screen_utils.dart';
import './../../store/classify/classify.dart';
import './skitem.dart';
import 'package:flutter_unionad/flutter_unionad.dart' as FlutterUnionad;

// ignore: must_be_immutable
class SKList extends StatefulWidget {
  num typeId;
  SKList({Key key, @required this.typeId}) : super(key: key);

  @override
  _SKListState createState() => _SKListState(typeId);
}

class _SKListState extends State<SKList> with AutomaticKeepAliveClientMixin {
  num typeId;
  _SKListState(this.typeId);
  final ClassifyStore store = ClassifyStore();
  ScrollController scrollController = ScrollController(); // 下拉加载

  Future<dynamic> requestAPI() async {
    await store.fetchVodData(typeId: typeId);
    store.changeVodLoading();
  }

  // 下拉刷新
  Future onRefresh() {
    // 重新请求接口
    store.resetData();
    return Future(() {
      store.fetchVodData(typeId: typeId);
    });
  }

  //上拉加载
  Future loadMoreData() {
    return Future(() async {
      store.changeQuery(page: store.qPage + 1);
      await store.fetchVodData(typeId: typeId);
    });
  }

  @override
  void initState() {
    super.initState();
    requestAPI();
    // 给列表滚动添加监听
    scrollController.addListener(() {
      // 滑动到底部的关键判断
      if (scrollController.position.pixels >=
          this.scrollController.position.maxScrollExtent) {
        loadMoreData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Global _global = Provider.of<Global>(context);
    return Observer(
      builder: (_) => Container(
        color: Theme.of(context).cardColor,
        child: RefreshIndicator(
          onRefresh: this.onRefresh,
          child: store.isVodLoading
              ? // list skeleton
              _global.isDark
                  ? PKDarkCardListSkeleton(
                      isCircularImage: true,
                      isBottomLinesActive: true,
                      length: 10,
                    )
                  : PKCardListSkeleton(
                      isCircularImage: true,
                      isBottomLinesActive: true,
                      length: 10,
                    )
              : IncrementallyLoadingListView(
                  loadMore: () async {
                    await loadMoreData();
                  },
                  hasMore: () => store.hasNextPage,
                  itemCount: () => _global.isShowList
                      ? store.vodDataLists.length + 1 ?? 1
                      : ((store.vodDataLists.length + 1) / 3).ceil() ?? 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (_global.isShowList) {
                      if (index < store.vodDataLists.length) {
                        return Column(
                          children: <Widget>[
                            SKItem(
                              vod: store.vodDataLists[index],
                              type: 'preview',
                            )
                          ],
                        );
                      } else {
                        return Center(
                            child: Container(
                          padding: EdgeInsets.all(14.0),
                          child: Text(
                            '-- THE END --',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ));
                      }
                    } else {
                      if (index < (store.vodDataLists.length / 3).ceil()) {
                        // 展示banner广告
                        if (index % 4 == 0 &&
                            index != 0 &&
                            _global.appAds.bannerCsj.show == true) {
                          return Column(
                            children: [
                              bannerWidget(_global),
                              gridWidget(index),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              gridWidget(index),
                            ],
                          );
                        }
                      } else {
                        return Center(
                            child: Container(
                          padding: EdgeInsets.all(14.0),
                          child: Text(
                            '-- THE END --',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ));
                      }
                    }
                  }),
        ),
      ),
    );
  }

  Widget bannerWidget(_global) {
    return FlutterUnionad.bannerAdView(
        androidCodeId:
            _global.appAds.bannerCsj.androidId, //andrrid banner广告id 必填
        iosCodeId: _global.appAds.bannerCsj.iosId, //ios banner广告id 必填
        supportDeepLink: true, //是否支持 DeepLink 选填
        expressAdNum: 1, //一次请求广告数量 大于1小于3 选填
        expressTime: 30, //轮播间隔事件 秒  选填
        expressViewWidth: ScreenUtils.screenW(context), // 期望view 宽度 dp 必填
        expressViewHeight: 120.5, //期望view高度 dp 必填
        callBack: (FlutterUnionad.FlutterUnionadState state) {
          //广告事件回调 选填
          //type onShow广告成功显示 onDislike不感兴趣 onFail广告加载失败
          //params 详细说明
          switch (state.type) {
            case FlutterUnionad.onShow:
              print(state.tojson());
              break;
            case FlutterUnionad.onFail:
              print(state.tojson());
              break;
            case FlutterUnionad.onDislike:
              print(state.tojson());
              break;
          }
        });
  }

  Widget gridWidget(index) {
    return GridView.builder(
        shrinkWrap: true,
        itemCount: 3,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.5,
        ),
        itemBuilder: (context, gridiIndex) {
          return SKGridItem(
            vod: store.vodDataLists[index * 3 + gridiIndex],
            type: 'preview',
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
