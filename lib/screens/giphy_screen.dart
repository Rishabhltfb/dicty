import 'package:dictyapp/helpers/dimensions.dart';
import 'package:dictyapp/helpers/my_flutter_app_icons.dart';
import 'package:dictyapp/scoped_models/main_scoped_model.dart';
import 'package:dictyapp/widgets/wordHead.dart';
import 'package:flutter/material.dart';

class GiphyScreen extends StatefulWidget {
  final wordobj;
  final MainModel model;
  GiphyScreen(this.wordobj, this.model);
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

  int currDefTransIndex;
  bool showDefinitions = false;
  bool showAllDefinitions = false;
  bool showDefTrans = false;
  List definitionsList = [];
  List defTransList = [];

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _isPreview = false;

    currDefTransIndex = -1;

    definitionsList = widget.wordobj['shortdef'];

    if (definitionsList.isNotEmpty) {
      widget.model.translateIBM(definitionsList).then((transList) {
        var tempList = [];
        transList.forEach((element) {
          tempList.add(element['translation']);
        });
        defTransList = tempList;
      });
    }
    widget.model.searchGiphy(widget.wordobj['meta']['id']).then((list) {
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
                      WordHead(viewportHeight, viewportWidth,
                          widget.wordobj['meta']['id'], widget.model),
                      SizedBox(
                        height: viewportHeight * 0.01,
                      ),
                      showDefinitions
                          ? _definitions('Definitions')
                          : Container(),
                      SizedBox(height: 15),
                      showAllDefinitions
                          ? Container()
                          : showDefinitions
                              ? _definitionButton('More Definitions')
                              : _definitionButton('See Definitions'),
                      SizedBox(height: 15),
                      showDefinitions
                          ? _definitionButton('Close Definitions')
                          : Container(),
                      SizedBox(
                        height: viewportHeight * 0.03,
                      ),
                      _button('In Gifs'),
                      Container(
                        height: viewportHeight * 0.64,
                        child: GridView.builder(
                          itemCount: gifs.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemBuilder: (context, index) {
                            return createGiphy(index);
                          },
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
                            color: Colors.black.withOpacity(0.6),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Hero(
            tag: gifs[index]['url'],
            child: Center(
              child: Image.network(gifs[index]['url'],
                  fit: BoxFit.fitWidth,
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
      ),
    );
  }

  Widget _definitionButton(String title) {
    return Container(
      width: viewportWidth * 0.4,
      height: viewportHeight * 0.045,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white24,
          ),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(23),
        ),
      ),
      child: OutlineButton(
        padding: EdgeInsets.all(0),
        splashColor: Colors.white,
        onPressed: () {
          setState(() {
            if (title == 'See Definitions') {
              showDefinitions = true;
            } else if (title == 'Close Definitions') {
              showDefinitions = false;
              showAllDefinitions = false;
            } else {
              showAllDefinitions = true;
            }
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
        highlightElevation: 0,
        borderSide: BorderSide(color: Colors.white),
        child: Text(
          title,
          style: TextStyle(
            fontSize: viewportHeight * 0.02,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ),
    );
  }

  Widget _button(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: viewportWidth * 0.6,
        child: RaisedButton(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: viewportHeight * 0.03,
                    fontFamily: 'Krungthep'),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
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

  Widget _definitions(String title) {
    var definitions;
    var transList;
    definitions = definitionsList;
    transList = defTransList;

    return Container(
      width: viewportWidth * 0.8,
      // height: title == 'Sentences'
      //     ? viewportHeight * 0.6
      //     : (showAllDefinitions ? viewportHeight * 0.6 : viewportHeight * 0.25),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: (showAllDefinitions ? definitions.length : 1),
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              ListTile(
                // leading: Text((index + 1).toString()),
                leading: Container(
                  height: 22,
                  width: 22,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                      ),
                    ],
                    borderRadius: BorderRadius.all(
                      Radius.circular(23),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                title: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: viewportHeight * 0.02,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: definitions[index]),
                    ],
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: ((currDefTransIndex == index
                                  ? Colors.blue
                                  : Colors.white)),
                            ),
                          ],
                          borderRadius: BorderRadius.all(
                            Radius.circular(13),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (currDefTransIndex != index) {
                                  currDefTransIndex = index;
                                } else {
                                  currDefTransIndex = -1;
                                }
                                showDefTrans = !showDefTrans;
                              });
                            },
                            child: Icon(
                              Icons.translate,
                              size: viewportHeight * 0.03,
                              color: ((currDefTransIndex == index
                                  ? Colors.white
                                  : Theme.of(context).primaryColor)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                            ),
                          ],
                          borderRadius: BorderRadius.all(
                            Radius.circular(13),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2),
                          child: GestureDetector(
                            onTap: () {
                              widget.model.initializeTts();
                              widget.model.ttsspeak(definitions[index]);
                            },
                            child: Icon(
                              MyFlutterApp.volume,
                              size: viewportHeight * 0.03,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              (currDefTransIndex == index
                  ? ListTile(
                      leading: Icon(Icons.translate),
                      title: Text(
                        transList[index],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: viewportHeight * 0.02,
                        ),
                      ),
                    )
                  : Container()),
            ],
          );
        },
      ),
    );
  }
}
