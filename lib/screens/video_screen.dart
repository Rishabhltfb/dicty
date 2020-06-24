import 'package:dictyapp/helpers/dimensions.dart';
import 'package:dictyapp/helpers/my_flutter_app_icons.dart';
import 'package:dictyapp/scoped_models/main_scoped_model.dart';
import 'package:dictyapp/widgets/wordHead.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {
  final wordobj;
  final MainModel model;

  VideoScreen(this.wordobj, this.model);
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  var viewportHeight;
  var viewportWidth;
  bool showDefinitions = false;
  bool showAllDefinitions = false;
  bool showDefTrans = false;
  bool _isLoading = false;
  bool _isPlaying = true;
  var id = '';
  var startTime = '';
  int currVidIndex;
  int currDefTransIndex;

  List definitionsList = [];
  List defTransList = [];

  List youtubeList = [];
  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    currVidIndex = 0;
    _isLoading = true;
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

    if (youtubeList.length == 0 && widget.model.youglishlimit < 20) {
      print('Youglish limit is : ${widget.model.youglishlimit}');
      widget.model.searchYoutube(widget.wordobj['meta']['id']).then((value) {
        youtubeList = value;
        id = youtubeList[0]['vid'];
        startTime = youtubeList[0]['start'];
        _controller = YoutubePlayerController(
          initialVideoId: id,
          flags: YoutubePlayerFlags(
            mute: false,
            autoPlay: true,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  void nextVid() {
    setState(() {
      if (currVidIndex < youtubeList.length - 1) {
        currVidIndex = currVidIndex + 1;
        id = youtubeList[currVidIndex]['vid'];
        startTime = youtubeList[currVidIndex]['start'];
        _controller.load(id, startAt: int.parse(startTime));
      }
    });
  }

  void prevVid() {
    setState(() {
      if (currVidIndex > 0) {
        currVidIndex = currVidIndex - 1;
        id = youtubeList[currVidIndex]['vid'];
        startTime = youtubeList[currVidIndex]['start'];
        _controller.load(id, startAt: int.parse(startTime));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    viewportHeight = getViewportHeight(context);
    viewportWidth = getViewportWidth(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: _isLoading
            ? Container(
                height: viewportHeight,
                width: viewportWidth,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Column(
                children: <Widget>[
                  SizedBox(
                    height: viewportHeight * 0.03,
                  ),
                  navbarButton(),
                  WordHead(viewportHeight, viewportWidth,
                      widget.wordobj['meta']['id'], widget.model),
                  Container(),
                  showDefinitions ? _definitions('Definitions') : Container(),
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
                  _button('In Videos'),
                  SizedBox(height: viewportHeight * 0.05),
                  Container(
                    height: viewportHeight * 0.3,
                    width: viewportWidth,
                    child: YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                      onReady: () {
                        _controller
                            .seekTo(Duration(seconds: int.parse(startTime)));
                        print('Player is ready.');
                      },
                    ),
                  ),
                  SizedBox(
                    height: viewportHeight * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      currVidIndex != 0
                          ? _playButton('previous')
                          : SizedBox(
                              width: viewportHeight * 0.1,
                            ),
                      _isPlaying ? _playButton('pause') : _playButton('play'),
                      currVidIndex != youtubeList.length - 1
                          ? _playButton('next')
                          : SizedBox(
                              width: viewportHeight * 0.1,
                            ),
                    ],
                  )
                ],
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

  Widget _playButton(String title) {
    IconData iconData;
    if (title == 'previous') {
      iconData = MyFlutterApp.step_backward;
    } else if (title == 'play') {
      iconData = Icons.play_arrow;
    } else if (title == 'pause') {
      iconData = Icons.pause;
    } else {
      iconData = MyFlutterApp.step_forward;
    }
    return Container(
      height: viewportHeight * 0.1,
      width: viewportHeight * 0.1,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white,
          ),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(100),
        ),
      ),
      child: IconButton(
        icon: Icon(
          iconData,
          size: viewportHeight * 0.06,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          if (title == 'previous') {
            prevVid();
            setState(() {
              _isPlaying = true;
            });
          } else if (title == 'play') {
            setState(() {
              _isPlaying = true;
            });
            _controller.play();
          } else if (title == 'pause') {
            setState(() {
              _isPlaying = false;
            });
            _controller.pause();
          } else {
            nextVid();
            setState(() {
              _isPlaying = true;
            });
          }
        },
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
                      title != 'Sentences'
                          ? TextSpan(
                              text: '. (Noun)',
                              style: TextStyle(
                                  fontSize: viewportHeight * 0.018,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold),
                            )
                          : TextSpan(text: '.'),
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
