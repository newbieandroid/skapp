/// https://www.jianshu.com/p/2a87d7a68796
///
/// https://www.jianshu.com/p/c0dcce6297c9
///
/// http://www.ptbird.cn/flutter-customscrollview-floating-appbar.html
///
/// https://blog.csdn.net/nicolelili1/article/details/90640875
///
/// https://www.jianshu.com/p/38396c8e82dd

import 'dart:math' as math;
import 'dart:ui';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:skapp/routers/application.dart';

import './../../store/details/details.dart';
import './../../store/classify/classify.dart';
import './../../dao/vod_dao.dart';

import './widgets/long_comment_widget.dart';
import 'package:skapp/widgets/bottom_drag_widget.dart';
import './widgets/score_start.dart';
import 'package:skapp/widgets/detail_loading.dart';
import 'package:skapp/widgets/cache_img_radius.dart';
import './../../widgets/network_img_widget.dart';
import 'package:skapp/widgets/rating_bar.dart';
import 'package:palette_generator/palette_generator.dart';

class Preview extends StatefulWidget {
  final vodId;
  Preview({Key key, this.vodId}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _PreviewState(vodId);
}

class _PreviewState extends State<Preview> with SingleTickerProviderStateMixin {
  final vodId;
  _PreviewState(this.vodId);
  ScrollController scrollController = ScrollController();
  final DetailsStore store = DetailsStore();
  final ClassifyStore classifyStore = ClassifyStore();
  double get screenH => MediaQuery.of(context).size.height;
  double get windowH => MediaQueryData.fromWindow(window).padding.top;
  //appbar的高度
  final double appBarHeight = 80.0;
  // appbar的透明度
  double appBarAlpha = 0.0;
  // 默认主题色
  Color pickColor = Color(0xff35374c);
  // appbar中间显示问题
  bool isScrollCon = false; // 代表没滚动到appbar下面
  bool isScrollTop = false; // 代表是否滚动到顶部
  // 页面底部drag是否需要隐藏
  final GlobalKey globalKey = GlobalKey();
  bool hideBottomDrag = false;
  // 加载电影信息
  bool isLoading = true;
  //滚动方向
  String pageDirect;

  int guessCount = 10;

  //测试
  double offsetDistanceDemo;

  @override
  void initState() {
    super.initState();
    // 改变vodId
    store.changeVodId(widget.vodId);
    requestAPI();
  }

  Future<dynamic> requestAPI() async {
    await store.fetchVodData();
    var paletteGenerator = await PaletteGenerator.fromImageProvider(
        NetworkImage(store.vod.vodPic));
    setState(() {
      pickColor = paletteGenerator.darkVibrantColor != null
          ? paletteGenerator.darkVibrantColor.color
          : Color(0xff35374c);
      // pickColor = Theme.of(context).primaryColor;
    });
    store.changePickColor(true);
    // store.formatPDTbas(store.vod.vodPlayFrom);
    // store.formatPD(store.vod.vodPlayUrl);
    classifyStore.changeQuery(page: 1, limit: guessCount, type: 'score');
    // 猜你喜欢
    classifyStore.fetchVodData(typeId: store.vod.typeId);
    // 相似推荐
    classifyStore.fetchVodSameData(typeId: store.vod.typeId);
    // 同演员(默认获取第一个)
    String actor = store.vod.vodActor.split(',')[0];
    classifyStore.fetchVodSameActorData(actor: actor);
  }

