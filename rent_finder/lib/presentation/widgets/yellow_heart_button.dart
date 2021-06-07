import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rent_finder/constants.dart';
import 'package:rent_finder/logic/heart/heart_bloc.dart';
import 'package:rent_finder/logic/like/like_bloc.dart';

class YellowHeartButton extends StatelessWidget {
  const YellowHeartButton({
    Key key,
    @required this.house,
    this.press,
  }) : super(key: key);

  final House house;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HeartBloc, HeartState>(
      builder: (context, state) {
        return BlocBuilder<LikeBloc, LikeState>(
          builder: (context, state1) {
            BlocProvider.of<HeartBloc>(context).add(HeartStarted(
                houses: BlocProvider.of<LikeBloc>(context).houses));
            return CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                onPressed: () {
                  BlocProvider.of<HeartBloc>(context).add(HeartPressed());
                  print(BlocProvider.of<LikeBloc>(context)
                      .houses
                      .length
                      .toString());
                  print(state);
                  if (state is HeartOutline)
                    BlocProvider.of<LikeBloc>(context)
                        .add(LikeAddPressed(house));
                  else if (state is HeartFill)
                    BlocProvider.of<LikeBloc>(context)
                        .add(LikeRemovePressed(house));
                  Fluttertoast.showToast(
                      msg: (state is HeartFill)
                          ? 'Xóa khỏi danh sách yêu thích thành công'
                          : 'Thêm vào danh sách yêu thích thành công');
                  press();
                },
                icon: SizedBox(
                  height: 20,
                  width: 20,
                  child: SvgPicture.asset(
                    state is HeartFill
                        ? 'assets/icons/heart_filled.svg'
                        : 'assets/icons/heart.svg',
                    color: Colors.yellowAccent,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
