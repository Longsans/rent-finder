import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_finder_hi/constants.dart';
import 'package:rent_finder_hi/logic/bloc.dart';
import 'package:rent_finder_hi/presentation/screens/faq_screen.dart';
import 'package:rent_finder_hi/presentation/widgets/Contact_sheet.dart';
import 'package:rent_finder_hi/presentation/widgets/widgets.dart';

import '../../constants.dart';
import '../../logic/bloc.dart';

class UserArea extends StatelessWidget {
  UserArea();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Tài khoản',
            style: Theme.of(context).textTheme.headline6,
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20),
                    (state is AuthenticationStateAuthenticated)
                        ? buildHeaderSuccess(state, context)
                        : HeaderUserFailure(),
                    SizedBox(
                      height: 20.0,
                    ),
                    (state is AuthenticationStateAuthenticated)
                        ? TitleCard(
                            subtitle:
                                'Quản lý các thông tin cá nhân dễ dàng hơn',
                            title: 'Cá nhân',
                            icon: Icon(
                              Icons.account_circle_rounded,
                              color: Colors.white,
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 20,
                    ),
                    (state is AuthenticationStateAuthenticated)
                        ? Container(
                            padding: EdgeInsets.all(defaultPadding / 2),
                            decoration: BoxDecoration(
                              color: Color(0xffF2F5FA),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                IconTextButton(
                                    press: () {
                                      Navigator.of(context)
                                          .pushNamed('/my_houses');
                                    },
                                    title: 'Danh sách nhà đã đăng'),
                                Divider(
                                  thickness: 1,
                                ),
                                IconTextButton(
                                  press: () {
                                    BlocProvider.of<NavigationBarBloc>(context)
                                        .add(NavigationBarItemSelected(
                                            index: 2));
                                  },
                                  title: 'Danh sách nhà đã lưu',
                                )
                              ],
                            ),
                          )
                        : Container(),
                    (state is AuthenticationStateAuthenticated)
                        ? Container()
                        : CustomButton(
                            title: 'Đăng nhập',
                            icon: Icon(
                              Icons.login,
                              color: Colors.white,
                            ),
                            press: () {
                              Navigator.of(context)
                                  .pushReplacementNamed('/login');
                            },
                          ),
                    SizedBox(
                      height: 40,
                    ),
                    TitleCard(
                      subtitle: 'Gửi câu hỏi và phản hồi của bạn',
                      title: 'Trợ giúp và Phản hồi',
                      icon: Icon(
                        Icons.mail_outline,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(defaultPadding / 2),
                      decoration: BoxDecoration(
                        color: Color(0xffF2F5FA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          IconTextButton(
                            title: 'FAQ ',
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FAQPage()),
                              );
                            },
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          IconTextButton(
                              title: 'Liên hệ',
                              press: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AdvanceCustomAlert();
                                    });
                              }),
                          Divider(
                            thickness: 1,
                          ),
                          IconTextButton(
                            title: 'Báo cáo lỗi ứng dụng',
                            press: () async {
                              final controller = TextEditingController();
                              final result = await showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (buildContext) {
                                  return ReportIssueBottomSheet(
                                    controller: controller,
                                  );
                                },
                              );

                              if (result is ReportIssueSuccess) {
                                ScaffoldMessenger.of(context)
                                  ..showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          Text(
                                              'Báo cáo đã được gửi, cảm ơn đóng góp của bạn!'),
                                          Spacer(),
                                          Icon(Icons.check_circle,
                                              color: Colors.green),
                                        ],
                                      ),
                                    ),
                                  );
                              } else if (result is ReportIssueFail) {
                                ScaffoldMessenger.of(context)
                                  ..showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: <Widget>[
                                          Text(
                                              'Đã có lỗi xảy ra: \'${result.errorDescription}\''),
                                          Spacer(),
                                          Icon(Icons.error, color: Colors.red),
                                        ],
                                      ),
                                    ),
                                  );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    if (state is AuthenticationStateAuthenticated)
                      CustomButton(
                        title: 'Đăng xuất',
                        icon: Icon(Icons.logout, color: Colors.white),
                        press: () {
                          BlocProvider.of<AuthenticationBloc>(context)
                              .add(AuthenticationEventLoggedOut());
                        },
                      )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Container buildHeaderSuccess(
      AuthenticationStateAuthenticated state, BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: state.user.urlHinhDaiDien ?? "",
            imageBuilder: (context, imageProvider) => Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(
              Icons.account_circle_outlined,
              size: 200,
              color: Color(0xFF0D4880),
            ),
          ),
          SizedBox(
            height: defaultPadding / 2,
          ),
          Text(
            (state.user != null)
                ? state.user.hoTen ?? "Chưa đặt tên"
                : "Chưa đặt tên",
            style: Theme.of(context).textTheme.headline5,
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed('/profile', arguments: [state.user]);
            },
            label: Text(
              'Chỉnh sửa thông tin',
              style: Theme.of(context).textTheme.caption.copyWith(fontSize: 14),
            ),
            icon: Icon(Icons.edit, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class ReportIssueBottomSheet extends StatefulWidget {
  final TextEditingController controller;

  ReportIssueBottomSheet({Key key, this.controller}) : super(key: key);

  @override
  _ReportIssueBottomSheetState createState() => _ReportIssueBottomSheetState();
}

class _ReportIssueBottomSheetState extends State<ReportIssueBottomSheet> {
  final String errorText = 'Hãy miêu tả lỗi bạn gặp phải trước';
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
            DecoratedTextField(
              controller: widget.controller,
              hintText: 'Mô tả vấn đề bạn gặp phải',
              errorText: invalid ? errorText : null,
            ),
            SizedBox(height: 10),
            BlocProvider<ReportIssueBloc>(
              create: (context) => ReportIssueBloc(),
              child: BlocConsumer<ReportIssueBloc, ReportIssueState>(
                listener: (context, state) {
                  if (state is ReportIssueSuccess || state is ReportIssueFail)
                    Navigator.of(context).pop(state);
                },
                builder: (context, state) {
                  if (state is ReportIssueSending) {
                    return SendReportIssueButton(
                      onPressed: null,
                      color: Colors.blue[600],
                      secondaryWidget: CircularProgressIndicator.adaptive(
                        value: null,
                        backgroundColor: Colors.white,
                      ),
                    );
                  }
                  if (state is ReportIssueSuccess) {
                    return SendReportIssueButton(
                      onPressed: null,
                      color: Colors.green,
                      secondaryWidget: Icon(Icons.check, color: Colors.white),
                    );
                  }
                  if (state is ReportIssueFail) {
                    return SendReportIssueButton(
                      onPressed: null,
                      color: Colors.red,
                      secondaryWidget: Icon(Icons.error, color: Colors.white),
                    );
                  } else
                    return SendReportIssueButton(
                      onPressed: () {
                        if (widget.controller.text.length == 0) {
                          setState(() {
                            invalid = true;
                          });
                          return;
                        }
                        setState(() {
                          invalid = false;
                        });
                        BlocProvider.of<ReportIssueBloc>(context).add(
                            ReportIssueEvent(
                                issueDescription: widget.controller.text));
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
                'Gửi',
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

class IconTextButton extends StatelessWidget {
  const IconTextButton({
    Key key,
    this.press,
    this.title,
  }) : super(key: key);
  final Function press;
  final String title;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: press,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          Icon(
            Icons.keyboard_arrow_right,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}

class TitleCard extends StatelessWidget {
  const TitleCard({
    Key key,
    this.title,
    this.subtitle,
    this.icon,
  }) : super(key: key);
  final String title;
  final String subtitle;
  final Icon icon;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.lightBlue),
          child: icon,
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              subtitle,
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }
}
