import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  final String data;

  Account({Key key, this.data}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final _unController = TextEditingController();
  final _pwController = TextEditingController();

  Widget _inputText(String labelText, double titleSize, double textSize,
      TextEditingController textEditingController, double widthFactor, IconData iconData, bool obsecure) {
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
          labelText: labelText,
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
        _inputText("Username", titleSize, textSize, _unController, widthfactor, Icons.person, false),
        _inputText("Password", titleSize, textSize, _pwController, widthfactor, Icons.lock, true),
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
