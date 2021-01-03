import 'package:animate_do/animate_do.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:screen/screen.dart';
import 'package:skapp/iconfont/IconFont.dart';
import 'package:skapp/pages/home/category_list_view.dart';
import 'package:skapp/routers/application.dart';
import 'package:skapp/store/classify/classify.dart';
import 'package:skapp/store/root.dart';
import 'package:skapp/utils/screen_utils.dart';
import 'package:skapp/widgets/cache_img_radius.dart';
import 'package:skapp/widgets/network_img_widget.dart';
import './../../store/type/type.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  ScrollController _controller = ScrollController();
  final Type store = Type();
  final ClassifyStore classifyStore = ClassifyStore();

  Future<dynamic> requestAPI() async {
    store.fetchAllTypeData(); // 获取所有分类
    store.fetchMovieInfo(); // 获取影片总数和今日更新数
    classifyStore.fetchBannerData(); // 获取banner
    await store.fetchIndexData(); // 获取首页分类
    print(store.typeIndex.data);
    // 根据分类获取类型
    if (store.typeIndex != null &&
        store.typeIndex.code == 200 &&
        store.typeIndex.data.length > 1) {
      store.typeIndex.data.forEach((item) async {
        print(item.typeName);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    requestAPI();
  }

  @override
  Widget build(BuildContext context) {
    final Global _global = Provider.of<Global>(context);
    return Observer(
      builder: (_) => Container(
        color: Theme.of(context).cardColor,
        child: Scaffold(
            body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              classifyStore.vodBannerDataLists.length > 0
                  ? getCategoryUI(_global)
                  : Container(
                      width: 0,
                      height: 164,
                    ),
              baseInfo(_global),
              hotMovie(),
              hotMovie(),
              hotMovie(),
              hotMovie(),
              // swiper()
            ],
          ),
        )),
      ),
    );
  }

  Widget getCategoryUI(_global) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Padding(
        //   padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
        //   child: Text(
        //     '热门影片',
        //     textAlign: TextAlign.left,
        //     style: Theme.of(context).textTheme.subtitle1,
        //   ),
        // ),

        CategoryListView(
          global: _global,
          lists: classifyStore.vodBannerDataLists,
        )
      ],
    );
  }

  void moveTo() {
    print('aaaa');
  }

  // 热门
  Widget hotMovie() {
    return Padding(
      padding: EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 12.0),
            child: Row(
              children: [
                IconFont(IconNames.icondianying, size: 22),
                SizedBox(width: 6),
                Text('热门电影', style: Theme.of(context).textTheme.subtitle2)
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            height: 212.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              // physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: ((BuildContext context, int index) {
                return 1 > 0
                    ? GestureDetector(
                        onTap: () {
                          print('dada');
                          // Application.router.navigateTo(
                          //   context,
                          //   "/preview?vodId=${classifyStore.vodDataLists[index].vodId}",
                          //   transition: TransitionType.native,
                          //   transitionDuration: Duration(milliseconds: 100),
                          //   replace: true,
                          // );
                        },
                        child: FadeInUp(
                          //from: 50,
                          child: Container(
                            width: 110,
                            margin: EdgeInsets.only(left: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                AspectRatio(
                                  aspectRatio: 0.73, // 宽高比
                                  child: Container(
                                    child: CacheImgRadius(
                                      imgUrl:
                                          'https://imagestore.ncer.top/upload/vod/20201224-1/51da47f0cb4bb56ad3a421fb0db8b3aa.jpg',
                                      radius: 6,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 8, left: 6, right: 6, bottom: 8),
                                  child: Text(
                                    "精忠报国",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ))
                    : Container(
                        width: 0,
                        height: 0,
                      );
              }),
              itemCount: 10,
            ),
          )
        ],
      ),
    );
  }

  Widget baseInfo(_global) {
    return Padding(
      padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 12.0, right: 0),
            child: RichText(
              text: TextSpan(
                  style: Theme.of(context).textTheme.subtitle2,
                  children: <InlineSpan>[
                    TextSpan(text: '总影片'),
                    TextSpan(
                        text: store.movieAll != null
                            ? store.movieAll['total'].toString()
                            : '0',
                        style: _global.isDark
                            ? Theme.of(context).textTheme.subtitle2
                            : TextStyle(color: Theme.of(context).primaryColor)),
                    TextSpan(text: '  '),
                    TextSpan(text: '今日更新'),
                    TextSpan(
                        text: store.movieAll != null
                            ? store.movieAll['today'].toString()
                            : '0',
                        style: _global.isDark
                            ? Theme.of(context).textTheme.subtitle2
                            : TextStyle(color: Theme.of(context).primaryColor)),
                    TextSpan(text: ''),
                  ]),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            height: 50,
            child: ListView.builder(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: store.typeAll.length,
              itemBuilder: (BuildContext context, int index) => Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: FadeInRight(
                    child: RawChip(
                      backgroundColor: Theme.of(context).secondaryHeaderColor,
                      padding: EdgeInsets.all(0),
                      avatar: CircleAvatar(
                        // backgroundColor: Theme.of(context).cardColor,
                        child: IconFont(
                          IconNames.iconbiaoqian,
                          size: 20,
                          color: '#fff',
                        ),
                      ),
                      label: Text(
                          '${store.typeAll[index]['type_name']}:${store.typeAll[index]['total']}'),
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
