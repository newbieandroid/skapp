import 'package:animate_do/animate_do.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:skapp/iconfont/IconFont.dart';
import 'package:skapp/pages/home/category_list_view.dart';
import 'package:skapp/routers/application.dart';
import 'package:skapp/store/classify/classify.dart';
import 'package:skapp/store/root.dart';
import 'package:skapp/widgets/cache_img_radius.dart';
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
    // 根据分类获取类型
    if (store.typeIndex != null &&
        store.typeIndex.code == 200 &&
        store.typeIndex.data.length > 1) {
      store.typeIndex.data.forEach((item) {
        classifyStore.fetchVodTypeData(type: item.typeEn, typeId: item.typeId);
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
              hotMovie(
                typeName: '热播电影',
                global: _global,
                typeEn: 'dianying',
                icon: IconFont(IconNames.icondianying, size: 22),
                iconDark: IconFont(
                  IconNames.icondianying_2,
                  size: 22,
                  color: '#cccccc',
                ),
                data: classifyStore.vodMovieDataLists,
              ),
              hotMovie(
                typeName: '热播电视剧',
                global: _global,
                typeEn: 'dianshiju',
                icon: IconFont(IconNames.icondianshiju_1, size: 22),
                iconDark: IconFont(
                  IconNames.icondianshiju_1,
                  size: 22,
                  color: '#cccccc',
                ),
                data: classifyStore.vodTvDataLists,
              ),
              hotMovie(
                typeName: '热播综艺',
                global: _global,
                typeEn: 'zongyi',
                icon: IconFont(IconNames.iconyinleku, size: 22),
                iconDark: IconFont(
                  IconNames.iconyinleku,
                  size: 22,
                  color: '#cccccc',
                ),
                data: classifyStore.vodZyDataLists,
              ),
              hotMovie(
                typeName: '热播动漫',
                global: _global,
                typeEn: 'dongman',
                icon: IconFont(IconNames.iconzhuanji, size: 22),
                iconDark: IconFont(
                  IconNames.iconzhuanji,
                  size: 22,
                  color: '#cccccc',
                ),
                data: classifyStore.vodDmDataLists,
              ),
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
        //     '热播影片',
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

  // 热播
  Widget hotMovie({
    @required typeEn,
    @required typeName,
    @required icon,
    @required iconDark,
    @required global,
    @required data,
  }) {
    return Observer(
        builder: (_) => Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Row(
                      children: [
                        global.isDark ? iconDark : icon,
                        SizedBox(width: 6),
                        Text(typeName,
                            style: Theme.of(context).textTheme.subtitle2)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: 212.0,
                    child: data.length > 0
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            // physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: ((BuildContext context, int index) {
                              return 1 > 0
                                  ? GestureDetector(
                                      onTap: () {
                                        Application.router.navigateTo(
                                          context,
                                          "/preview?vodId=${data[index].vodId}",
                                          transition: TransitionType.native,
                                          transitionDuration:
                                              Duration(milliseconds: 100),
                                        );
                                      },
                                      child: FadeInUp(
                                        //from: 50,
                                        child: Container(
                                          width: 110,
                                          margin: EdgeInsets.only(left: 14),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              AspectRatio(
                                                aspectRatio: 0.73, // 宽高比
                                                child: Container(
                                                  child: CacheImgRadius(
                                                    imgUrl: data[index].vodPic,
                                                    radius: 6,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 8,
                                                    left: 6,
                                                    right: 6,
                                                    bottom: 8),
                                                child: Text(
                                                  data[index].vodName,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2,
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
                            itemCount: data.length,
                          )
                        : Container(
                            width: 0,
                            height: 0,
                          ),
                  )
                ],
              ),
            ));
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
                    TextSpan(text: '总影片 '),
                    TextSpan(
                        text: store.movieAll != null
                            ? store.movieAll['total'].toString()
                            : '0',
                        style: _global.isDark
                            ? Theme.of(context).textTheme.subtitle2
                            : TextStyle(color: Theme.of(context).primaryColor)),
                    TextSpan(text: '  '),
                    TextSpan(text: '今日更新 '),
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
