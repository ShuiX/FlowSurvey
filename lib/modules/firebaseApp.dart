import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';

class FirebaseApp {
  final _refSurveys = firestore().collection("suverys");
  final _refUsers = firestore().collection("users");

  FirebaseApp() : _firebaseAuth = auth();

  final Auth _firebaseAuth;

  Future<bool> surveyExist(String requestCode) {
    return _refSurveys.where("survey", "==", requestCode).get().then((value) {
      return value.empty;
    });
  }

  Stream<Map> surveyStart(String requestCode) {
    return _refSurveys.doc(requestCode).onSnapshot.map((event) => event.data());
  }

  Stream<Map> surveyRouteData(String requestCode, String route) {
    return _refSurveys
        .doc(requestCode)
        .collection("survey")
        .doc(route)
        .onSnapshot
        .map((event) => event.data());
  }

  Future<bool> postSurveyResult(
      String requestCode, String route, String type, dynamic value) async {
    if (value != null) {
      Map temp = await _refSurveys
          .doc(requestCode)
          .collection("results")
          .doc(route)
          .get()
          .then((value) => value.data());

      DocumentReference doc =
          _refSurveys.doc(requestCode).collection("results").doc(route);

      switch (type) {
        case "radio":
          return doc
              .update(data: {value: temp[value] + 1})
              .then((_) => true)
              .catchError((_) => false);
          break;
        case "sentence":
          temp["sentenceArray"].add(value);
          return doc
              .update(data: {"sentenceArray": temp["sentenceArray"]})
              .then((_) => true)
              .catchError((_) => false);
          break;
        default:
          return false;
          break;
      }
    } else {
      return true;
    }
  }

  Future<QuerySnapshot> get userData async {
    return _refUsers.where("email", "==", await getUserEmail()).get();
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

  Future<QuerySnapshot> checkUserbyString(String email) async {
    return _refUsers.where("email", "==", email).get();
  }

  Future<dynamic> deleteUser() async {
    try {
      return Future.wait([
        _refUsers
            .where("email", "==", await getUserEmail())
            .get()
            .then((value) {
          _refUsers.doc(value.docs.single.id).delete();
        }),
        _firebaseAuth.currentUser.delete(),
      ]);
    } catch (e) {
      print('Error deleting Account: $e');
      // return e;
      throw '$e';
    }
  }

  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<String> getUserEmail() async {
    return _firebaseAuth.currentUser.email;
  }

  Future<User> getUser() async {
    return _firebaseAuth.currentUser;
  }

  Future<DocumentReference> addUserDB(Map<String, dynamic> data) {
    return _refUsers.add(data);
  }
}
