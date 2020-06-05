import 'package:flutter/material.dart';
import 'package:va_flutter_project/modules/firebaseApp.dart';
import 'package:va_flutter_project/pages/startSurvey.dart';

class SurveyCard extends StatefulWidget {
  final String title;
  final String route;
  final String code;
  final Map surveyData;

  SurveyCard(this.route, this.code, this.surveyData, this.title);

  @override
  _SurveyCardState createState() => _SurveyCardState();
}

class _SurveyCardState extends State<SurveyCard> {
  TextEditingController _textController = TextEditingController();
  String _nextRoute;
  Map _surveyData;

  @override
  void initState() {
    _surveyData = widget.surveyData;
    if (_surveyData["lastRoute"] == null) {
      _surveyData["lastRoute"] = {};
    }
    super.initState();
  }

  Widget _inputOptions(Map fontData, Map data) {
    switch (data["type"]) {
      case 'selection':
        return _selectionOption(fontData, data);
        break;
      case 'sentence':
        return _sentenceOption(fontData, data);
        break;
      case 'checkbox':
        return _checkboxOption(fontData, data);
        break;
      case 'info':
        return _contentOption(fontData, data);
        break;
      default:
        return _error();
        break;
    }
  }

  Widget _error() {
    return Container();
  }

  Widget _checkboxOption(Map fontData, Map data) {
    return Container();
  }

  Widget _contentOption(Map fontData, Map data) {
    return Container();
  }

  Widget _sentenceOption(Map fontData, Map data) {
    return Container();
  }

  Widget _selectionOption(Map fontData, Map data) {
    return Container();
  }

  Widget _surveyContent(Map fontData, Map data) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          side: new BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(12.0)),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: IconButton(
              color: Colors.black,
              icon: Icon(Icons.arrow_back),
              iconSize: fontData["button"],
              onPressed: () {
                if (widget.route != "start") {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context, _, __) => SurveyCard(
                        _surveyData["lastRoute"][widget.route],
                        widget.code,
                        _surveyData,
                        widget.title,
                      ),
                      opaque: false,
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                } else {
                  Navigator.pop(
                      context); //TODO: should pop a message that this will destroy the survey and go back to startSurvey
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context, _, __) => StartSurvey(
                        code: widget.code,
                        surveyData: widget.surveyData,
                      ),
                      opaque: false,
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: FloatingActionButton(
              backgroundColor: Colors.black,
              heroTag: "nextSurvey",
              child: Icon(
                Icons.arrow_forward,
                size: fontData["button"],
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                _surveyData["lastRoute"][_nextRoute ?? data["routeskip"]] = widget.route;
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (BuildContext context, _, __) => SurveyCard(
                      _nextRoute ?? data["routeskip"],
                      widget.code,
                      _surveyData,
                      widget.title,
                    ),
                    opaque: false,
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 40,
                color: Colors.transparent,
              ),
              Text(
                widget.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: fontData["title"],
                  fontWeight: FontWeight.bold,
                  fontFamily: "BlackChancery",
                ),
              ),
              Container(
                height: 40,
                color: Colors.transparent,
              ),
              Text(
                data["request"],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: fontData["subTitle"],
                  fontWeight: FontWeight.bold,
                ),
              ),
              _inputOptions(fontData, data),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseApp().surveyRouteData(widget.code, widget.route),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              return Center(
                child: LayoutBuilder(builder: (context, constraint) {
                  if (constraint.maxWidth < 720) {
                    return FractionallySizedBox(
                      widthFactor: 0.9,
                      heightFactor: 0.8,
                      child: _surveyContent({
                        "title": 25,
                        "subTitle": 17,
                        "text": 13,
                        "button": 20
                      }, snapshot.data),
                    );
                  } else {
                    return FractionallySizedBox(
                      widthFactor: 0.8,
                      heightFactor: 0.8,
                      child: _surveyContent({
                        "title": 50,
                        "subTitle": 34,
                        "text": 20,
                        "button": 40
                      }, snapshot.data),
                    );
                  }
                }),
              );
              break;
            case ConnectionState.waiting:
              return Center(
                child: Text("Loading"),
              );
              break;
            default:
              return Center(
                child: Text("Error"),
              );
              break;
          }
        });
  }
}
