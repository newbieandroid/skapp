import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import 'package:provider/provider.dart';
import 'package:skapp/pages/classify/skgriditem.dart';
import 'package:skapp/pages/classify/skitem.dart';
import 'package:skapp/store/root.dart';
import 'package:skapp/store/search/search.dart';
import 'package:skapp/widgets/network_img_widget.dart';
import './../../store/classify/classify.dart';

// ignore: must_be_immutable
class SKList extends StatefulWidget {
  SearchStore store;
  SKList({Key key, @required this.store}) : super(key: key);

  @override
  _SKListState createState() => _SKListState(store);
}

class _SKListState extends State<SKList> with AutomaticKeepAliveClientMixin {
  SearchStore store;
  _SKListState(this.store);
  final ScrollController scrollController = ScrollController(); // 下拉加载

  // 下拉刷新
  Future onRefresh() {
    // 重新请求接口
    store.resetData();
    return Future(() {
      store.fetchData(searchKey: store.searchKey);
    });
  }

  //上拉加载
  Future loadMoreData() {
    return Future(() async {
      store.changeQuery(page: store.qPage + 1);
      await store.fetchData(searchKey: store.searchKey);
    });
  }

  @override
  void initState() {
    super.initState();
    // requestAPI();
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
    // final Global _global = Provider.of<Global>(context);
    return Observer(
      builder: (_) => Container(
        color: Theme.of(context).cardColor,
        child: RefreshIndicator(
          onRefresh: this.onRefresh,
          child: IncrementallyLoadingListView(
            loadMore: () async {
              await loadMoreData();
            },
            hasMore: () => store.hasNextPage,
            itemCount: () => store.searchLists.length + 1 ?? 1,
            itemBuilder: (BuildContext context, int index) {
              if (index < store.searchLists.length) {
                return Column(
                  children: <Widget>[
                    SKItem(
                      vod: store.searchLists[index],
                      type: 'details',
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
            },
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
