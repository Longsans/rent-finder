import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_finder/constants.dart';
import 'package:rent_finder/logic/like/like_bloc.dart';
import 'package:rent_finder/presentation/widgets/house_info_big_card.dart';

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
        child: BlocBuilder<LikeBloc, LikeState>(
          builder: (context, state) {
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
          },
        ),
      ),
    );
  }
}
