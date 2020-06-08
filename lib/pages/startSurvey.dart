import 'package:flutter/material.dart';
import 'package:va_flutter_project/modules/firebaseApp.dart';
import 'package:va_flutter_project/modules/surveyCard.dart';


class StartSurvey extends StatefulWidget {
  final String code;
  final Map surveyData;

  StartSurvey({this.code, this.surveyData});

  @override
  _StartSurveyState createState() => _StartSurveyState();
}

class _StartSurveyState extends State<StartSurvey> {

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
      case 'info':
        return contentOption(context, data, route);
        break;
      default:
        break;
    }
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
                        widget.surveyData ?? {"lastRoute": {}, "history": {}},
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
