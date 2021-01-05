import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:skapp/iconfont/IconFont.dart';
import 'package:skapp/store/root.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import './../../../store/details/details.dart';

class Players extends StatefulWidget {
  // final DlnaPage store;
  final DetailsStore store;
  final Global global;
  final PanelController pc;
  final PanelController pcsid;

  Players({Key key, this.store, this.global, this.pc, this.pcsid})
      : super(key: key);

  @override
  _PlayersState createState() => _PlayersState();
}

class _PlayersState extends State<Players> {
  ScrollController _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    _controller = ScrollController(
        initialScrollOffset: 88.0 * widget.store.currentPlayers);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        String dropdownValue = widget.store.pTabs[widget.store.currentTabs];
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 8, left: 10),
                        child: Text(
                          '播放源',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          onChanged: (String newValue) {
                            int currentTabs =
                                widget.store.pTabs.indexOf(newValue);
                            widget.store.changeCurrentTabs(currentTabs);
                          },
                          items: widget.store.pTabs
                              .map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  )),
                  RaisedButton.icon(
                    icon: IconFont(IconNames.icontelevision_01,
                        size: 18,
                        color: widget.global.isDark ? '#ffffff' : '#129c90'),
                    color: Colors.transparent,
                    elevation: 0,
                    label: Text(
                      '投屏',
                      style: TextStyle(
                        color: widget.global.isDark
                            ? Colors.white
                            : Color.fromRGBO(18, 156, 144, 1),
                      ),
                    ),
                    onPressed: () {
                      widget.pc.open();
                    },
                  ),
                ],
              ),
              Padding(
                  padding:
                      EdgeInsets.only(left: 6, right: 6, top: 2, bottom: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 44,
                          child: ListView.builder(
                            controller: _controller,
                            scrollDirection: Axis.horizontal,
                            // physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget
                                .store.players[widget.store.currentTabs].length,
                            itemBuilder: (BuildContext context, int index) =>
                                Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: MaterialButton(
                                elevation: 0,
                                color: Theme.of(context).cardColor,
                                textColor: index == widget.store.currentPlayers
                                    ? widget.global.isDark
                                        ? Theme.of(context).accentColor
                                        : Theme.of(context).primaryColorDark
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .color,
                                child: Text(widget
                                        .store.players[widget.store.currentTabs]
                                    [index]['label']),
                                onPressed: () {
                                  widget.store.changeCurrentPlayers(index);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      // 大于6个显示
                      widget.store.players[widget.store.currentTabs].length > 3
                          ? IconButton(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              icon: Icon(Icons.arrow_forward_ios),
                              iconSize: 16,
                              onPressed: () {
                                widget.pcsid.open();
                              })
                          : Container(
                              width: 0,
                              height: 0,
                            ),
                    ],
                  )),
            ],
          ),
        );
      },
    );
  }
}
