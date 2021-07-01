import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rent_finder_hi/constants.dart';
import 'package:rent_finder_hi/data/repos/repos.dart';
import 'package:rent_finder_hi/logic/bloc.dart';
import 'package:rent_finder_hi/presentation/screens/screens.dart';
import 'package:rent_finder_hi/presentation/widgets/widgets.dart';

class MyHousesScreen extends StatelessWidget {
  const MyHousesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyHousesBloc(),
      child: Builder(
        builder: (context) => Scaffold(
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
            centerTitle: true,
            title: Text(
              'Danh sách nhà đã đăng',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
          ),
          floatingActionButton:
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              return FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: primaryColor,
                onPressed: () {
                  if (state is AuthenticationStateAuthenticated) {
                    if (state.user.hoTen == null ||
                        state.user.sdt == null ||
                        state.user.hoTen == "" ||
                        state.user.sdt == "") {
                      var t = showDialog<bool>(
                        context: context,
                        builder: (context) => ConfirmDialog(
                            title:
                                'Bạn chưa cập nhật thông tin, chuyển đến phần cập nhật?'),
                      );
                      t.then(
                        (value) {
                          if (value != null) {
                            if (value) {
                              Navigator.of(context).pushNamed('/profile',
                                  arguments: [state.user]);
                            }
                          }
                        },
                      );
                      return;
                    }

                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (context) => PostFormBloc(),
                                  ),
                                  BlocProvider(
                                    create: (context) => PickMultiImageCubit(),
                                  ),
                                ],
                                child: PostHouseScreen(
                                  user: state.user,
                                ),
                              )),
                    );
                  }
                },
              );
            },
          ),
          body: Container(
            padding: EdgeInsets.all(defaultPadding),
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, authState) {
              if (authState is AuthenticationStateAuthenticated) {
                BlocProvider.of<MyHousesBloc>(context)
                    .add(LoadMyHouses(userUid: authState.user.uid));
                return BlocBuilder<MyHousesBloc, MyHousesState>(
                  builder: (context, state) {
                    if (state is MyHousesLoaded) {
                      if (state.houses.length > 0)
                        return ListView.builder(
                            itemCount: state.houses.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  HouseInfoSmallCard(
                                    size: MediaQuery.of(context).size,
                                    house: state.houses[index],
                                  ),
                                  BlocProvider(
                                    create: (context) => DetailHouseCubit(),
                                    child: Builder(
                                      builder: (context) => Align(
                                        child: BlocListener<DetailHouseCubit,
                                            DetailHouseState>(
                                          listener: (context, detailState) {
                                            if (detailState.status ==
                                                DetailStatus.success) {
                                              ScaffoldMessenger.of(context)
                                                  .hideCurrentSnackBar();
                                              Navigator.of(context).pushNamed(
                                                '/edit',
                                                arguments: [detailState.house],
                                              );
                                            } else if (detailState.status ==
                                                DetailStatus.loading) {
                                              ScaffoldMessenger.of(context)
                                                ..hideCurrentSnackBar()
                                                ..showSnackBar(
                                                  SnackBar(
                                                    duration:
                                                        Duration(minutes: 5),
                                                    content: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Text(" Đang tải..."),
                                                        CircularProgressIndicator(),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                            } else
                                              Fluttertoast.showToast(
                                                  msg: 'Đã có lỗi xảy ra');
                                          },
                                          child: PopupMenuButton(
                                              onSelected: (val) async {
                                                if (val == 'Gỡ') {
                                                  var t = showDialog<bool>(
                                                    context: context,
                                                    builder: (context) {
                                                      return ConfirmDialog(
                                                        title:
                                                            'Bạn có chắc chắn muốn gỡ nhà này không?',
                                                      );
                                                    },
                                                  );
                                                  t.then((value) async {
                                                    if (value != null) {
                                                      if (value) {
                                                        ScaffoldMessenger.of(
                                                            context)
                                                          ..hideCurrentSnackBar()
                                                          ..showSnackBar(
                                                            SnackBar(
                                                              content: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                      " Đang gỡ nhà..."),
                                                                  CircularProgressIndicator(),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        Future.delayed(Duration(
                                                            seconds: 3));
                                                        try {
                                                          await HouseRepository()
                                                              .setHouseRemoved(
                                                                  state
                                                                      .houses[
                                                                          index]
                                                                      .uid);
                                                          ScaffoldMessenger.of(
                                                              context)
                                                            ..hideCurrentSnackBar()
                                                            ..showSnackBar(
                                                              SnackBar(
                                                                content: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                        " Gỡ nhà thành công"),
                                                                    Icon(
                                                                      Icons
                                                                          .verified,
                                                                      color: Colors
                                                                          .green,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                        } catch (e) {
                                                          ScaffoldMessenger.of(
                                                              context)
                                                            ..hideCurrentSnackBar()
                                                            ..showSnackBar(
                                                              SnackBar(
                                                                content: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                        " Đã có lỗi xảy ra"),
                                                                    Icon(
                                                                      Icons
                                                                          .error,
                                                                      color: Colors
                                                                          .red,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                        }
                                                      } else
                                                        print('Hủy');
                                                    }
                                                  });
                                                } else {
                                                  BlocProvider.of<
                                                              DetailHouseCubit>(
                                                          context)
                                                      .click(
                                                          state.houses[index]);
                                                }
                                              },
                                              itemBuilder: (context) {
                                                return [
                                                  PopupMenuItem(
                                                    value: 'Gỡ',
                                                    child: Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Text('Gỡ'),
                                                          Icon(Icons.delete),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  PopupMenuItem(
                                                    value: 'Sửa',
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Text('Sửa'),
                                                        Icon(Icons.edit),
                                                      ],
                                                    ),
                                                  ),
                                                ];
                                              },
                                              icon: Icon(Icons.more_vert)),
                                        ),
                                        alignment: Alignment.topRight,
                                      ),
                                    ),
                                  )
                                ],
                              );
                            });
                      else
                        return Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                              ),
                              SvgPicture.asset('assets/images/no_data.svg'),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Không có dữ liệu',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textColor),
                              ),
                            ],
                          ),
                        );
                    } else
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                  },
                );
              } else {
                return Container();
              }
            }),
          ),
        ),
      ),
    );
  }
}
