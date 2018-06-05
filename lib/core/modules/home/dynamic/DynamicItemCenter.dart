import 'package:flutter/material.dart';
import 'package:kindergarten/core/modules/home/dynamic/PlayDynamicVideoPage.dart';
import 'package:kindergarten/core/modules/reviewpic/ReviewPicPage.dart';
import 'package:kindergarten/style/TextStyle.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DynamicItemCenter extends StatelessWidget {
  DynamicItemCenter({this.singleData});

  final singleData;

  @override
  Widget build(BuildContext context) {
    if (singleData['dynamicType'] == '0') {
      (singleData['kgDynamicPics'] as List).sort((a, b) {
        return a['sequence'] - b['sequence'];
      });
    }

    return new Column(
      children: <Widget>[
        new Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
          child: new Text(
            singleData['content'],
            textAlign: TextAlign.left,
            style: textStyle,
          ),
        ),
        singleData['dynamicType'] == '0'
            ? new GridView.count(
                primary: false,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                crossAxisCount: 3,
                shrinkWrap: true,
                children: (singleData['kgDynamicPics'] as List).map((picItem) {
                  return picItem['picUrl'];
                }).map<Widget>((item) {
                  return new GestureDetector(
                    onTap: () {
                      List<String> itemPics =
                          (singleData['kgDynamicPics'] as List).map<String>((picItem) {
                        return picItem['picUrl'].toString();
                      }).toList();
                      ReviewPicPage.start(context, {
                        'pisition': itemPics.indexOf(item),
                        'itemPics': itemPics
                      });
                    },
                    child: new CachedNetworkImage(
                      imageUrl: item,
                      errorWidget: new Icon(Icons.error),
                    ),
                  );
                }).toList(),
              )
            : new Align(
                alignment: Alignment.centerLeft,
                child: new Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    new CachedNetworkImage(
                      imageUrl: singleData['kgDynamicVideo']['videoPic'],
                      errorWidget: new Icon(Icons.error),
                      height: 250.0,
                    ),
                    new IconButton(
                        icon: new Icon(
                          Icons.play_circle_outline,
                          size: 50.0,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(new PlayDynamicVideoPage({
                                'videoUrl': singleData['kgDynamicVideo']
                                    ['videoUrl']
                              }).route());
                        }),
                  ],
                ))
      ],
    );
  }
}
