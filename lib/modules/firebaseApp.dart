import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';

class FirebaseApp {
  final ref = firestore().collection("suverys");

  final String requestCode;
  var temp;

  FirebaseApp({this.requestCode, Auth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? auth();

  final Auth _firebaseAuth;

  DocumentReference get doc {
    return ref.doc(requestCode);
  }

  DocumentReference get resultsDoc {
    return ref.doc(requestCode).collection("data").doc("results");
  }

  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(email, password);
    } catch (e) {
      print('Error in sign in with FlowSurvey Account: $e');
      // return e;
      throw '$e';
    }
  }

  Future<UserCredential> signUp(String email, String password) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email,
        password,
      );
    } catch (e) {
      print('Error creating account: $e');
      throw '$e';
    }
  }

  Future<dynamic> signOut() async {
    try {
      return Future.wait([
        _firebaseAuth.signOut(),
      ]);
    } catch (e) {
      print('Error signin out: $e');
      // return e;
      throw '$e';
    }
  }

  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<String> getUserEmail() async {
    return (_firebaseAuth.currentUser).email;
  }

  Future<User> getUser() async {
    return _firebaseAuth.currentUser;
  }
}
