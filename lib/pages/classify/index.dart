import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:skapp/store/root.dart';
import './../../store/classify/classify.dart';
import './sklist.dart';

// ignore: must_be_immutable
class Classify extends StatefulWidget {
  num typeId;
  Classify({Key key, this.typeId}) : super(key: key);

  @override
  _ClassifyState createState() => _ClassifyState(typeId);
}

class _ClassifyState extends State<Classify>
    with SingleTickerProviderStateMixin {
  num typeId;
  _ClassifyState(this.typeId);
  TabController tabController;
  final ClassifyStore store = ClassifyStore();
  List<Tab> myTabs = <Tab>[];
  List<Widget> myTabsView = <Widget>[];

  Future<dynamic> requestAPI() async {
    await store.fetchTypeData(typeId: typeId);

    if (store.type != null && store.type.code == 200) {
      if (myTabs.length == 0) {
        myTabs = store.type.data
            .map(
              (item) => Tab(
                // icon: Icon(Icons.local_florist),
                text: item.typeName,
                // iconMargin: EdgeInsets.only(bottom: 6),
                // child: Text(
                //   item.typeName,
                //   style: Theme.of(context).textTheme.bodyText2,
                // ),
              ),
            )
            .cast<Tab>()
            .toList();

        // 初始化
        myTabsView = store.type.data
            .map(
              (item) => SKList(typeId: item.typeId),
            )
            .toList();

        this.tabController = TabController(
          initialIndex: 0,
          length: myTabs.length,
          vsync: this,
        );
        this.tabController.addListener(() => _onTabChanged());
        store.changeLoading();
      }
    }
  }

  _onTabChanged() {
    if (this.tabController.index.toDouble() ==
        this.tabController.animation.value) {}
  }

  @override
  void initState() {
    super.initState();
    requestAPI();
  }

  @override
  Widget build(BuildContext context) {
    Global _global = Provider.of<Global>(context);
    return Observer(
        builder: (_) => store.isLoading
            ? Container(
                width: 0,
                height: 0,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: Material(
                          color: Theme.of(context).cardColor,
                          child: TabBar(
                            indicatorColor: _global.isDark
                                ? Colors.white
                                : Theme.of(context).primaryColorDark,
                            controller: tabController,
                            isScrollable: true,
                            labelColor: _global.isDark
                                ? Colors.white
                                : Theme.of(context).primaryColorDark,
                            unselectedLabelColor:
                                Theme.of(context).textTheme.subtitle2.color,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorWeight: 2,
                            // labelStyle: TextStyle(fontSize: 12),
                            tabs: myTabs,
                          ),
                        ),
                      ),
                      // Container(
                      //   color: Theme.of(context).cardColor,
                      //   child: IconButton(
                      //     padding: EdgeInsets.only(left: 10, right: 10),
                      //     icon: Icon(Icons.art_track),
                      //     iconSize: 16,
                      //     onPressed: () {
                      //       // 修改展示方式
                      //       _global.changeShowList(!_global.isShowList);
                      //     },
                      //   ),
                      // )
                    ],
                  ),
                  Expanded(
                    flex: 1,
                    child: TabBarView(
                      controller: tabController,
                      children: myTabsView,
                    ),
                  ),
                ],
              ));
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }
}
