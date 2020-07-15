import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// list loading
class DetailLoadingShimmerWidget extends StatelessWidget {
  DetailLoadingShimmerWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 160,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top: 30),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[400],
                highlightColor: Colors.white60,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: Colors.black45,
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 10,
                              margin: EdgeInsets.only(bottom: 14),
                              color: Colors.black45,
                            ),
                            Container(
                              height: 10,
                              margin: EdgeInsets.only(bottom: 14),
                              color: Colors.black45,
                            ),
                            Container(
                              height: 10,
                              width: 80,
                              color: Colors.black45,
                            )
                          ],
                        ),
                      ),
                      flex: 2,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Shimmer.fromColors(
                  baseColor: Colors.grey[200],
                  highlightColor: Colors.white60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 14),
                        height: 180,
                        color: Colors.black45,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 16),
                        height: 10,
                        color: Colors.black45,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 16),
                        height: 10,
                        color: Colors.black45,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 16),
                        height: 10,
                        color: Colors.black45,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 16),
                        height: 10,
                        width: 150,
                        color: Colors.black45,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 16),
                        height: 10,
                        color: Colors.black45,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 16),
                        height: 10,
                        width: 100,
                        color: Colors.black45,
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
