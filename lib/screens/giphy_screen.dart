import 'package:dictyapp/helpers/dimensions.dart';
import 'package:dictyapp/scoped_models/main_scoped_model.dart';
import 'package:dictyapp/widgets/wordHead.dart';
import 'package:flutter/material.dart';

class GiphyScreen extends StatefulWidget {
  final word;
  final MainModel model;
  GiphyScreen(this.word, this.model);
  @override
  _GiphyScreenState createState() => _GiphyScreenState();
}

class _GiphyScreenState extends State<GiphyScreen> {
  var viewportHeight;
  var viewportWidth;
  bool _isLoading;
  bool _isPreview;
  List gifs = [];
  var previewGif;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _isPreview = false;
    widget.model.searchGiphy(widget.word).then((list) {
      setState(() {
        previewGif = list[0];
        gifs = list;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    viewportHeight = getViewportHeight(context);
    viewportWidth = getViewportWidth(context);
    return Scaffold(
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: viewportHeight * 0.03,
                      ),
                      navbarButton(),
                      WordHead(viewportHeight, viewportWidth, widget.word,
                          widget.model),
                      SizedBox(
                        height: viewportHeight * 0.03,
                      ),
                      Container(
                        height: viewportHeight * 0.8,
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          children: <Widget>[
                            createGiphy(0),
                            createGiphy(1),
                            createGiphy(2),
                            createGiphy(3),
                            createGiphy(4),
                            createGiphy(5),
                            createGiphy(6),
                            createGiphy(7),
                            createGiphy(8),
                            createGiphy(9),
                            createGiphy(10),
                            createGiphy(11),
                            createGiphy(12),
                            createGiphy(13),
                            createGiphy(14),
                            createGiphy(15),
                            createGiphy(16),
                            createGiphy(17),
                            createGiphy(18),
                            createGiphy(19),
                          ],
                        ),
                      ),
                    ],
                  ),
                  _isPreview
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPreview = false;
                            });
                          },
                          child: Container(
                            height: getDeviceHeight(context),
                            width: getDeviceWidth(context),
                            color: Colors.black.withOpacity(0.85),
                            child: Hero(
                              tag: previewGif['url'],
                              child: Center(
                                child: Image.network(
                                  previewGif['url'],
                                  height: double.parse(previewGif['height']),
                                  width: double.parse(previewGif['width']),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  _isPreview
                      ? Positioned(
                          left: viewportWidth * 0.03,
                          top: viewportHeight * 0.05,
                          child: IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                setState(() {
                                  _isPreview = false;
                                });
                              }),
                        )
                      : Container(),
                ],
              ),
            ),
    );
  }

  Widget createGiphy(int index) {
    return Container(
      height: index == gifs.length - 1
          ? double.parse(gifs[index]['height']) + 100
          : double.parse(gifs[index]['height']),
      width: double.parse(gifs[index]['width']),
      child: GestureDetector(
        onTap: () {
          setState(() {
            previewGif = gifs[index];
            _isPreview = true;
          });
        },
        child: Hero(
          tag: gifs[index]['url'],
          child: Center(
            child: Image.network(gifs[index]['url'],
                height: double.parse(gifs[index]['height']),
                width: double.parse(gifs[index]['width']), loadingBuilder:
                    (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget navbarButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: viewportHeight * 0.05,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