  // 滚动
  void _onScroll(metrics) {
    //判断滚动方向
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      pageDirect = 'up';
    } else if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      pageDirect = 'down';
    }
    double alpha = metrics.pixels / appBarHeight;
    // 当alpha在0.9-1.0之间需要改变动画
    if (0.96 < alpha && alpha < 1 && pageDirect == 'up') {
      isScrollCon = true;
    } else if (0.96 < alpha && alpha < 1 && pageDirect == 'down') {
      isScrollCon = false;
    }
    if (alpha <= 0) {
      alpha = 0;
      isScrollCon = false;
    } else if (alpha >= 1) {
      alpha = 1;
      isScrollCon = true;
    } else {
      isScrollCon = false;
    }
    RenderBox box = globalKey.currentContext.findRenderObject();
    Offset offset = box.localToGlobal(Offset.zero);
    if (offset.dy <= appBarHeight + windowH) {
      isScrollTop = true;
    } else {
      isScrollTop = false;
    }
    if (offset.dy < screenH - appBarHeight + windowH) {
      hideBottomDrag = true;
    } else {
      hideBottomDrag = false;
    }
    setState(() {
      appBarAlpha = alpha;
    });
    // print(metrics.atEdge); //是否在顶部或底部
    // print(metrics.axis); //垂直或水平滚动
    // print(metrics.axisDirection); // 滚动方向是down还是up
    // print(metrics.extentAfter); //视口底部距离列表底部有多大
    // print(metrics.extentBefore); //视口顶部距离列表顶部有多大
    // print(metrics.extentInside); //视口范围内的列表长度
    // print(metrics.maxScrollExtent); //最大滚动距离，列表长度-视口长度
    // print(metrics.minScrollExtent); //最小滚动距离
    // print(metrics.viewportDimension); //视口长度
    // print(metrics.outOfRange); //是否越过边界
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => (store.isLoading)
          ? SafeArea(
              top: false,
              bottom: false,
              child: Scaffold(
                body: DetailLoadingShimmerWidget(),
              ),
            )
          : store.pickColor
              ? SafeArea(
                  top: false,
                  bottom: false,
                  child: Scaffold(
                    backgroundColor: pickColor,
                    body: BottomDragWidget(
                      body: NotificationListener<ScrollUpdateNotification>(
                        onNotification: (ScrollNotification notification) {
                          if (notification is ScrollUpdateNotification &&
                              notification.depth == 0) {
                            ScrollMetrics metrics = notification.metrics;
                            _onScroll(metrics);
                          }
                          return true;
                        },
                        child: Stack(
                          children: <Widget>[
                            CustomScrollView(
                              controller: scrollController,
                              slivers: <Widget>[
                                sliverTitle(),
                                sliverRating(),
                                sliverDesc(),
                                sliverCasts(),
                                sliverBottom(classifyStore)
                              ],
                            ),
                            Opacity(
                              opacity: appBarAlpha,
                              child: Container(
                                height: appBarHeight,
                                decoration:
                                    BoxDecoration(color: pickColor, boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 0),
                                      color: Color.fromRGBO(0, 0, 0, 0.3),
                                      blurRadius: 1.0,
                                      spreadRadius: 0)
                                ]),
                              ),
                            ),
                            Positioned(
                              top: 0.0,
                              left: 0,
                              right: 0,
                              height: appBarHeight,
                              child: AppBar(
                                leading: IconButton(
                                  icon: Icon(Icons.arrow_back_ios),
                                  color: Colors.white,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                centerTitle: isScrollCon ? false : true,
                                title: isScrollCon
                                    ? LogoAnimate(direct: 'up', vod: store.vod)
                                    : LogoAnimateOther(
                                        direct: 'down', vod: store.vod),
                              ),
                            ),
                          ],
                        ),
                      ),
                      dragContainer: DragContainer(
                          drawer: hideBottomDrag
                              ? Container(
                                  width: 0,
                                  height: 0,
                                )
                              : Container(
                                  child: OverscrollNotificationWidget(
                                    child: LongCommentTabView(
                                      store: classifyStore,
                                      scroll: true,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 243, 244, 248),
                                      borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(10.0),
                                          topRight:
                                              const Radius.circular(10.0))),
                                ),
                          defaultShowHeight: screenH * 0.1,
                          height: screenH - appBarHeight),
                    ),
                  ),
                )
              : SafeArea(
                  top: false,
                  bottom: false,
                  child: Scaffold(
                    body: DetailLoadingShimmerWidget(),
                  ),
                ),
    );
  }

  SliverToBoxAdapter sliverTitle() {
    return SliverToBoxAdapter(
      child: Container(
        padding: padding(),
        child: // 影片详情
            Container(
          margin: EdgeInsets.only(
            top: appBarHeight + 10,
            bottom: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 94,
                child: AspectRatio(
                  aspectRatio: 0.73, // 宽高比
                  child: NetworkImgWidget(
                    imgUrl: store.vod.vodPic,
                    radius: 4,
                  ),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${store.vod.vodName}( ${store.vod.vodRemarks} )',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          '${store.vod.vodClass}',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                        Text(
                          '${store.vod.vodArea}(${store.vod.vodYear})',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                        Text(
                          '${store.vod.vodActor}',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                        // 按钮
                        Row(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(right: 10, top: 10),
                                child: BtnWidget(
                                    icon: Icons.play_arrow,
                                    text: '立即观看',
                                    vodId: store.vod.vodId)),
                          ],
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter sliverRating() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(top: 15.0, bottom: 25.0),
        margin: padding(),
        child: ScoreStartWidget(
          score: store.vod.vodScore < 0 ? 0.0 : store.vod.vodScore,
          scoreNum: store.vod.vodScoreNum,
          hitsWeek: store.vod.vodHitsWeek,
          hitsMonth: store.vod.vodHitsMonth,
          p1: 5 / 100,
          p2: store.vod.vodScoreNum / store.vod.vodScoreAll,
          p3: 20 / 100,
          p4: 1 - store.vod.vodScoreNum / store.vod.vodScoreAll,
          p5: 20 / 100,
        ),
      ),
    );
  }

  SliverToBoxAdapter sliverDesc() {
    return SliverToBoxAdapter(
      child: Container(
        padding: padding(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text('简介',
                  style: TextStyle(fontSize: 14, color: Colors.white)),
            ),
            Text(store.vod.vodContent.replaceAll(RegExp(r"<\/?[^>]*>"), ""),
                style: TextStyle(fontSize: 12, color: Colors.white))
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter sliverCasts() {
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          Padding(
            padding:
                EdgeInsets.only(top: 25.0, bottom: 16.0, left: 14, right: 14),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text('猜你喜欢',
                        style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          Container(
            height: 196.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              // physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: ((BuildContext context, int index) {
                return classifyStore.vodDataLists.length > 0
                    ? GestureDetector(
                        onTap: () {
                          Application.router.navigateTo(
                            context,
                            "/preview?vodId=${classifyStore.vodDataLists[index].vodId}",
                            transition: TransitionType.native,
                            transitionDuration: Duration(milliseconds: 100),
                            replace: true,
                          );
                        },
                        child: Container(
                          width: 100,
                          margin: EdgeInsets.only(right: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AspectRatio(
                                aspectRatio: 0.73, // 宽高比
                                child: Container(
                                  child: CacheImgRadius(
                                    imgUrl: classifyStore
                                        .vodDataLists[index].vodPic,
                                    radius: 4,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 8, left: 6, right: 6, bottom: 8),
                                child: Text(
                                  classifyStore.vodDataLists[index].vodName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : Container(
                        width: 0,
                        height: 0,
                      );
              }),
              itemCount: guessCount,
            ),
          )
        ],
      ),
    );
  }

  padding() {
    return EdgeInsets.only(left: 14, right: 14);
  }

  getPadding(Widget body) {
    return Padding(
      padding: EdgeInsets.only(right: 14),
      child: body,
    );
  }

  // 底部话题讨论
  SliverToBoxAdapter sliverBottom(ClassifyStore store) {
    return SliverToBoxAdapter(
      child: Container(
        key: globalKey,
        height: screenH - appBarHeight,
        child: Container(
          child: OverscrollNotificationWidget(
            child: LongCommentTabView(
              store: store,
              scroll: isScrollTop,
            ),
          ),
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 243, 244, 248),
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0))),
        ),
      ),
    );
  }
}

//按钮widget
class BtnWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final vodId;
  const BtnWidget({Key key, @required this.icon, this.text, this.vodId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.only(left: 4, right: 16),
      height: 34,
      color: Colors.white,
      textColor: Colors.black,
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: Colors.orange,
            size: 26,
          ),
          Container(
            margin: EdgeInsets.only(left: 4),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                //fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      onPressed: () {
        Application.router.navigateTo(
          context,
          "/details?vodId=${this.vodId}",
          transition: TransitionType.native,
          transitionDuration: Duration(milliseconds: 100),
          replace: true,
        );
      },
    );
  }
}

// #docregion LogoWidget
class LogoAnimate extends StatelessWidget {
  final String direct;
  final VodDao vod;
  const LogoAnimate({Key key, @required this.direct, @required this.vod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LogoApp(direct: this.direct, vod: vod),
    );
  }
}

class LogoAnimateOther extends StatelessWidget {
  final String direct;
  final VodDao vod;
  const LogoAnimateOther({Key key, @required this.direct, @required this.vod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LogoApp(direct: this.direct, vod: vod),
    );
  }
}

// 头部电影名字展示
class AppBarInfo extends StatelessWidget {
  final String name;
  final num rating;
  final String imgUrl;
  AppBarInfo({Key key, this.name, this.rating, this.imgUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: 50,
          padding: EdgeInsets.only(top: 2, right: 8),
          child: CacheImgRadius(
            imgUrl: this.imgUrl,
            radius: 4,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                this.name,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              RatingBar(
                this.rating,
                size: 13,
                fontSize: 11,
              )
            ],
          ),
        )
      ],
    );
  }
}
// #enddocregion LogoWidget

