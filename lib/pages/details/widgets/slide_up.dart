import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import './../../../store/details/details.dart';

// ignore: must_be_immutable
class SlideUpPage extends StatelessWidget {
  final DetailsStore store;
  final PanelController pc;
  SlideUpPage({Key key, this.store, this.pc}) : super(key: key);
  double _panelHeightOpen;
  double _panelHeightClosed = 0;

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height -
        ((MediaQuery.of(context).size.width / 16.0) * 9.0) -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom -
        MediaQueryData.fromWindow(window).padding.top;
    // if ios need -34 (unknown)
    if (Platform.isIOS) {
      // _panelHeightOpen = _panelHeightOpen - 34;
    }
    return Observer(builder: (_) {
      return SingleChildScrollView(
        child: SlidingUpPanel(
          controller: pc,
          maxHeight: _panelHeightOpen,
          minHeight: _panelHeightClosed,
          parallaxEnabled: false,
          parallaxOffset: 0,
          color: Theme.of(context).cardColor,
          panelBuilder: (sc) => _panel(sc, context, store),
          defaultPanelState: PanelState.CLOSED,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0), topRight: Radius.circular(0)),
        ),
      );
    });
  }

  Widget _panel(ScrollController sc, context, DetailsStore store) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: ListView.separated(
        padding: new EdgeInsets.all(5.0),
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              return Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        store.vod.vodName,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    // top: 0,
                    bottom: -2,
                    child: IconButton(
                      iconSize: 18,
                      icon: Icon(
                        Icons.close,
                      ),
                      padding: EdgeInsets.all(0.0),
                      onPressed: () {
                        pc.close();
                      },
                    ),
                  )
                ],
              );
            case 1:
              return Container(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${store.vod.vodScore}分 / ${store.vod.vodArea} / ${store.vod.vodYear} / ${store.vod.vodClass}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        '导演：${store.vod.vodDirector}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        '主演：${store.vod.vodActor}',
                        style: Theme.of(context).textTheme.caption,
                      )
                    ],
                  ),
                ),
              );
            case 2:
              return Container(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '简介',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      Text(
                        '${store.vod.vodContent.replaceAll(RegExp(r"<\/?[^>]*>"), "")}',
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.caption,
                      )
                    ],
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
}
