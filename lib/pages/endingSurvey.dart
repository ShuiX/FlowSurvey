import 'package:flutter/material.dart';

import 'package:va_flutter_project/modules/firebaseApp.dart';

class EndingSurvey extends StatefulWidget {
  final String code;

  EndingSurvey(this.code);

  @override
  _EndingSurveyState createState() => _EndingSurveyState();
}

class _EndingSurveyState extends State<EndingSurvey> {
  @override
  void initState() {
    FirebaseApp().surveyExist(widget.code).then((onValue) {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder(
        stream: FirebaseApp().surveyStart(widget.code),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    snapshot.data["endingdescription"],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
        },
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
