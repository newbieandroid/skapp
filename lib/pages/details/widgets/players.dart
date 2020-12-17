import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:skapp/iconfont/IconFont.dart';
import 'package:skapp/store/root.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import './../../../store/details/details.dart';

class Players extends StatelessWidget {
  final DetailsStore store;
  final Global global;
  final PanelController pc;

  Players({Key key, this.store, this.global, this.pc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        String dropdownValue = store.pTabs[store.currentTabs];
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
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
                        int currentTabs = store.pTabs.indexOf(newValue);
                        store.changeCurrentTabs(currentTabs);
                      },
                      items: store.pTabs.map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    // heightFactor: 2,
                    widthFactor: 2,
                    child: RaisedButton.icon(
                      icon: IconFont(IconNames.icontouping, size: 18),
                      color: Colors.transparent,
                      elevation: 0,
                      label: Text(
                        '投屏',
                        style: TextStyle(
                            color: global.isDark
                                ? Colors.white
                                : Theme.of(context).primaryColorDark),
                      ),
                      onPressed: () {
                        pc.open();
                      },
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 6, right: 6, top: 2, bottom: 16),
                child: Container(
                  height: 44,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    // physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: store.players[store.currentTabs].length,
                    itemBuilder: (BuildContext context, int index) => Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: MaterialButton(
                        elevation: 0,
                        color: Theme.of(context).cardColor,
                        textColor: index == store.currentPlayers
                            ? Theme.of(context).primaryColorDark
                            : Theme.of(context).textTheme.bodyText2.color,
                        child: Text(
                            store.players[store.currentTabs][index]['label']),
                        onPressed: () {
                          store.changeCurrentPlayers(index);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
