import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:va_flutter_project/modules/firebaseApp.dart';

class EndingSurvey extends StatefulWidget {
  final String endingDescription;
  final String code;
  final List results;

  EndingSurvey({Key key, this.endingDescription, this.code, this.results})
      : super(key: key);

  @override
  _EndingSurveyState createState() => _EndingSurveyState();
}

class _EndingSurveyState extends State<EndingSurvey> {
  @override
  void initState() {
    FirebaseApp(widget.code).resultsDoc.get().then((onValue) {
      var resultData = onValue.data();
      var results = jsonDecode(resultData["data"]);
      var tempSave = widget.results;
      for (var item in tempSave) {
        switch (item["type"]) {
          case 'selection':
            ++results[item["route"]][item["value"]];
            break;
          case 'sentence':
            results[item["route"]].add(item["value"]);
            break;
          default:
            break;
        }
      }
      results = jsonEncode(results);

      FirebaseApp(widget.code).resultsDoc.set({"data": results});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            widget.endingDescription,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      floatingActionButton: Stack(
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
