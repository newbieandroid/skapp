import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skapp/store/root.dart';
import '../../routers/application.dart';
import '../../widgets/network_img_widget.dart';
import '../../dao/vod_list_dao.dart';

// ignore: must_be_immutable
class SKGridItem extends StatefulWidget {
  Data vod;
  String type; // preview or details
  SKGridItem({Key key, @required this.vod, @required this.type})
      : super(key: key);

  @override
  _SKGridItemState createState() => _SKGridItemState();
}

class _SKGridItemState extends State<SKGridItem> {
  Data vod;
  @override
  void initState() {
    vod = widget.vod;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Global _global = Provider.of<Global>(context);
    return GestureDetector(
      onTap: () {
        if (widget.type == 'preview') {
          Application.router.navigateTo(
            context,
            "/preview?vodId=${vod.vodId}",
            transition: TransitionType.native,
            transitionDuration: Duration(milliseconds: 100),
          );
        } else if (widget.type == 'details') {
          Application.router.navigateTo(
            context,
            "/details?vodId=${vod.vodId}",
            transition: TransitionType.native,
            transitionDuration: Duration(milliseconds: 100),
          );
        }
      },
      child: Container(
        color: Theme.of(context).cardColor,
        // height: 142,
        //margin: EdgeInsets.only(bottom: 10.0),
        padding: EdgeInsets.only(
          // left: 15,
          // right: 15,
          top: 10,
          // bottom: 15.0,
        ),
        child: Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 0.73, // 宽高比
              child: Container(
                child: NetworkImgWidget(
                  imgUrl: vod.vodPic,
                  radius: 4,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, left: 2, right: 2, bottom: 8),
              child: Text(
                vod.vodName,
                maxLines: 2,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            )
          ],
        ),
      ),
    );
  }
}
