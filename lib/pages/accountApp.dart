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
            return AccountPage();
            break;
          case false:
            return SignOptions();
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

  void _signIn() async {
    if (_validateInputData("User", _unController.text) == null &&
        _validateInputData("", _pwController.text) == null) {
      bool signInSuccess = true;
      setState(() {
        _validateEmail = false;
        _validatePassword = false;
      });
      await FirebaseApp()
          .signInWithEmail(_unController.text, _pwController.text)
          .catchError((onError) {
        signInSuccess = false;
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
          if (signInSuccess == true) {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AccountPage(),
              ),
            );
          }
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

  String _validateInputData(String labeltext, String inputData) {
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

class SignOptions extends StatefulWidget {
  SignOptions({Key key}) : super(key: key);

  @override
  _SignOptionsState createState() => _SignOptionsState();
}

class _SignOptionsState extends State<SignOptions> {
  Widget _widget = SignIn();
  double _signUpOpacity = 1;
  double _signInOpacity = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedSwitcher(
          duration: Duration(milliseconds: 750),
          transitionBuilder: (Widget child, Animation<double> animation) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: _widget,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _signUpOpacity,
              duration: Duration(milliseconds: 450),
              child: Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(bottom: 10, left: 5, right: 5),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Sign up",
                    style: TextStyle(),
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() {
                      this._widget = SignUp();
                      this._signUpOpacity = 0;
                      this._signInOpacity = 1;
                    });
                  },
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: _signInOpacity,
              duration: Duration(milliseconds: 450),
              child: Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(bottom: 10, left: 5, right: 5),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Sign In",
                    style: TextStyle(),
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() {
                      this._widget = SignIn();
                      this._signInOpacity = 0;
                      this._signUpOpacity = 1;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SignUp extends StatefulWidget {
  SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _usernameTextController = TextEditingController();
  final _nameTextController = TextEditingController();
  final _surnameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  bool _usernameValid = false;
  bool _nameValid = false;
  bool _surnameValid = false;
  bool _emailValid = false;
  bool _passwordValid = false;

  double _submitOpacity = 0;

  void _signUp() async {
    if (_submitOpacity == 1) {
      setState(() {
        _usernameValid = true;
        _surnameValid = true;
        _nameValid = true;
        _emailValid = true;
        _passwordValid = true;
      });
    }
    if (_usernameTextController.text != "" &&
        _validateInputData("E-Mail", _emailTextController.text) == null &&
        _surnameTextController.text != "" &&
        _nameTextController.text != "" &&
        _passwordTextController.text != "" &&
        _submitOpacity == 1) {
      Map<String, dynamic> data = {
        "email": _emailTextController.text,
        "surname": _surnameTextController.text,
        "name": _nameTextController.text,
        "username": _usernameTextController.text
      };
      FirebaseApp().checkUserbyString(_emailTextController.text).then((value) {
        if (value.docs.isEmpty == false) {
          showDialog(
            context: context,
            builder: (BuildContext context) => CustomDialog(
              title: "FlowSurvey",
              content: PresetsData.registringUserExists,
              dialogType: "blueAlert",
            ),
          );
        } else {
          bool errorcatch = false;
          FirebaseApp()
              .signUp(_emailTextController.text, _passwordTextController.text)
              .catchError((error) {
            errorcatch = true;
            showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(
                title: "FlowSurvey",
                content: PresetsData.somethingFailed,
                dialogType: "redAlert",
              ),
            );
          }).then((value) {
            if (errorcatch == false) {
              FirebaseApp().addUserDB(data).then((value) {
                Navigator.pop(context);
              }).catchError((onError) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => CustomDialog(
                    title: "FlowSurvey",
                    content: PresetsData.somethingFailed,
                    dialogType: "redAlert",
                  ),
                );
              });
            }
          });
        }
      });
    }
  }

  String _validateInputData(String labeltext, String inputData) {
    if (inputData == "") {
      return "Enter in your $labeltext data";
    }
    if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(inputData) ==
            false &&
        labeltext == "E-Mail") {
      return "Invalid E-Mail format";
    }
    return null;
  }

  void _submitButton() {
    if (_usernameTextController.text != "" &&
        _emailTextController.text != "" &&
        _surnameTextController.text != "" &&
        _nameTextController.text != "" &&
        _passwordTextController.text != "") {
      setState(() {
        _submitOpacity = 1;
      });
    } else {
      _submitOpacity = 0;
    }
  }

  Widget _inputText(
      String labelText,
      double titleSize,
      double textSize,
      TextEditingController textEditingController,
      bool obsecure,
      String hintText,
      bool validation) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        obscureText: obsecure,
        style: TextStyle(
          fontSize: textSize,
          color: Colors.black,
        ),
        controller: textEditingController,
        onChanged: (val) {
          setState(() {
            validation = false;
          });
          _submitButton();
        },
        decoration: InputDecoration(
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

  Widget _signUpWindowMobile(double titleSize, double textSize) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Mobile",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _signUpWindowDesktop(
      double titleSize, double textSize, double widthFactor) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  height: 125,
                  width: 1,
                ),
                AnimatedOpacity(
                  opacity: _submitOpacity,
                  duration: Duration(milliseconds: 500),
                  child: RaisedButton(
                    child: Text("Submit"),
                    color: Colors.blue,
                    onPressed: () => _signUp(),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Container(
              color: Colors.black,
              width: 1,
              height: MediaQuery.of(context).size.height * 0.3,
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _inputText(
                  "Username",
                  titleSize,
                  textSize,
                  _usernameTextController,
                  false,
                  "Create your Username here",
                  _usernameValid,
                ),
                _inputText(
                  "E-Mail",
                  titleSize,
                  textSize,
                  _emailTextController,
                  false,
                  "Enter your E-Mail",
                  _emailValid,
                ),
                _inputText(
                  "Password",
                  titleSize,
                  textSize,
                  _passwordTextController,
                  true,
                  "Enter a Password",
                  _passwordValid,
                ),
                _inputText(
                  "Name",
                  titleSize,
                  textSize,
                  _nameTextController,
                  false,
                  "Enter Name here",
                  _nameValid,
                ),
                _inputText(
                  "Surname",
                  titleSize,
                  textSize,
                  _surnameTextController,
                  false,
                  "Enter Surname here",
                  _surnameValid,
                ),
                RaisedButton(onPressed: null)
              ],
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
                child: _signUpWindowMobile(35, 15),
              );
            } else {
              return FractionallySizedBox(
                widthFactor: 0.6,
                heightFactor: 0.6,
                child: _signUpWindowDesktop(45, 25, 0.5),
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
  AccountPage({Key key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
  }

  void _signingOut() async {
    await FirebaseApp().signOut().catchError((onError) {
      showDialog(
        context: context,
        builder: (BuildContext context) => CustomDialog(
          title: "FlowSurvey",
          content: PresetsData.signoutfailed,
          dialogType: "redAlert",
        ),
      );
    }).then(
      (_) {
        Navigator.of(context).pop();
      },
    );
  }

  void _deleteAccoutn() async {
    await FirebaseApp().deleteUser().catchError((onError) {
      showDialog(
        context: context,
        builder: (BuildContext context) => CustomDialog(
          title: "FlowSurvey",
          content: PresetsData.deleteUserFailed,
          dialogType: "redAlert",
        ),
      );
    }).then(
      (_) {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _accountContent(
    Map data,
    double titleSize,
    double subtitleSize,
    double textSize,
    BuildContext context,
    double buttonWidth,
    double buttonHeight,
  ) {
    String username = data["username"];
    String email = data["email"];
    String surname = data["surname"];
    String name = data["name"];
    return Column(
      children: [
        Container(
          color: Colors.grey,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.155,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  heightFactor: 1,
                  child: Center(
                    child: Text(
                      "@$username",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: titleSize,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  heightFactor: 1,
                  child: Center(
                    child: Text(
                      email,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: textSize,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 3,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(
                "Welcome back $surname $name!",
                style: TextStyle(
                  fontSize: subtitleSize,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: RaisedButton(
                  onPressed: _signingOut,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.blue,
                  child: Container(
                    width: buttonWidth,
                    height: buttonHeight,
                    child: Center(
                      child: Text(
                        "Sign Out",
                        style: TextStyle(fontSize: subtitleSize),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: RaisedButton(
                  onPressed: _deleteAccoutn,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.red,
                  child: Container(
                    width: buttonWidth,
                    height: buttonHeight,
                    child: Center(
                      child: Text(
                        "Delete Account",
                        style: TextStyle(fontSize: subtitleSize),
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
        child: StreamBuilder(
            stream: FirebaseApp().userData.asStream(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.white,
                    child: LayoutBuilder(builder: (context, constraint) {
                      if (constraint.maxWidth < 720) {
                        return FractionallySizedBox(
                          widthFactor: 0.9,
                          heightFactor: 0.75,
                          child: _accountContent(
                            snapshot.data.docs.single.data(),
                            25,
                            15,
                            11,
                            context,
                            60,
                            37.5,
                          ),
                        );
                      } else {
                        return FractionallySizedBox(
                          widthFactor: 0.6,
                          heightFactor: 0.6,
                          child: _accountContent(
                            snapshot.data.docs.single.data(),
                            50,
                            30,
                            16,
                            context,
                            250,
                            75,
                          ),
                        );
                      }
                    }),
                  );
                  break;
                case ConnectionState.none:
                  return Text("Connection failed");
                  break;
                case ConnectionState.waiting:
                  return Text("Waiting");
                  break;
                case ConnectionState.active:
                  return Text("Getting Data");
                  break;
                default:
                  return Text("Error with Connecting");
                  break;
              }
            }),
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
