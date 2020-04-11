import 'package:flutter/material.dart';
import 'package:va_flutter_project/modules/customDialogs.dart';
import 'package:va_flutter_project/modules/firebaseApp.dart';
import 'package:va_flutter_project/modules/presetsData.dart';

class AccountSwitch extends StatefulWidget {
  final String data;

  AccountSwitch({Key key, this.data}) : super(key: key);

  @override
  _AccountSwitchState createState() => _AccountSwitchState();
}

class _AccountSwitchState extends State<AccountSwitch> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseApp().isSignedIn(),
      builder: (context, snapshot) {
        switch (snapshot.data) {
          case true:
            return AccountPage(
              data: FirebaseApp().getUserEmail(),
            );
            break;
          case false:
            return SignIn();
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
    );
  }
}

class SignIn extends StatefulWidget {
  final String data;

  SignIn({Key key, this.data}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _unController = TextEditingController();
  final _pwController = TextEditingController();
  bool _validateEmail = false;
  bool _validatePassword = false;

  void _signIn() {
    if (_validateInputData("User", _unController.text) == null &&
        _validateInputData("", _pwController.text) == null) {
      setState(() {
        _validateEmail = false;
        _validatePassword = false;
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
      }).then(
        (_) {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AccountPage(),
            ),
          );
        },
      );
    }
    if (_validateInputData("User", _unController.text) != null) {
      setState(() {
        _validateEmail = true;
      });
    }
    if (_validateInputData("", _pwController.text) != null) {
      _validatePassword = true;
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
      return "Invalid E-Mail format";
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
      String hintText,
      bool validation,
      String validateField) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: TextField(
        obscureText: obsecure,
        style: TextStyle(
          fontSize: textSize,
          color: Colors.black,
        ),
        controller: textEditingController,
        onSubmitted: (val) => _signIn(),
        onChanged: (val) {
          setState(() {
            validation = false;
          });
        },
        decoration: InputDecoration(
          icon: Icon(
            iconData,
            color: Colors.black,
          ),
          hintText: hintText,
          hintStyle:
              TextStyle(color: Colors.blueGrey, fontSize: textSize * 0.75),
          labelText: labelText,
          errorText: validation
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
        _inputText(
            "User",
            titleSize,
            textSize,
            _unController,
            widthfactor,
            Icons.person,
            false,
            "Type in your E-Mail",
            _validateEmail,
            "email"),
        _inputText(
            "Password",
            titleSize,
            textSize,
            _pwController,
            widthfactor,
            Icons.lock,
            true,
            "Type in your password",
            _validatePassword,
            "password"),
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

class AccountPage extends StatefulWidget {
  final dynamic data;

  AccountPage({Key key, this.data}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String _bruh = "bruh";

  @override
  void initState() {
    super.initState();

    //ignore: sdk_version_set_literal
    FirebaseApp().getUserEmail().then((value) => {
          setState(() {
            _bruh = value;
          })
        });
  }

  Widget _accountCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _bruh,
          style: TextStyle(
            color: Colors.black,
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
                child: _accountCard(),
              );
            } else {
              return FractionallySizedBox(
                widthFactor: 0.6,
                heightFactor: 0.6,
                child: _accountCard(),
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
