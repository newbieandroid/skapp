import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:skapp/widgets/cache_img_radius.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import './../../../store/details/details.dart';

class Desc extends StatelessWidget {
  final DetailsStore store;
  final PanelController pc;
  const Desc({Key key, this.store, this.pc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => ListTile(
        leading: CacheImgRadius(
          imgUrl: store.vod.vodPic,
          radius: 4,
        ),
        onTap: () {
          pc.open();
        },
        title: Text(
          store.vod.vodName,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        subtitle: Text(
          '${store.vod.vodArea} / ${store.vod.vodYear} / ${store.vod.vodClass} / ${store.vod.vodRemarks}',
          style: Theme.of(context).textTheme.caption,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
      ),
    );
  }
}
