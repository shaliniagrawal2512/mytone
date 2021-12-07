import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mytone/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authenticate {
  Future<String> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for this email.';
      } else if (e.code == 'wrong-password') {
        return 'Invalid email or password';
      }
      return 'Check your internet connection or try again later';
    }
  }

  Future<String> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'Email already registered';
      }
    } catch (e) {
      return 'error signing up';
    }
    return 'Check your internet connection or try again later';
  }

  Future<String> forgetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      return 'Password Reset Email has been sent !';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for this email.';
      }
    }
    return 'Check your internet connection or try again later';
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('phoneNumber');
  }

  Future<void> updateUserPassword(String password) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    await currentUser!.updatePassword(password);
  }

  Future<void> deleteUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    await currentUser!.delete();
  }

  Future<void> postDetailsToFirestore(String name) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore store = FirebaseFirestore.instance;
    UserData userInfo = UserData();
    userInfo.email = currentUser!.email;
    userInfo.phoneNumber = currentUser.phoneNumber;
    userInfo.name = name;
    userInfo.uid = currentUser.uid;
    await store.collection("users").doc(currentUser.uid).set(userInfo.toMap());
  }
}
