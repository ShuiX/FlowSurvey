import 'package:flutter/material.dart';
import 'package:va_flutter_project/modules/customDialogs.dart';
import 'package:va_flutter_project/modules/firebaseApp.dart';
import 'package:va_flutter_project/modules/presetsData.dart';
import 'package:va_flutter_project/pages/endingSurvey.dart';
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

  Widget _loading() {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 720) {
        return FractionallySizedBox(
          widthFactor: 9,
          heightFactor: 8,
          child: CircularProgressIndicator(),
        );
      } else {
        return FractionallySizedBox(
          widthFactor: 8,
          heightFactor: 8,
          child: CircularProgressIndicator(),
        );
      }
    });
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
      default:
        return _error();
        break;
    }
  }

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
          onChanged: (value) {
            if (value != "") {
              _nextRoute = data["followroute"];
            } else {
              _nextRoute = data["routeskip"];
            }
            _temp = value;
          },
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
              switch (widget.route) {
                case "start":
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
                        return SlideTransition(
                          position: animation.drive(
                              Tween(begin: Offset(0.0, 1.0), end: Offset.zero)
                                  .chain(CurveTween(curve: Curves.ease))),
                          child: child,
                        );
                      },
                    ),
                  );
                  break;
                default:
                  _surveyData["progress"].removeLast();
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
                        return SlideTransition(
                          position: animation.drive(
                              Tween(begin: Offset(0.0, 1.0), end: Offset.zero)
                                  .chain(CurveTween(curve: Curves.ease))),
                          child: child,
                        );
                      },
                    ),
                  );
                  break;
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
              _surveyData["progress"].add(widget.route);
              _surveyData["lastRoute"][_nextRoute ?? data["routeskip"]] =
                  widget.route;
              _surveyData["history"]
                  [widget.route] = {"value": _temp, "type": data["type"]};
              switch (_nextRoute ?? data["routeskip"]) {
                case "finish":
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context, _, __) => FinishCard(
                          widget.title, widget.code, _surveyData, widget.route),
                      opaque: false,
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: animation.drive(
                              Tween(begin: Offset(0.0, 1.0), end: Offset.zero)
                                  .chain(CurveTween(curve: Curves.ease))),
                          child: child,
                        );
                      },
                    ),
                  );
                  break;
                default:
                  Navigator.pop(context);
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
                        return SlideTransition(
                          position: animation.drive(
                              Tween(begin: Offset(0.0, 1.0), end: Offset.zero)
                                  .chain(CurveTween(curve: Curves.ease))),
                          child: child,
                        );
                      },
                    ),
                  );
                  break;
              }
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
                  child: _loading(),
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

class FinishCard extends StatelessWidget {
  final String title;
  final Map surveyData;
  final String code;
  final String lastRoute;

  FinishCard(this.title, this.code, this.surveyData, this.lastRoute);

  Widget _widget(Map fontData, BuildContext context) {
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
          side: new BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(12.0)),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              iconSize: fontData["button"],
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (BuildContext context, _, __) =>
                        SurveyCard(lastRoute, code, surveyData, title),
                    opaque: false,
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: animation.drive(
                            Tween(begin: Offset(0.0, 1.0), end: Offset.zero)
                                .chain(CurveTween(curve: Curves.ease))),
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
                  title,
                  style: TextStyle(
                    fontSize: fontData["title"],
                    fontWeight: FontWeight.bold,
                    fontFamily: "BlackChancery",
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 40, left: 30, bottom: 75),
                alignment: Alignment.centerLeft,
                child: Text(
                  "End of the Survey! Do you want to finish the survey or want to go back where you began?",
                  style: TextStyle(
                    fontSize: fontData["subTitle"],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              RaisedButton(
                splashColor: Colors.black.withOpacity(0.2),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    side: new BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(12.0)),
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "Go back to Start",
                    style: TextStyle(
                        fontSize: fontData["subTitle"], color: Colors.black),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context, _, __) =>
                          SurveyCard("start", code, surveyData, title),
                      opaque: false,
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: animation.drive(
                              Tween(begin: Offset(0.0, 1.0), end: Offset.zero)
                                  .chain(CurveTween(curve: Curves.ease))),
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
              Container(
                height: 20,
              ),
              RaisedButton(
                splashColor: Colors.black.withOpacity(0.2),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    side: new BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(12.0)),
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "Finish Survey",
                    style: TextStyle(
                        fontSize: fontData["subTitle"], color: Colors.black),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context, _, __) =>
                          SubmitSurveyProcess(code, surveyData, title),
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
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 720) {
          return FractionallySizedBox(
            widthFactor: 0.9,
            heightFactor: 0.8,
            child: _widget(
                {"title": 25, "subTitle": 17, "text": 13, "button": 20},
                context),
          );
        } else {
          return FractionallySizedBox(
            widthFactor: 0.8,
            heightFactor: 0.8,
            child: _widget(
                {"title": 50, "subTitle": 34, "text": 20, "button": 40},
                context),
          );
        }
      }),
    );
  }
}

class SubmitSurveyProcess extends StatefulWidget {
  final String title;
  final String code;
  final Map surveyData;

  SubmitSurveyProcess(this.code, this.surveyData, this.title);

  @override
  _SubmitSurveyProcessState createState() => _SubmitSurveyProcessState();
}

class _SubmitSurveyProcessState extends State<SubmitSurveyProcess> {
  double _progressValue;

  @override
  void initState() {
    _postData();
    super.initState();
  }

  void _postData() {
    for (var i = 0; i < widget.surveyData["progress"].length; i++) {
      FirebaseApp()
          .postSurveyResult(
        widget.code,
        widget.surveyData["progress"][i],
        widget.surveyData["history"][widget.surveyData["progress"][i]]["type"],
        widget.surveyData["history"][widget.surveyData["progress"][i]]["value"],
      )
          .then((value) {
        if (value != false) {
          setState(() {
            _progressValue = ++i / widget.surveyData["progress"].length;
          });
        } else {
          Navigator.of(context).popUntil((route) => route.isFirst);
          showDialog(
            context: context,
            builder: (BuildContext context) => CustomDialog(
              title: "FlowSurvey",
              content: PresetsData.failedPostingData,
              dialogType: "redAlert",
            ),
          );
        }
        if (_progressValue == 1) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => EndingSurvey(widget.code)));
        }
      });
    }
  }

  Widget _widget(Map fontData, BuildContext context) {
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
          side: new BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: CircularProgressIndicator(
              value: _progressValue,
              strokeWidth: fontData["circleThick"],
            ),
            height: fontData["circleSize"],
            width: fontData["circleSize"],
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Text(
            "Loading",
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: fontData["text"],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 720) {
          return FractionallySizedBox(
            widthFactor: 0.9,
            heightFactor: 0.8,
            child: _widget({
              "title": 25,
              "subTitle": 17,
              "text": 13,
              "button": 20,
              "circleSize": 100,
              "circleThick": 10,
            }, context),
          );
        } else {
          return FractionallySizedBox(
            widthFactor: 0.8,
            heightFactor: 0.8,
            child: _widget({
              "title": 50,
              "subTitle": 34,
              "text": 20,
              "button": 40,
              "circleSize": 200,
              "circleThick": 15,
            }, context),
          );
        }
      }),
    );
  }
}
