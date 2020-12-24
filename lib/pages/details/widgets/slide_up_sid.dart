import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:skapp/store/root.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import './../../../store/details/details.dart';

// ignore: must_be_immutable
class SidUpPage extends StatelessWidget {
  final Global global;
  final DetailsStore store;
  final PanelController pc;
  SidUpPage({Key key, this.store, this.pc, this.global}) : super(key: key);
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
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              return Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        '选集',
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
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: store.players[store.currentTabs].length,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 0,
                      childAspectRatio: 1.8,
                    ),
                    itemBuilder: (context, index) {
                      return MaterialButton(
                        elevation: 0,
                        color: Theme.of(context).cardColor,
                        textColor: index == store.currentPlayers
                            ? global.isDark
                                ? Theme.of(context).accentColor
                                : Theme.of(context).primaryColorDark
                            : Theme.of(context).textTheme.bodyText2.color,
                        child: Text(
                            store.players[store.currentTabs][index]['label']),
                        onPressed: () {
                          store.changeCurrentPlayers(index);
                        },
                      );
                    },
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
