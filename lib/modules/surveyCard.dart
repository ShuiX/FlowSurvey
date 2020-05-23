import 'package:flutter/material.dart';

class SurveyCard extends StatefulWidget {
  final Map data;
  final String route;
  final String code;

  SurveyCard({Key key, this.data, this.route, this.code}) : super(key: key);

  @override
  _SurveyCardState createState() => _SurveyCardState();
}

class _SurveyCardState extends State<SurveyCard> {
  Widget _inputOptions() {
    switch (widget.data["type"]) {
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
    return Column(
      children: [
        _inputOptions(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
  }
}
