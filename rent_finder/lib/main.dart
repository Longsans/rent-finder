import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rent_finder/data/authentication/auth.dart' as auth;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({
    Key key,
  }) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  controller: emailController,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  obscureText: true,
                  controller: passwordController,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                ),
                TextButton(
                  onPressed: () async {
                    final authResult = await auth.signInWithEmailAndPassword(
                        emailController.text, passwordController.text);

                    if (authResult) {
                      print("Signed in successfully.");
                    } else {
                      print("Sign in failed.");
                    }
                  },
                  child: Text(
                    "Sign in",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    textStyle: TextStyle(fontSize: 25),
                    elevation: 0,
                    minimumSize: Size(double.infinity, 20),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 20,
                ),
                Text(
                  "or",
                  style: TextStyle(fontSize: 20, color: Colors.black54),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 20,
                ),
                TextButton(
                  onPressed: () async {
                    final regResult = await auth.register(
                        emailController.text, passwordController.text);

                    if (regResult) {
                      print("Registered successfully.");
                    } else {
                      print("Register failed.");
                    }
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    textStyle: TextStyle(fontSize: 25),
                    elevation: 0,
                    minimumSize: Size(double.infinity, 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
