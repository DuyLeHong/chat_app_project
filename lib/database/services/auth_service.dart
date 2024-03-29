import 'package:chat_app_project/database/services/user_service.dart';
import 'package:chat_app_project/views/pages/auth/auth_screen.dart';
import 'package:chat_app_project/views/pages/auth/login_screen.dart';
import 'package:chat_app_project/views/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../views/pages/home/home_screen.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  static loginFetch(
      {required BuildContext context,
      required email,
      required password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final storage = FlutterSecureStorage();
      String? uID = userCredential.user?.uid.toString();
      await storage.write(key: 'uID', value: uID);
      String? value = await storage.read(key: 'uID');
      FocusScope.of(context).unfocus();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
      getSnackBar(
        'Login',
        'Login Success.',
        Colors.green,
      ).show(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        getSnackBar(
          'Login',
          'No user found for that email.',
          Colors.red,
        ).show(context);
        //print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print(e.code);

        getSnackBar(
                'Login', 'Wrong password provided for that user.', Colors.red)
            .show(context);
        //print('Wrong password provided for that user.');
      }
    }
  }

  static Logout({required BuildContext context}) async {
    try {
      FirebaseAuth.instance.signOut();
      final storage = FlutterSecureStorage();
      await storage.deleteAll();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
      getSnackBar(
        'Logout',
        'Logout Success.',
        Colors.green,
      ).show(context);
    } catch (e) {}
  }

  static registerFetch(
      {required BuildContext context,
      required email,
      required password,
      required fullName}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print('${userCredential.user?.uid}');
      await UserService.addUser(
          UID: userCredential.user?.uid, fullName: fullName, email: email);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      getSnackBar(
        'Register',
        'Register Success.',
        Colors.green,
      ).show(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        //print('The password provided is too weak.');
        getSnackBar(
          'Register',
          'The password provided is too weak.',
          Colors.red,
        ).show(context);
      } else if (e.code == 'email-already-in-use') {
        getSnackBar(
          'Register',
          'The account already exists for that email.',
          Colors.red,
        ).show(context);
        //print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
