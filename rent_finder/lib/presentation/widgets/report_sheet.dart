import 'package:flutter/material.dart';
class MyChoice {
  String choice;
  int index;
  MyChoice({this.index,this.choice});
}
class ReportSheet extends StatefulWidget {
  ReportSheet({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ReportSheetState createState() => _ReportSheetState();
}

class _ReportSheetState extends State<ReportSheet> {
  final TextEditingController _errorController = TextEditingController();
  bool _enable=false;
  String default_choice="COD";
  int default_index = 0;

  List<MyChoice> choices=[
    MyChoice(index: 0,choice: "Tài khoản giả mạo"),
    MyChoice(index: 1,choice: "Đăng thông tin sai sự thật"),
    MyChoice(index: 2,choice: "Lừa đảo"),
    MyChoice(index: 3,choice: "Hình ảnh phản cảm"),
    MyChoice(index: 4,choice: "Khác..."),
  ];
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)
      ),
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            height: 410,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0 , 10, 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: choices.map((data) => RadioListTile(
                  activeColor: Colors.blue,
                  selectedTileColor: Colors.red,
                  dense: true,
                  title: Text('${data.choice}',style: TextStyle(color: Colors.grey),),
                  groupValue: default_index,
                  value: data.index,
                  onChanged: (value){
                    setState(() {
                      default_choice=data.choice;
                      default_index=data.index;
                      if(default_index==4){
                        _enable=true;
                      }
                      else{
                        _enable=false;
                        _errorController.text="";
                      }
                    });
                  },
                )).toList(),

              ),
            ),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(50, 0, 30, 55),
            child: TextFormField(
              enabled: _enable ,
              style: TextStyle(fontSize: 13),
              controller: _errorController,
              decoration: InputDecoration(
                icon: Icon(Icons.email),
                labelText: "Vi phạm khác...",
              ),
              keyboardType: TextInputType.emailAddress,
              autovalidate: true,
              autocorrect: false,),
          ),
          Positioned(
              bottom: 0,
              child:
              RaisedButton(onPressed: () {
                Navigator.of(context).pop();
              },
                color: Colors.blue,
                child: Text('Gửi vi phạm', style: TextStyle(color: Colors.white),),
              )
          ),
          Positioned(
            top: 30,
            child:  Text("Báo cáo vi phạm",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
          ),
          Positioned(
              top: -100,
              child: CircleAvatar(
                backgroundColor: Colors.red,
                radius: 60,
                backgroundImage: AssetImage('assets/images/giphy.gif'),
              )
          ),
        ],
      ),
    );
  }
}