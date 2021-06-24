import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_finder_hi/constants.dart';
import 'package:rent_finder_hi/logic/bloc.dart';
import 'package:rent_finder_hi/presentation/screens/faq_screen.dart';
import 'package:rent_finder_hi/presentation/widgets/Contact_sheet.dart';
import 'package:rent_finder_hi/presentation/widgets/widgets.dart';

import 'package:rent_finder_hi/data/models/models.dart' as models;

class UserArea extends StatelessWidget {
  UserArea();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                    (state is AuthenticationStateSuccess)
                        ? buildHeaderSuccess(state, context)
                        : HeaderUserFailure(),
                    SizedBox(
                      height: 20.0,
                    ),
                    (state is AuthenticationStateSuccess)
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
                    (state is AuthenticationStateSuccess)
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
                    (state is AuthenticationStateSuccess)
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
                          BlocProvider<ReportHouseBloc>(
                              create: (context) => ReportHouseBloc(),
                              child: BlocConsumer<ReportHouseBloc,
                                  ReportHouseState>(
                                listener: (context, state) {
                                  if (state is ReportHouseFail) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Đã có lỗi xảy ra: ${state.errorDescription}'),
                                      ),
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  return IconTextButton(
                                    title: 'Báo cáo lỗi ứng dụng',
                                    press: () {
                                      BlocProvider.of<ReportHouseBloc>(context)
                                          .add(ReportHouseEvent(
                                              reportedHouse: models.House()
                                                ..setUid('hdAiuoj942AycQAXPsXn')
                                                ..setSensitiveInfo(
                                                  false,
                                                  models.User(
                                                      uid:
                                                          'i3sdR1AGIqVZB8qPeZI8an6nnC42'),
                                                ),
                                              description: 'still testing...'));
                                    },
                                  );
                                },
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    if (state is AuthenticationStateSuccess == true)
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
      AuthenticationStateSuccess state, BuildContext context) {
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
