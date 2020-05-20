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
  _inputOptions(BuildContext context, String type, Map data, String route) {
    switch (type) {
      case 'selection':
        return _selectionOption(context, data, route);
        break;
      case 'sentence':
        return _sentenceOption(context, data, route);
        break;
      case 'checkbox':
        return _checkboxOption(context, data, route);
        break;
      case 'info':
        return _contentOption(context, data, route);
        break;
      default:
        break;
    }
  }

  Widget _checkboxOption(BuildContext context, Map data, String route) {
    return Container();
  }

  Widget _contentOption(BuildContext context, Map data, String route) {
    return Container();
  }

  Widget _sentenceOption(BuildContext context, Map data, String route) {
    return Container();
  }

  Widget _selectionOption(BuildContext context, Map data, String route) {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return _inputOptions(context, "type", {}, "route");
  }
}
