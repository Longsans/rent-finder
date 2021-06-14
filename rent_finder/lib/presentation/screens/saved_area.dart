import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_finder/constants.dart';
import 'package:rent_finder/logic/bloc.dart';
import 'package:rent_finder/presentation/widgets/widgets.dart';

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
            return BlocBuilder<LikeBloc, LikeState>(
              builder: (context, state) {
                if (authState is AuthenticationStateSuccess) {
                  if (state.houses.isNotEmpty)
                    return ListView.builder(
                        itemCount: state.houses.length,
                        itemBuilder: (context, index) {
                          return HouseInfoBigCard(
                            house: state.houses[index],
                          );
                        });
                  else
                    return Center(
                      child: Text('Không có dữ liệu'),
                    );
                } else {
                  return Center(
                    child: Container(
                        width: 200,
                        child:
                            Text('Bạn cần đăng nhập để sử dụng chức năng này', textAlign: TextAlign.center,)),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
