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
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
