import 'package:flutter/material.dart';
import 'package:va_flutter_project/modules/firebaseApp.dart';
import 'package:va_flutter_project/modules/surveyCard.dart';
import 'package:va_flutter_project/pages/endingSurvey.dart';

class StartSurvey extends StatefulWidget {
  final String code;
  final Map surveyData;

  StartSurvey({this.code, this.surveyData});


  @override
  _StartSurveyState createState() => _StartSurveyState();
}

class _StartSurveyState extends State<StartSurvey> {
  List<Map> tempSave = [];
  List<Widget> surveyCards = [];
  String _currentOptionValue;
  String _followroute;

  @override
  void initState() {
    if (widget.code == null) {
      Navigator.pop(context);
    }
    super.initState();
  }

  dynamic inputOptions(
      BuildContext context, String type, Map data, String route) {
    switch (type) {
      case 'selection':
        return selectionOption(context, data, route);
        break;
      case 'sentence':
        return sentenceOption(context, data, route);
        break;
      case 'info':
        return contentOption(context, data, route);
        break;
      default:
        break;
    }
  }

  void finishSurvey(BuildContext context, Map data) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EndingSurvey(
                endingDescription: data["endingdescription"],
                results: tempSave,
                code: widget.code,
              )),
    );
  }

  contentOption(BuildContext context, Map data, String route) {
    List<Widget> textContent = new List<Widget>();
    textContent.add(
      Text(
        data[route]["reply"]["content"],
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    );
    return textContent;
  }

  sentenceOption(BuildContext context, Map data, String route) {
    var sentenceOptionText = TextEditingController();
    _followroute = data[route]["reply"]["followroute"];
    List<Widget> sentence = new List<Widget>();
    sentence.add(TextField(
      controller: sentenceOptionText,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Enter your Answer',
        labelStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
      style: TextStyle(fontSize: 20, color: Colors.black),
      onChanged: (textValue) {
        _currentOptionValue = textValue;
        _followroute = data[route]["reply"]["followroute"];
      },
      onSubmitted: (textValue) {
        _currentOptionValue = textValue;
        tempSave.add(
          {
            "value": _currentOptionValue,
            "followroute": _followroute,
            "route": route,
            "type": data[route]["type"]
          },
        );
        if (_followroute == "finish") {
          finishSurvey(context, {});
        } else {
          setState(() {});
        }
      },
    ));
    return sentence;
  }

  selectionOption(BuildContext context, Map data, String route) {
    List<Widget> optionList = new List<Widget>();
    for (var item in data[route]["reply"]) {
      setState(() {
        optionList.add(new RadioListTile(
          title: Text(
            item["selection"],
            style: TextStyle(color: Colors.black),
          ),
          value: item["selection"],
          groupValue: _currentOptionValue,
          onChanged: (value) {
            this.setState(() {
              _currentOptionValue = value;
              _followroute = item["followroute"];
              surveyCards.removeLast();
            });
          },
        ));
      });
    }
    return optionList;
  }

  Widget _startCard(double titleSize, double subtitleSize, double textSize,
      double buttonWidth, double buttonHeight, double buttonPadding, Map data) {
    return Card(
      shape: RoundedRectangleBorder(
          side: new BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(12.0)),
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          ListView(
            padding: EdgeInsets.symmetric(horizontal: 30),
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text(
                    data["title"],
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      fontFamily: "BlackChancery",
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text(
                    data["descriptiontitle"],
                    style: TextStyle(
                      fontSize: subtitleSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 40, bottom: 150),
                  child: Text(
                    data["description"],
                    style: TextStyle(
                      fontSize: textSize,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              iconSize: 40,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: buttonPadding),
              child: RaisedButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context, _, __) => SurveyCard(
                        "start",
                        widget.code,
                        widget.surveyData ?? {},
                        data["title"],
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
                child: Container(
                  width: buttonWidth,
                  height: buttonHeight,
                  child: Center(
                    child: Text(
                      "Start",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: subtitleSize - 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder(
          stream: FirebaseApp().surveyStart(widget.code),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                return Center(
                  child: LayoutBuilder(builder: (context, constraint) {
                    if (constraint.maxWidth < 720) {
                      return FractionallySizedBox(
                        widthFactor: 0.9,
                        heightFactor: 0.8,
                        child:
                            _startCard(25, 17, 13, 100, 50, 20, snapshot.data),
                      );
                    } else {
                      return FractionallySizedBox(
                        widthFactor: 0.8,
                        heightFactor: 0.8,
                        child:
                            _startCard(50, 34, 20, 180, 75, 40, snapshot.data),
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
          }),
    );
  }
}
