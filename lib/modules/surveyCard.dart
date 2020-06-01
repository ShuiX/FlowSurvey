import 'package:flutter/material.dart';

class SurveyCard extends StatefulWidget {
  final String route;
  final String code;
  final Map surveyData;

  SurveyCard({Key key, this.route, this.code, this.surveyData})
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

  Widget _surveyContent() {
    return Card(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("data"),
          _inputOptions("Insert"), //TODO: Insert The Snapshottype later

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //Use Streambuilder rather getting from final variables. Multiple Navigator issues can be avoided
    return StreamBuilder(
        stream: null, //TODO: insert stream
        builder: (context, snapshot) {
          return Center(
            child: LayoutBuilder(builder: (context, constraint) {
              if (constraint.maxWidth < 720) {
                return FractionallySizedBox(
                  widthFactor: 0.9,
                  heightFactor: 0.8,
                  child: _surveyContent(),
                );
              } else {
                return FractionallySizedBox(
                  widthFactor: 0.8,
                  heightFactor: 0.8,
                  child: _surveyContent(),
                );
              }
            }),
          );
        });
  }
}
