import 'package:dictyapp/helpers/dimensions.dart';
import 'package:dictyapp/scoped_models/main_scoped_model.dart';
import 'package:dictyapp/widgets/preview.dart';
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
  List gifs = [];

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    widget.model.searchGiphy(widget.word).then((list) {
      setState(() {
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
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: viewportHeight * 0.03,
                  ),
                  navbarButton(),
                  WordHead(viewportHeight, viewportWidth, widget.word),
                  SizedBox(
                    height: viewportHeight * 0.03,
                  ),
                  Container(
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
                      ],
                    ),
                  ),
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
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Preview(gifs[index]),
            ),
          );
        },
        child: Hero(
          tag: gifs[index]['url'],
          child: Center(
            child: Image.network(
              gifs[index]['url'],
              height: double.parse(gifs[index]['height']),
              width: double.parse(gifs[index]['width']),
            ),
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
