import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:va_flutter_project/pages/endingSurvey.dart';

class StartSurvey extends StatefulWidget {
  final String code;
  final Map data;

  StartSurvey({Key key, this.code, this.data}) : super(key: key);

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
    surveyCards.add(startCard(context));
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

  void initSurvey(BuildContext context) {
    var data = jsonDecode(widget.data["surveyschema"]);
    setState(() {
      surveyCards.add(surveyCard(context, data, "start"));
    });
  }

  void finishSurvey(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EndingSurvey(
                endingDescription: widget.data["endingdescription"],
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
          finishSurvey(context);
        } else {
          setState(() {
            surveyCards.add(surveyCard(context, data, _followroute));
          });
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
              surveyCards.add(surveyCard(context, data, route));
            });
          },
        ));
      });
    }
    return optionList;
  }

  surveyCard(BuildContext context, Map data, String route) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      heightFactor: 0.8,
      child: Card(
        shape: RoundedRectangleBorder(
            side: new BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(12.0)),
        color: Colors.white,
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
                      widget.data["title"],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 50,
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
                      data[route]["request"],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Column(
                      children: inputOptions(
                          context, data[route]["type"], data, route),
                    ),
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(bottom: 20, right: 20),
                child: FloatingActionButton(
                  child: Icon(
                    Icons.arrow_forward,
                  ),
                  tooltip: 'Next',
                  onPressed: () {
                    if (data[route]["type"] == "info") {
                      setState(() {
                        _followroute = data[route]["routeskip"];
                      });
                    }
                    if (_currentOptionValue != null || _followroute != null) {
                      tempSave.add({
                        "value": _currentOptionValue,
                        "followroute": _followroute,
                        "route": route,
                        "type": data[route]["type"]
                      });
                      if (_followroute == "finish") {
                        finishSurvey(context);
                      } else {
                        setState(() {
                          surveyCards
                              .add(surveyCard(context, data, _followroute));
                          _currentOptionValue = null;
                          _followroute = null;
                        });
                      }
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 9, left: 11),
                child: IconButton(
                  color: Colors.black,
                  iconSize: 32,
                  icon: Icon(Icons.arrow_back),
                  tooltip: 'go back',
                  onPressed: () {
                    setState(() {
                      surveyCards.removeLast();
                      if (tempSave.length != 0) {
                        _followroute =
                            tempSave[tempSave.length - 1]["followroute"];
                        _currentOptionValue =
                            tempSave[tempSave.length - 1]["value"];
                        tempSave.removeLast();
                      }
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  startCard(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      heightFactor: 0.8,
      child: Card(
        shape: RoundedRectangleBorder(
            side: new BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(12.0)),
        color: Colors.white,
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
                      widget.data["title"],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 50,
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
                      widget.data["descriptiontitle"],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 34,
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
                      widget.data["description"],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: RaisedButton(
                  onPressed: () {
                    initSurvey(context);
                  },
                  child: Container(
                    width: 180,
                    height: 75,
                    child: Center(
                      child: Text(
                        "Start",
                        style: TextStyle(
                          fontSize: 32,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: surveyCards,
        ),
      ),
      floatingActionButton: new Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20, top: 27),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                iconSize: 50,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
