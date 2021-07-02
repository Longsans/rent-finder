import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rent_finder_hi/logic/report_house_bloc/report_house_bloc.dart';
import 'package:rent_finder_hi/data/models/models.dart' as model;
import 'package:rent_finder_hi/constants.dart';

class MyChoice {
  String choice;
  int index;
  MyChoice({this.index, this.choice});
}

class ReportSheet extends StatefulWidget {
  ReportSheet({Key key, this.house1}) : super(key: key);
  model.House house1;

  @override
  _ReportSheetState createState() => _ReportSheetState();
}

class _ReportSheetState extends State<ReportSheet> {
  final TextEditingController _errorController = TextEditingController();
  bool _enable = false;
  String default_choice = "COD";
  int default_index = 0;
  List<MyChoice> choices = [
    MyChoice(index: 0, choice: "Tài khoản giả mạo"),
    MyChoice(index: 1, choice: "Đăng thông tin sai sự thật"),
    MyChoice(index: 2, choice: "Lừa đảo"),
    MyChoice(index: 3, choice: "Hình ảnh phản cảm"),
    MyChoice(index: 4, choice: "Khác..."),
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            height: 410,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: choices
                    .map((data) => RadioListTile(
                          activeColor: textColor,
                          selectedTileColor: Colors.red,
                          dense: true,
                          title: Text(
                            '${data.choice}',
                            style: TextStyle(color: Colors.grey),
                          ),
                          groupValue: default_index,
                          value: data.index,
                          onChanged: (value) {
                            setState(() {
                              default_choice = data.choice;
                              default_index = data.index;
                              if (default_index == 4) {
                                _enable = true;
                                default_choice = "";
                              } else {
                                _enable = false;
                                _errorController.text = "";
                              }
                            });
                          },
                        ))
                    .toList(),
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(50, 0, 30, 55),
            child: TextFormField(
              enabled: _enable,
              style: TextStyle(fontSize: 13),
              controller: _errorController,
              decoration: InputDecoration(
                icon: Icon(Icons.email),
                labelText: "Vi phạm khác...",
              ),
              keyboardType: TextInputType.emailAddress,
              autovalidate: true,
              autocorrect: false,
            ),
          ),
          Positioned(
            bottom: 0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  elevation: 0.1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6))),
              child: Text(
                'Báo cáo',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () async {
                final result = await showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (buildContext) {
                    if (default_choice == "") {
                      default_choice = _errorController.text;
                    }

                    return ReportIssueBottomSheet(
                      controller1: default_choice,
                      house2: widget.house1,
                    );
                  },
                );

                if (result is ReportHouseSuccess) {
                  ScaffoldMessenger.of(context)
                    ..showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Text(
                                'Báo cáo đã được gửi, cảm ơn đóng góp của bạn!'),
                            Spacer(),
                            Icon(Icons.check_circle, color: Colors.green),
                          ],
                        ),
                      ),
                    );
                } else if (result is ReportHouseFail) {
                  ScaffoldMessenger.of(context)
                    ..showSnackBar(
                      SnackBar(
                        content: Row(
                          children: <Widget>[
                            Text('Đã có lỗi xảy ra'),
                            Spacer(),
                            Icon(Icons.error, color: Colors.red),
                          ],
                        ),
                      ),
                    );
                }
              },
            ),
          ),
          Positioned(
            top: 30,
            child: Text(
              "Báo cáo vi phạm",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Positioned(
              top: -100,
              child: CircleAvatar(
                backgroundColor: Colors.red,
                radius: 60,
                backgroundImage: AssetImage('assets/images/giphy.gif'),
              )),
        ],
      ),
    );
  }
}

class ReportIssueBottomSheet extends StatefulWidget {
  final String controller1;
  final model.House house2;

  ReportIssueBottomSheet({Key key, this.controller1, this.house2})
      : super(key: key);

  @override
  _ReportIssueBottomSheetState createState() => _ReportIssueBottomSheetState();
}

class _ReportIssueBottomSheetState extends State<ReportIssueBottomSheet> {
  bool invalid;

  @override
  void initState() {
    invalid = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.black12,
            spreadRadius: 5,
          )
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
            BlocProvider<ReportHouseBloc>(
              create: (context) => ReportHouseBloc(),
              child: BlocConsumer<ReportHouseBloc, ReportHouseState>(
                listener: (context, state) {
                  if (state is ReportHouseSuccess || state is ReportHouseFail)
                    Navigator.of(context).pop(state);
                },
                builder: (context, state) {
                  if (state is ReportHouseSending) {
                    return SendReportIssueButton(
                      onPressed: null,
                      color: Colors.blue[600],
                      secondaryWidget: CircularProgressIndicator.adaptive(
                        value: null,
                        backgroundColor: Colors.white,
                      ),
                    );
                  }
                  if (state is ReportHouseSuccess) {
                    Fluttertoast.showToast(msg: 'Đã được gửi thành công');
                    return SendReportIssueButton(
                      onPressed: null,
                      color: Colors.green,
                      secondaryWidget: Icon(Icons.check, color: Colors.white),
                    );
                  }
                  if (state is ReportHouseFail) {
                    Fluttertoast.showToast(msg: 'Gửi vi phạm thất bại');
                    return SendReportIssueButton(
                      onPressed: null,
                      color: Colors.red,
                      secondaryWidget: Icon(Icons.error, color: Colors.white),
                    );
                  } else
                    return SendReportIssueButton(
                      onPressed: () {
                        if (widget.controller1.length == 0) {
                          Fluttertoast.showToast(
                              msg:
                                  'Thất bại, vui lòng điền đủ thông tin vào vi phạm khác');

                          setState(() {
                            invalid = true;
                          });
                          return SendReportIssueButton(
                            onPressed: null,
                            color: Colors.red,
                            secondaryWidget:
                                Icon(Icons.error, color: Colors.white),
                          );
                        }
                        setState(() {
                          invalid = false;
                        });
                        BlocProvider.of<ReportHouseBloc>(context).add(
                            ReportHouseEvent(
                                description: widget.controller1,
                                reportedHouse: widget.house2));
                      },
                      color: Colors.blue,
                    );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SendReportIssueButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget secondaryWidget;
  final Color color;

  SendReportIssueButton(
      {Key key, this.onPressed, this.secondaryWidget, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: TextButton(
        onPressed: onPressed,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                'Xác nhận',
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            if (secondaryWidget != null)
              Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    alignment: Alignment.center,
                    height: 17,
                    width: 17,
                    margin: EdgeInsets.fromLTRB(0, 2, 5, 0),
                    child: secondaryWidget,
                  )),
          ],
        ),
        style: TextButton.styleFrom(
          backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
