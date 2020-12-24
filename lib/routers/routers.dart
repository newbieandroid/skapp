import 'package:fluro/fluro.dart' as CustomRouter;
import 'package:flutter/material.dart';
import './route_handlers.dart';

class Routes {
  //  首页
  static String root = "/";
  // 详情页面
  static String details = "/details";
  // 搜索页面
  static String search = "/search";
  // 直播概览
  static String live = "/live";
  // 直播详情
  static String showLives = "/showLives";
  // 自定义设置
  static String custom = "/custom";
  // 音乐播放器页面
  static String music = "/music";
  // 电影预览界面
  static String preview = "/preview";
  // 视频解析
  static String vipvideo = "/vipvideo";
  // 投屏界面
  static String dlna = "/dlna";
  // 历史记录
  static String history = "/history";

  static void configureRoutes(CustomRouter.Router router) {
    router.notFoundHandler = CustomRouter.Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
    });
    router.define(root, handler: rootHandler);
    router.define(details, handler: detailsRouteHandler);
    router.define(search, handler: searchRouteHandler);
    router.define(live, handler: liveRouteHandler);
    router.define(showLives, handler: showLivesRouteHandler);
    router.define(custom, handler: customRouteHandler);
    router.define(music, handler: musicRouteHandler);
    router.define(preview, handler: previewRouteHandler);
    router.define(vipvideo, handler: vipvideoRouteHandler);
    router.define(dlna, handler: dlnaRouteHandler);
    router.define(history, handler: historyRouteHandler);
    // router.define(demoSimpleFixedTrans,
    //     handler: demoRouteHandler, transitionType: TransitionType.inFromLeft);
  }
}
