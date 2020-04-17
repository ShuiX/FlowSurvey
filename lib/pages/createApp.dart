import 'package:flutter/material.dart';
import 'package:va_flutter_project/modules/firebaseApp.dart';

class CreateAppSwitch extends StatefulWidget {
  final String data;

  CreateAppSwitch({Key key, this.data}) : super(key: key);

  @override
  _CreateAppSwitchState createState() => _CreateAppSwitchState();
}

class _CreateAppSwitchState extends State<CreateAppSwitch> {
  Widget _createUnavailable() {
    return Center();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: FirebaseApp().isSignedIn(),
        builder: (context, snapshot) {
          switch (snapshot.data) {
            case true:
              return CreateAppSwitch();
              break;
            case false:
              return _createUnavailable();
              break;
            default:
              return Scaffold(
                body: Center(
                  child: Text("Error"),
                ),
                backgroundColor: Colors.black,
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

class CreateSurvey extends StatefulWidget {
  CreateSurvey({Key key}) : super(key: key);

  @override
  _CreateSurveyState createState() => _CreateSurveyState();
}

class _CreateSurveyState extends State<CreateSurvey> {
  Widget _scaffold(BuildContext context) {
    return Center(
      child: FractionallySizedBox(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 720) {
          return _scaffold(context);
        } else {
          return _scaffold(context);
        }
      }),
    );
  }
}
