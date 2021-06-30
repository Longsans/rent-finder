import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rent_finder_hi/data/models/models.dart' as model;
import 'package:rent_finder_hi/logic/bloc.dart';

import '../../constants.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({
    Key key,
    @required this.house,
  }) : super(key: key);

  final model.House house;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, authState) {
        return BlocBuilder<SavedHouseBloc, SavedHouseState>(
          builder: (context, state) {
            if (authState is AuthenticationStateSuccess)
              return GestureDetector(
                onTap: () {
                  if (state is SavedHouseLoaded) {
                    if (state.houses
                        .map((e) => e.uid)
                        .toList()
                        .contains(house.uid)) {
                      BlocProvider.of<SavedHouseBloc>(context).add(
                          RemoveSavedHouse(user: authState.user, house: house));
                      Fluttertoast.showToast(
                          msg: 'Đã xóa khỏi danh sách yêu thích');
                    } else {
                      BlocProvider.of<SavedHouseBloc>(context)
                          .add(AddToSaved(user: authState.user, house: house));
                      Fluttertoast.showToast(
                          msg: 'Đã thêm vào danh sách yêu thích');
                    }
                  }
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                      padding: const EdgeInsets.all(defaultPadding * 0.75),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: (state is SavedHouseLoaded)
                            ? SvgPicture.asset(
                                (state.houses
                                        .map((e) => e.uid)
                                        .toList()
                                        .contains(house.uid))
                                    ? 'assets/icons/heart_filled.svg'
                                    : 'assets/icons/heart.svg',
                                height: 20,
                                width: 20,
                                color: Color(0xFF0D4880),
                              )
                            : Container(),
                      )),
                ),
              );
            else
              return Container();
          },
        );
      },
    );
  }
}
