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
  var _temp;
  Map _surveyData;
  bool _connectionConfirm = false;

  @override
  void initState() {
    _surveyData = widget.surveyData;
    if (_surveyData["history"][widget.route] != null) {
      _temp = _surveyData["history"][widget.route]["value"];
    }
    super.initState();
  }

  Widget _inputOptions(Map fontData, Map data) {
    switch (data["type"]) {
      case 'radio':
        return _radioOption(fontData, data);
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
      case 'finish':
        return _finishDialog(fontData, data);
        break;
      default:
        return _error();
        break;
    }
  }

  Widget _finishDialog(Map fontData, Map data) {}

  Widget _error() {
    return Container(
      padding: EdgeInsets.only(top: 40),
      child: Text("Error appeared, just go forward"),
    );
  }

  Widget _checkboxOption(Map fontData, Map data) {
    if (_temp == null) {
      _temp = {};
    }

    return Column(
      children: [
        for (var item in data["reply"])
          ListTile(
            title: Text(
              item["option"],
              style: TextStyle(fontSize: fontData["text"]),
            ),
            leading: Checkbox(
              value: _temp[item["option"]],
              onChanged: (value) {
                setState(() {
                  item["value"] = value;
                });
              },
            ),
          ),
      ],
    );
  }

  Widget _contentOption(Map fontData, Map data) {
    return Text(
      data["reply"]["content"],
      style: TextStyle(fontSize: fontData["text"]),
    );
  }

  Widget _sentenceOption(Map fontData, Map data) {
    _textController.text = _temp;
    Widget textfield(double width) {
      return Container(
        padding: EdgeInsets.only(top: 30),
        width: width,
        child: TextField(
          controller: _textController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter in your Answer',
          ),
          onChanged: (value) => _temp = value,
        ),
      );
    }

    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 720) {
        return textfield(200);
      } else {
        return textfield(600);
      }
    });
  }

  Widget _radioOption(Map fontData, Map data) {
    return Column(
      children: [
        for (var item in data["reply"])
          ListTile(
            title: Text(
              item["radio"],
              style: TextStyle(fontSize: fontData["text"]),
            ),
            leading: Radio(
              value: item["radio"],
              groupValue: _temp,
              onChanged: (value) {
                setState(() {
                  _nextRoute = item["followroute"];
                  _temp = value;
                });
              },
            ),
          ),
      ],
    );
  }

  Widget _surveyContent(Map fontData, Map data) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: IconButton(
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
                Navigator.pop(context);
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
            heroTag: "nextSurvey",
            child: Icon(
              Icons.arrow_forward,
              size: fontData["button"],
            ),
            onPressed: () {
              Navigator.pop(context);
              _surveyData["lastRoute"][_nextRoute ?? data["routeskip"]] =
                  widget.route;
              _surveyData["history"]
                  [widget.route] = {"value": _temp, "type": data["type"]};
              //TODO: Adding Method to add temporary Values depending on type of survey
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
          children: [
            Container(
              padding: EdgeInsets.only(top: 40),
              alignment: Alignment.center,
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: fontData["title"],
                  fontWeight: FontWeight.bold,
                  fontFamily: "BlackChancery",
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 40, left: 30),
              alignment: Alignment.centerLeft,
              child: Text(
                data["request"],
                style: TextStyle(
                  fontSize: fontData["subTitle"],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 40, top: 20),
              child: _inputOptions(fontData, data),
            ),
          ],
        ),
      ],
    );
  }

  Widget _mainCard(Map data) {
    return Center(
      child: LayoutBuilder(builder: (context, constraint) {
        if (constraint.maxWidth < 720) {
          return FractionallySizedBox(
            widthFactor: 0.9,
            heightFactor: 0.8,
            child: Card(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                  side: new BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0)),
              child: _surveyContent(
                  {"title": 25, "subTitle": 17, "text": 13, "button": 20},
                  data),
            ),
          );
        } else {
          return FractionallySizedBox(
            widthFactor: 0.8,
            heightFactor: 0.8,
            child: Card(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                  side: new BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0)),
              child: _surveyContent(
                  {"title": 50, "subTitle": 34, "text": 20, "button": 40},
                  data),
            ),
          );
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseApp().surveyRouteData(widget.code, widget.route),
        builder: (context, snapshot) {
          if (!_connectionConfirm) {
            //Just need to confirm once and maybe later Connectionstate feature will be in full use later
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                _connectionConfirm = true;
                return _mainCard(snapshot.data);
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
          } else {
            return _mainCard(snapshot.data);
          }
        });
  }
}
