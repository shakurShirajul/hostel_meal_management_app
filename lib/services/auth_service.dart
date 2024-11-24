import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meal_management/Classes/UserEmailProvider.dart';
import 'package:meal_management/Classes/UserNameProvider.dart';
import 'package:meal_management/Home.dart';
import 'package:meal_management/Pages/Login.dart';

// import 'package:meal_management/Pages/admin/AdminDashboard.dart';
import 'package:meal_management/Pages/admin/DashboardScreen.dart';
import 'package:meal_management/Pages/student/StudentDashboardScreen.dart';
import 'package:provider/provider.dart';

class AuthService {
  Future<void> signup(
      {required String name,
      required String email,
      required String password,
      required BuildContext context}) async {
    print("Registration: $name $email $password");
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await Future.delayed(const Duration(seconds: 1));

      // Here Add Database Code
      String uid = userCredential.user!.uid;
      User? user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'role': 'student', // Example role, change as needed
        }).then((value) {
          // After success, show the toast
          Fluttertoast.showToast(
            msg: "Student Added Successfully!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 14.0,
          );

          // Optionally, you can navigate to another screen after registration
          // Navigator.pushReplacement(context,
          //     MaterialPageRoute(builder: (BuildContext context) => const DashboardScreen()));
        }).onError((e, f) {
          Fluttertoast.showToast(
            msg: "Failed to add user to Firestore. Please try again.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14.0,
          );
        });
      }

      // Navigator.pushReplacement(context,
      //     MaterialPageRoute(builder: (BuildContext context) => const Home()));
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {
      print("Add New Students Error: $e");
    }
  }

  Future<void> signin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    print("shakur $email $password");
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      Provider.of<UserEmailProvider>(context, listen: false)
          .setUserEmail(email);

      // Searching Users Data From Database
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email) // Search for the email
          .get();

      var userDoc = querySnapshot.docs.first;
      String? userRole = userDoc['role'];

      Provider.of<UserNameProvider>(context, listen: false)
          .setUserName(userDoc['name']);

      // await Future.delayed(const Duration(seconds: 1));

      if(userRole=='student'){
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => const StudentDashboardScreen()));
      }else if(userRole == 'admin'){
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => const DashboardScreen()));
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'No user found for that email.';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for that user.';
      }
      print("Error === $message");
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {

    }
  }

  Future<void> signout({required BuildContext context}) async {
    await FirebaseAuth.instance.signOut();
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Login()));
  }
}
