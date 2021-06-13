
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {

  final IconData icon;
  final String text;
  final String text2;

  CustomListTile({this.icon, this.text,this.text2});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,

        children: <Widget>[
          Icon(
            icon,
            color: Colors.blue,
          ),
          SizedBox(
            width: 15.0,
          ),
          Text(
            "$text",
            style: TextStyle(fontSize: 16.0),
          ),
          Expanded(
            child: Text("$text2",
                textAlign:TextAlign.right),
          )

        ],
      ),
    );
  }
}