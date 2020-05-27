import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';

class FirebaseApp {
  final refSurveys = firestore().collection("suverys");
  final refUsers = firestore().collection("users");

  FirebaseApp() : _firebaseAuth = auth();

  final Auth _firebaseAuth;

  Future<bool> surveyExist(String requestCode) {
    return refSurveys.where("survey", "==", requestCode).get().then((value) {
      return value.empty;
    });
  }

  Stream<Map> surveyStart(String requestCode) {
    return refSurveys.doc(requestCode).onSnapshot.map((event) => event.data());
  }

  Future<QuerySnapshot> get userData async {
    return refUsers.where("email", "==", await getUserEmail()).get();
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
    return refUsers.where("email", "==", email).get();
  }

  Future<dynamic> deleteUser() async {
    try {
      return Future.wait([
        refUsers.where("email", "==", await getUserEmail()).get().then((value) {
          refUsers.doc(value.docs.single.id).delete();
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
}
