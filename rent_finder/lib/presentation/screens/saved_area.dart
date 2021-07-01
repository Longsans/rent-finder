import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rent_finder_hi/constants.dart';
import 'package:rent_finder_hi/logic/bloc.dart';
import 'package:rent_finder_hi/presentation/widgets/widgets.dart';

class SavedArea extends StatelessWidget {
  SavedArea({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Yêu Thích',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(defaultPadding),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, authState) {
          if (authState is AuthenticationStateSuccess) {
            BlocProvider.of<SavedHouseBloc>(context)
                .add(LoadSavedHouses(userUid: authState.user.uid));
            return BlocBuilder<SavedHouseBloc, SavedHouseState>(
              builder: (context, state) {
                if (state is SavedHouseLoaded) {
                  if (state.houses.length > 0)
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return BlocProvider(
                          create: (context) => DetailHouseCubit(),
                          child: BlocBuilder<RecentViewBloc, RecentViewState>(
                            builder: (context, recentState) {
                              return BlocListener<DetailHouseCubit,
                                  DetailHouseState>(
                                listener: (context, detailState) {
                                  if (detailState.status ==
                                      DetailStatus.success) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    if (detailState.house.daGO == true) {
                                      var t = showDialog(
                                        context: context,
                                        builder: (_) => ConfirmDialog(
                                          title:
                                              'Bài đăng này đã bị gỡ, bạn có muốn xóa khỏi danh sách không?',
                                        ),
                                      );
                                      t.then(
                                        (value) {
                                          if (value != null) {
                                            if (value) {
                                              BlocProvider.of<SavedHouseBloc>(
                                                      context)
                                                  .add(RemoveSavedHouse(
                                                      user: authState.user,
                                                      house:
                                                          state.houses[index]));
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Đã xóa khỏi danh sách yêu thích');
                                            }
                                          }
                                        },
                                      );
                                    } else if (detailState.house.dangCapNhat) {
                                      Fluttertoast.showToast(
                                          msg:
                                              'Nhà đang được cập nhật, hãy thử lại sau một lát!');
                                    } else {
                                      if (recentState is RecentViewLoaded &&
                                          authState
                                              is AuthenticationStateSuccess) {
                                        if (recentState.houses
                                            .map((e) => e.uid)
                                            .toList()
                                            .contains(
                                                state.houses[index].uid)) {
                                          BlocProvider.of<RecentViewBloc>(
                                                  context)
                                              .add(
                                            RemoveViewedHouse(
                                              user: authState.user,
                                              house: state.houses[index],
                                            ),
                                          );
                                        }
                                        BlocProvider.of<RecentViewBloc>(context)
                                            .add(
                                          AddToViewed(
                                            user: authState.user,
                                            house: state.houses[index],
                                          ),
                                        );
                                      }
                                      Navigator.of(context).pushNamed('/detail',
                                          arguments: [detailState.house]);
                                    }
                                  } else if (detailState.status ==
                                      DetailStatus.loading) {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                child: Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        BlocProvider.of<DetailHouseCubit>(
                                                context)
                                            .click(state.houses[index]);
                                      },
                                      child: HouseInfoBigCard(
                                          house: state.houses[index]),
                                    ),
                                    SaveButton(house: state.houses[index])
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                      itemCount: state.houses.length,
                    );
                  else
                    return Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.15,
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
            return Center(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
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
          }
        }),
      ),
    );
  }
}