// #docregion GrowTransition
class GrowTransition extends StatelessWidget {
  GrowTransition({this.child, this.animation, this.offset});
  final double offset;
  final Widget child;
  final Animation<double> animation;

  Widget build(BuildContext context) => Container(
        child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) => Stack(
                  children: <Widget>[
                    Positioned(
                      child: Transform.translate(
                        offset: Offset(0, animation.value),
                        child: Opacity(
                          opacity: 1 - animation.value / offset,
                          child: child,
                        ),
                      ),
                    ),
                    Positioned(
                        child: Center(
                      child: Transform.translate(
                        offset: Offset(-26, animation.value),
                        child: Opacity(
                            opacity: animation.value / offset,
                            child: Text(
                              '影片',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            )),
                      ),
                    ))
                  ],
                ),
            child: child),
      );
}
// #enddocregion GrowTransition

class LogoApp extends StatefulWidget {
  final String direct;
  final VodDao vod;
  LogoApp({Key key, @required this.direct, @required this.vod})
      : super(key: key);
  _LogoAppState createState() => _LogoAppState();
}

// #docregion print-state
class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  final double offset = 14.0;
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 220),
      vsync: this,
    );
    animation = widget.direct == 'up'
        ? Tween<double>(begin: offset, end: 0).animate(controller)
        : Tween<double>(begin: 0, end: offset).animate(controller);
    controller.forward();
  }
  // #enddocregion print-state

  @override
  Widget build(BuildContext context) => GrowTransition(
        offset: offset,
        child: AppBarInfo(
          name: widget.vod.vodName,
          rating: widget.vod.vodScore < 0 ? 0.0 : widget.vod.vodScore,
          imgUrl: widget.vod.vodPic,
        ),
        animation: animation,
      );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  // #docregion print-state
}
