import 'package:flutter/material.dart';
import 'package:va_flutter_project/modules/firebaseApp.dart';
import 'package:va_flutter_project/pages/accountApp.dart';

class CreateAppSwitch extends StatefulWidget {
  final String data;

  CreateAppSwitch({Key key, this.data}) : super(key: key);

  @override
  _CreateAppSwitchState createState() => _CreateAppSwitchState();
}

class _CreateAppSwitchState extends State<CreateAppSwitch> {
  Widget _createUnavailable() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "You're not signed in yet to use this feature",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 30),
            width: 237,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountSwitch(),
                  ),
                );
              },
              child: Row(
                children: [
                  Text(
                    " Sign In",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    size: 60,
                  ),
                ],
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
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: FirebaseApp().isSignedIn(),
        builder: (context, snapshot) {
          switch (snapshot.data) {
            case true:
              return CreateSurvey();
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
  Widget _scaffoldDesktop(BuildContext context) {
    return Container();
  }

  Widget _scaffoldMobile(BuildContext context) {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 720) {
          return Card(
            color: Colors.white,
            child: FractionallySizedBox(
              widthFactor: 0.95,
              heightFactor: 0.75,
              child: _scaffoldMobile(context),
            ),
          );
        } else {
          return Card(
            color: Colors.white,
            child: FractionallySizedBox(
              widthFactor: 0.9,
              heightFactor: 0.9,
              child: _scaffoldDesktop(context),
            ),
          );
        }
      }),
    );
  }
}
