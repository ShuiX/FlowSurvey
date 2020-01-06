import 'package:flutter/material.dart';
import 'package:va_flutter_project/modules/customDialogs.dart';
import 'package:va_flutter_project/modules/presetsData.dart';
import 'package:va_flutter_project/modules/firebaseApp.dart';
import 'package:va_flutter_project/pages/startSurvey.dart';

class HomeApp extends StatefulWidget {
  HomeApp({Key key, this.code}) : super(key: key);

  final String code;

  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  final mySurveyRequestCode = TextEditingController();

  void validateSurveyCode(String requestCode, BuildContext context) {
    FirebaseApp(requestCode).doc.get().then((schemaData) {
      if (schemaData.exists == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StartSurvey(
                    code: requestCode,
                    data: schemaData.data(),
                  )),
        );
      } else {
        //This Function or code comes later after the firebase init
        showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog(
            title: "FlowSurvey",
            content: PresetsData.invalidSurveyCode,
            dialogType: "blueAlert",
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    mySurveyRequestCode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.code != null) {
      validateSurveyCode(widget.code, context);
      mySurveyRequestCode.text = widget.code;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        padding: EdgeInsets.only(top: 150),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'FlowSurvey',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: pWidth * 0.125,
                  fontFamily: 'BlackChancery'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 90, top: 45, right: 50, bottom: 100),
            child: Row(
              children: <Widget>[
                Container(
                  width: pWidth * 0.35,
                  child: TextField(
                    style: TextStyle(fontSize: 20),
                    controller: mySurveyRequestCode,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Survey Code',
                    ),
                    onSubmitted: (mySurveyRequestCode) {
                      if (mySurveyRequestCode != '') {
                        validateSurveyCode(mySurveyRequestCode, context);
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Container(
                    width: 60,
                    height: 60,
                    child: RaisedButton(
                      child: Icon(Icons.arrow_forward),
                      textColor: Colors.black,
                      color: Colors.white,
                      hoverColor: Colors.grey[200],
                      onPressed: () {
                        if (mySurveyRequestCode.text != '') {
                          validateSurveyCode(mySurveyRequestCode.text, context);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.black,
                    textColor: Colors.white,
                    child: Text(
                      'About',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => CustomDialog(
                          title: "FlowSurvey",
                          content: PresetsData.aboutInfo,
                          dialogType: "little",
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: 37),
              child: IconButton(
                icon: Icon(Icons.person),
                iconSize: 35,
                tooltip: 'Sign in',
                onPressed: () {
                  Navigator.of(context).pushNamed('/account');
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              child: Icon(Icons.add),
              tooltip: 'Create',
              onPressed: () {
                Navigator.of(context).pushNamed('/create');
              },
            ),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
