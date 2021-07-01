import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../constants.dart';
import 'background.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String _email;
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(EvaIcons.arrowheadLeft, color: Colors.black),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(10),
                  primary: Colors.white, // <-- Button color
                  onPrimary: Colors.red, // <-- Splash color
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Cấp lại mật khẩu",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontSize: 36
                ),
                textAlign: TextAlign.left,
              ),
            ),

            SizedBox(height: size.height * 0.05),

            Container(
              margin: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: TextFormField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,

                decoration: InputDecoration(
                  hintText: "Vui lòng nhập email * ",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.bold, letterSpacing: 1.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        width: 1,
                        style: BorderStyle.solid,
                        color: Colors.blue),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        width: 1,
                        style: BorderStyle.solid,
                        color: Colors.grey),
                  ),
                ),
                validator: (_) {
                  return  _email.isEmpty ? "Vui lòng nhập email" : null;
                },
                onChanged: (value) {
                  setState(() {
                    _email = value.trim();
                  });
                },

              ),
            ),
            SizedBox(height: size.height * 0.03),

            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: RaisedButton(
                onPressed: () async {
                  try{
                    await auth.sendPasswordResetEmail(email: _email);
                    print('thành công');
                    ScaffoldMessenger.of(context)
                      ..showSnackBar(
                        SnackBar(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Yêu cầu đã được gửi tới email của bạn"),
                              Icon(Icons.assignment_turned_in_outlined,
                                color: Colors.white,),
                            ],
                          ),
                        ),
                      );
                  }on FirebaseAuthException
                  catch(e){
                    if (e.code == 'user-not-found') {
                      print( 'Địa chỉ email không tồn tại');
                      ScaffoldMessenger.of(context)
                        ..showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Địa chỉ email không tồn tại",style: TextStyle(color: Colors.black),),
                                Icon(Icons.error,
                                  color: Colors.white,),
                              ],
                            ),
                          ),
                        );
                    }
                    if (e.code == 'invalid-email') {
                      print( 'Địa chỉ email không hợp lệ');
                      ScaffoldMessenger.of(context)
                        ..showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Địa chỉ email không hợp lệ",style: TextStyle(color: Colors.black),),
                                Icon(Icons.error, color: Colors.white,),
                              ],
                            ),
                          ),
                        );
                    }

                  }
                  // Navigator.of(context).pop();
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                textColor: Colors.white,
                padding: const EdgeInsets.all(0),
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  width: size.width * 0.5,
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(80.0),
                      gradient: new LinearGradient(
                          colors: [
                            Color.fromARGB(255, 255, 136, 34),
                            Color.fromARGB(255, 255, 177, 41)
                          ]
                      )
                  ),
                  padding: const EdgeInsets.all(0),
                  child: Text(
                    "Gửi yêu cầu",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}