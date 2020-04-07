import 'package:flutter/material.dart';
import 'package:va_flutter_project/modules/customDialogs.dart';
import 'package:va_flutter_project/modules/firebaseApp.dart';
import 'package:va_flutter_project/modules/presetsData.dart';

class Account extends StatefulWidget {
  final String data;

  Account({Key key, this.data}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final _unController = TextEditingController();
  final _pwController = TextEditingController();
  bool _validate = false;

  void _signIn() {
    if (_validateInputData("User", _unController.text) == null &&
        _validateInputData("", _pwController.text) == null) {
      setState(() {
        _validate = false;
      });
      FirebaseApp()
          .signInWithEmail(_unController.text, _pwController.text)
          .catchError((onError) {
        showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog(
            title: "FlowSurvey",
            content: PresetsData.loginFailed,
            dialogType: "blueAlert",
          ),
        );
      }).then((value) {
        print("yippyipp");
      });
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  dynamic _validateInputData(String labeltext, String inputData) {
    if (inputData == "") {
      return "Enter in your $labeltext data";
    }
    if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(inputData) ==
            false &&
        labeltext == "User") {
      return "Type in your E-Mail!";
    }
    return null;
  }

  Widget _inputText(
      String labelText,
      double titleSize,
      double textSize,
      TextEditingController textEditingController,
      double widthFactor,
      IconData iconData,
      bool obsecure,
      String hintText) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: TextField(
        obscureText: obsecure,
        style: TextStyle(
          fontSize: textSize,
          color: Colors.black,
        ),
        controller: textEditingController,
        decoration: InputDecoration(
          icon: Icon(
            iconData,
            color: Colors.black,
          ),
          hintText: hintText,
          hintStyle:
              TextStyle(color: Colors.blueGrey, fontSize: textSize * 0.75),
          labelText: labelText,
          errorText: _validate
              ? _validateInputData(labelText, textEditingController.text)
              : null,
          labelStyle: TextStyle(
            color: Colors.grey,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _signInWindow(double titleSize, double textSize, double widthfactor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 40),
          child: Text(
            "Sign In",
            style: TextStyle(
              fontSize: titleSize,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _inputText("User", titleSize, textSize, _unController, widthfactor,
            Icons.person, false, "Type in your E-Mail"),
        _inputText("Password", titleSize, textSize, _pwController, widthfactor,
            Icons.lock, true, "Type in your password"),
        Container(
          padding: EdgeInsets.only(top: 60),
          child: FloatingActionButton(
            heroTag: "Btn1",
            child: Icon(Icons.arrow_forward),
            backgroundColor: Colors.blue,
            splashColor: Colors.orange,
            onPressed: () => _signIn(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.white,
          child: LayoutBuilder(builder: (context, constraint) {
            if (constraint.maxWidth < 720) {
              return FractionallySizedBox(
                widthFactor: 0.9,
                heightFactor: 0.75,
                child: _signInWindow(35, 15, 0.9),
              );
            } else {
              return FractionallySizedBox(
                widthFactor: 0.6,
                heightFactor: 0.6,
                child: _signInWindow(55, 30, 0.5),
              );
            }
          }),
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
