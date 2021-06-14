import 'package:flutter/material.dart';
import 'screens.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Đăng ký",
          style: TextStyle(fontSize: 36.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: RegisterForm(),
    );
  }
}
