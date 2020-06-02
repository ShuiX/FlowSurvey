import 'package:flutter/material.dart';
import 'package:va_flutter_project/modules/firebaseApp.dart';

class SurveyCard extends StatefulWidget {
  final String title;
  final String route;
  final String code;
  final Map surveyData;

  SurveyCard({Key key, this.route, this.code, this.surveyData, this.title})
      : super(key: key);

  @override
  _SurveyCardState createState() => _SurveyCardState();
}

class _SurveyCardState extends State<SurveyCard> {
  Widget _inputOptions(String type) {
    switch (type) {
      case 'selection':
        return _selectionOption();
        break;
      case 'sentence':
        return _sentenceOption();
        break;
      case 'checkbox':
        return _checkboxOption();
        break;
      case 'info':
        return _contentOption();
        break;
      default:
        return _error();
        break;
    }
  }

  Widget _error() {
    return Container();
  }

  Widget _checkboxOption() {
    return Container();
  }

  Widget _contentOption() {
    return Container();
  }

  Widget _sentenceOption() {
    return Container();
  }

  Widget _selectionOption() {
    return Container();
  }

  Widget _surveyContent(Map fontData) {
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
              iconSize: 40,
              onPressed: () {
                Navigator.pop(context);
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
              _inputOptions("Insert Type"),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseApp()
            .surveyRouteData(widget.code, widget.route),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              return Center(
                child: LayoutBuilder(builder: (context, constraint) {
                  if (constraint.maxWidth < 720) {
                    return FractionallySizedBox(
                      widthFactor: 0.9,
                      heightFactor: 0.8,
                      child: _surveyContent({"title": 25}),
                    );
                  } else {
                    return FractionallySizedBox(
                      widthFactor: 0.8,
                      heightFactor: 0.8,
                      child: _surveyContent({"title": 50}),
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
