import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';

class FirebaseApp {
  final ref = firestore().collection("suverys");

  final String requestCode;
  var temp;

  FirebaseApp(this.requestCode);

  DocumentReference get doc {
    return ref.doc(requestCode);
  }

  DocumentReference get resultsDoc {
    return ref.doc(requestCode).collection("data").doc("results");
  }
}
