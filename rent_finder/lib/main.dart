import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rent_finder/data/authentication/auth.dart';
import 'package:rent_finder/data/data_providers/data_providers.dart';
import 'package:rent_finder/data/models/models.dart' as models;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Auth.instance.litenToAuthStateChanged((e) {
    print('User changed to $e');
  });

  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({
    Key key,
  }) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  try {
                    final houseApi = HouseFireStoreApi();
                    final house =
                        await houseApi.getHouseByUID('aAngvoWd65IdkjcnlBPu');

                    print(
                        'House address : ${house.soNha} ${house.tenDuong}; Owner ID: ${house.chuNha.uid}');

                    house.dienTich = 100.5;
                    house.soPhongNgu = 3;
                    house.soPhongTam = 4;
                    await houseApi.updateHouse(updatedHouse: house);

                    print('House updated.');
                  } on FirebaseAuthException catch (e) {
                    switch (e.code) {
                      case 'invalid-email':
                        print('Email is not a valid email.');
                        break;
                      case 'user-disabled':
                        print(
                            'User associated with this email has been disabled.');
                        break;
                      case 'user-not-found':
                      case 'wrong-password':
                        print('Email or password is incorrect.');
                        break;
                    }
                  }
                },
                child: Text(
                  "Update house info",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  textStyle: TextStyle(fontSize: 20),
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
                  try {
                    await Auth.instance.register(
                        email: emailController.text,
                        password: passwordController.text);

                    print('Registered successfully.');
                  } on FirebaseAuthException catch (e) {
                    switch (e.code) {
                      case 'email-already-in-use':
                        print('Email already associated with an account');
                        break;
                      case 'invalid-email':
                        print('Email is not a valid email.');
                        break;
                      case 'weak-password':
                        print('Password not strong enough.');
                        break;
                    }
                  }
                },
                child: Text(
                  "Register",
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  textStyle: TextStyle(fontSize: 20),
                  elevation: 0,
                  minimumSize: Size(double.infinity, 20),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 20,
              ),
              TextButton(
                onPressed: () async {
                  await Auth.instance.signInWithGoogle();
                },
                child: Text(
                  "Sign in with Google",
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                  textStyle: TextStyle(fontSize: 20),
                  elevation: 0,
                  minimumSize: Size(double.infinity, 20),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: RichText(
                      text: TextSpan(
                        text: 'Reset password',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            try {
                              await Auth.instance.sendPasswordResetEmail(
                                  email: emailController.text);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => PasswordReset()));
                            } on FirebaseAuthException catch (e) {
                              switch (e.code) {
                                case 'auth/invalid-email':
                                  print('Email is not a valid email.');
                                  break;
                                case 'auth/user-not-found':
                                  print(
                                      'No user found associated with this email.');
                                  break;
                              }
                            }
                          },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: RichText(
                      text: TextSpan(
                        text: 'Send verfication email',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            await Auth.instance.sendUserEmailVerification();
                          },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordReset extends StatelessWidget {
  PasswordReset({Key key}) : super(key: key);

  final TextEditingController codeController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Code",
                  labelStyle: TextStyle(
                    fontSize: 20,
                  ),
                ),
                controller: codeController,
              ),
              SizedBox(
                width: double.infinity,
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "New password",
                  labelStyle: TextStyle(
                    fontSize: 20,
                  ),
                ),
                obscureText: true,
                controller: newPasswordController,
              ),
              SizedBox(
                width: double.infinity,
                height: 40,
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await Auth.instance.confirmPasswordReset(
                        code: codeController.text,
                        newPassword: newPasswordController.text);
                    Navigator.pop(context);
                  } on FirebaseAuthException catch (e) {
                    switch (e.code) {
                      case 'expired-action-code':
                        print('Action code expired.');
                        break;
                      case 'invalid-action-code':
                        print('Invalid action code.');
                        break;
                      case 'user-disabled':
                        print(
                            'User associated with this email has been disabled.');
                        break;
                      case 'weak-password':
                        print('Password is not strong enough.');
                        break;
                    }
                  }
                },
                child: Text(
                  "Reset password",
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  textStyle: TextStyle(fontSize: 20),
                  elevation: 0,
                  minimumSize: Size(double.infinity, 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
