import 'package:flutter/material.dart';
import 'screens.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Đăng ký',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: RegisterForm(),
    );
  }
}
