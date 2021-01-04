import 'package:fluro/fluro.dart';
import 'package:skapp/dao/vod_dao.dart';
import 'package:skapp/pages/home/utils.dart';
import 'package:skapp/routers/application.dart';
import 'package:skapp/store/root.dart';
import 'package:skapp/widgets/rating_bar.dart';
import 'package:skapp/widgets/cache_img_radius.dart';
import './design_course_app_theme.dart';
import 'package:flutter/material.dart';

class CategoryListView extends StatefulWidget {
  final Global global;
  final List lists;
  const CategoryListView({Key key, this.global, this.lists}) : super(key: key);

  @override
  _CategoryListViewState createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView>
    with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    // await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Container(
        height: 134,
        width: double.infinity,
        child: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: widget.lists.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count =
                      widget.lists.length > 10 ? 10 : widget.lists.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                  animationController.forward();

                  return CategoryView(
                    global: widget.global,
                    category: widget.lists[index],
                    animation: animation,
                    animationController: animationController,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView({
    Key key,
    this.global,
    this.category,
    this.animationController,
    this.animation,
  }) : super(key: key);
  final Global global;
  final category;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    print(category);
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation.value), 0.0, 0.0),
            child: SizedBox(
              width: 280,
              child: Stack(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: global.isDark
                                  ? Theme.of(context).cardColor
                                  : HexColor('#f4f4f4'),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Row(
                              children: <Widget>[
                                const SizedBox(
                                  width: 48 + 24.0,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 16),
                                          child: Text(category.vodName,
                                              textAlign: TextAlign.left,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2),
                                        ),
                                        const Expanded(
                                          child: SizedBox(),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 16, bottom: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              // Text(
                                              //   '${category.lessonCount} lesson',
                                              //   textAlign: TextAlign.left,
                                              //   style: TextStyle(
                                              //     fontWeight: FontWeight.w200,
                                              //     fontSize: 12,
                                              //     letterSpacing: 0.27,
                                              //     color: DesignCourseAppTheme
                                              //         .grey,
                                              //   ),
                                              // ),
                                              Container(
                                                child: RatingBar(
                                                  category.vodScore,
                                                  size: 18.0,
                                                  fontSize: 0.0,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 16, right: 16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                width: 140,
                                                child: Text(
                                                  category.vodActor,
                                                  textAlign: TextAlign.left,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption,
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(6.0)),
                                                ),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // callback(category);
                                                    Application.router
                                                        .navigateTo(
                                                      context,
                                                      "/preview?vodId=${category.vodId}",
                                                      transition:
                                                          TransitionType.native,
                                                      transitionDuration:
                                                          Duration(
                                                              milliseconds:
                                                                  100),
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Icon(
                                                      Icons.play_arrow,
                                                      color:
                                                          DesignCourseAppTheme
                                                              .nearlyWhite,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 20, bottom: 20, left: 6),
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6.0)),
                            child: AspectRatio(
                                aspectRatio: 0.73,
                                child: CacheImgRadius(
                                  imgUrl: category.vodPic,
                                  radius: 4,
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
