import 'package:flutter/material.dart';

///电影长评论
class LongCommentWidget extends StatelessWidget {
  final bool scroll;

  LongCommentWidget({Key key, this.scroll}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LongCommentTabView(scroll: scroll);
  }
}

class LongCommentTabView extends StatefulWidget {
  final bool scroll;

  LongCommentTabView({Key key, this.scroll}) : super(key: key);

  @override
  _LongCommentTabViewState createState() => _LongCommentTabViewState();
}

class _LongCommentTabViewState extends State<LongCommentTabView>
    with SingleTickerProviderStateMixin {
  final List<String> list = ['影评', '话题', '讨论'];

  TabController controller;
  Color selectColor, unselectedColor;
  TextStyle selectStyle, unselectedStyle;

  @override
  void initState() {
    controller = TabController(length: list.length, vsync: this);
    selectColor = Colors.black;
    unselectedColor = Color.fromARGB(255, 117, 117, 117);
    selectStyle = TextStyle(fontSize: 15, color: selectColor);
    unselectedStyle = TextStyle(fontSize: 15, color: selectColor);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 6.0,
          width: 45.0,
          margin: const EdgeInsets.only(top: 10.0),
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 214, 215, 218),
              borderRadius: BorderRadius.all(const Radius.circular(5.0))),
        ),
        Container(
          padding: const EdgeInsets.only(top: 15.0),
          child: TabBar(
            tabs: list
                .map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Text(item),
                    ))
                .toList(),
            isScrollable: true,
            indicatorColor: selectColor,
            labelColor: selectColor,
            labelStyle: selectStyle,
            unselectedLabelColor: unselectedColor,
            unselectedLabelStyle: unselectedStyle,
            indicatorSize: TabBarIndicatorSize.label,
            controller: controller,
          ),
          alignment: Alignment.centerLeft,
        ),
        Expanded(
            child: TabBarView(
          children: <Widget>[
            ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                    Container(
                      child: getItem(),
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      color: Colors.white,
                    ),
                    Container(
                      height: 10.0,
                      color: Colors.transparent,
                    )
                  ],
                );
              },
              physics: widget.scroll
                  ? const ClampingScrollPhysics()
                  : const NeverScrollableScrollPhysics(), //禁止滚动
              // physics: const ClampingScrollPhysics(), // 滚动
              itemCount: 10,
            ),
            Text('话题，暂无数据~'),
            Text('讨论，暂无数据~')
          ],
          controller: controller,
        ))
      ],
    );
  }

  Widget getItem() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Padding(
              //   padding:
              //       const EdgeInsets.only(top: 10.0, bottom: 7.0, right: 5.0),
              //   child: CircleAvatar(
              //     radius: 10.0,
              //     backgroundImage: NetworkImage(),
              //     backgroundColor: Colors.white,
              //   ),
              // ),
              Padding(
                child: Text('张三'),
                padding: const EdgeInsets.only(right: 5.0),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Text(
              '暂时不知道放什么',
              softWrap: true,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14.0, color: Color(0xff333333)),
            ),
          ),
        ],
      ),
      onTap: () {},
    );
  }

  ///将34123转成3.4k
  getUsefulCount(int usefulCount) {
    double a = usefulCount / 1000;
    if (a < 1.0) {
      return usefulCount;
    } else {
      return '${a.toStringAsFixed(1)}k'; //保留一位小数
    }
  }
}
