import 'package:flutter/material.dart';
import 'package:va_flutter_project/pages/homeApp.dart';
import 'package:va_flutter_project/pages/createApp.dart';
import 'package:va_flutter_project/pages/accountApp.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //Here getting the arguement pushed by navigator.push
    final args = settings.arguments;

    switch (settings.name) {
      case '':
        return MaterialPageRoute(builder: (_) => HomeApp());
        break;
      case '/':
        return MaterialPageRoute(builder: (_) => HomeApp());
        break;
      case '/create':
        return MaterialPageRoute(
          builder: (_) => CreateApp(
            data: args,
          ),
        );
        break;
      case '/account':
        return MaterialPageRoute(
          builder: (_) => AccountSwitch(
            data: args,
          ),
        );
        break;
      case '/startSurvey':
        return MaterialPageRoute(
          builder: (_) => HomeApp(
            code: args,
          ),
        );
        break;
      default:
        return _errorRoute();
        break;
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Destination not found! :/'),
            centerTitle: true,
          ),
          body: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Error',
                  style: TextStyle(
                      fontFamily: 'Terminal',
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 100),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
