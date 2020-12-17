import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import 'package:provider/provider.dart';
import 'package:skapp/pages/details/widgets/slide_up_dlna.dart';
// import 'package:skapp/pages/details/widgets/dlna.dart';
import 'package:skapp/store/root.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import './../../store/details/details.dart';
import './../../store/classify/classify.dart';
import './../../widgets/flutter_tencentplayer_example/window_video_page.dart';
import './widgets/desc.dart';
import './widgets/players.dart';
import './widgets/webview_widget.dart';
import './widgets/like_widget.dart';
import './widgets/slide_up.dart';

class Details extends StatefulWidget {
  final String vodId;
  Details({this.vodId});
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final DetailsStore store = DetailsStore();
  final ClassifyStore classifyStore = ClassifyStore();
  PanelController pc = new PanelController();
  PanelController pcdlna = new PanelController();

  Future<dynamic> requestAPI() async {
    await store.fetchVodData();
    store.formatPDTbas(store.vod.vodPlayFrom);
    store.formatPD(store.vod.vodPlayUrl);
    classifyStore.changeQuery(page: 1, limit: 6, type: 'score');
    await classifyStore.fetchVodData(typeId: store.vod.typeId);
  }

  @override
  void initState() {
    super.initState();
    // 改变vodId
    store.changeVodId(widget.vodId);
    requestAPI();
  }

  @override
  Widget build(BuildContext context) {
    final Global _global = Provider.of<Global>(context);
    return Observer(
      builder: (_) => store.isLoading
          ? _global.isDark
              ? PKDarkCardProfileSkeleton(
                  isCircularImage: true,
                  isBottomLinesActive: true,
                )
              : PKCardProfileSkeleton(
                  isCircularImage: true,
                  isBottomLinesActive: true,
                )
          : Scaffold(
              // appBar: AppBar(
              //   title: Text(store.vod.vodName),
              // ),
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      color: Colors.black,
                      child: Stack(
                        children: <Widget>[
                          // AspectRatio(
                          //   aspectRatio: 16.0 / 9.0,
                          //   child: Container(
                          //     color: Colors.black,
                          //   ),
                          // ),
                          store.currentUrl == ""
                              ? AspectRatio(
                                  aspectRatio: 16.0 / 9.0,
                                  child: Container(
                                    color: Colors.black,
                                  ),
                                )
                              : (store.currentUrl.indexOf('.m3u8') >= 0) ||
                                      (store.currentUrl.indexOf('.mp4') >= 0) ||
                                      (store.currentUrl.indexOf('.rtmp') >= 0)
                                  ? WindowVideoPage(
                                      store: store, global: _global)
                                  : WebViewPage(
                                      store: store,
                                    ),

                          // IconButton(
                          //     icon: Icon(
                          //       Icons.arrow_back_ios,
                          //       color: Colors.white,
                          //     ),
                          //     onPressed: () {
                          //       Navigator.pop(context);
                          //     }),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: ListView.separated(
                          padding: new EdgeInsets.all(5.0),
                          itemCount: 3,
                          itemBuilder: (BuildContext context, int index) {
                            switch (index) {
                              /* case 0:
                                return DlnaPage(store: store); */
                              case 0:
                                return Desc(store: store, pc: pc);
                              case 1:
                                return Players(
                                    store: store, global: _global, pc: pcdlna);
                              case 2:
                                return Like(
                                  vodDataLists: classifyStore.vodDataLists,
                                  global: _global,
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
                      ),
                    ),
                    SlideUpPage(store: store, pc: pc),
                    DlnaPage(store: store, pc: pcdlna, global: _global)
                  ],
                ),
              ),
            ),
    );
  }
}
