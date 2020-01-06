import 'package:flutter/material.dart';
import 'package:va_flutter_project/modules/routeGenerator.dart';
import 'package:va_flutter_project/pages/homeApp.dart';
import 'package:firebase/firebase.dart' as fb;

void main() {
  if (fb.apps.isEmpty) {
    fb.initializeApp(
      apiKey: "yourAPIKey",
      authDomain: "yourAuthDomain",
      databaseURL: "yourDatabaseURL",
      projectId: "yourProjectId",
      storageBucket: "yourStorageBucket",
      messagingSenderId: "yourCessagingSenderId",
    );
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlowSurvey',
      theme: ThemeData(brightness: Brightness.dark),
      home: HomeApp(),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
