import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rent_finder_hi/logic/bloc.dart';
import 'package:rent_finder_hi/presentation/screens/home_area.dart';
import '../../constants.dart';
import 'screens.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocBuilder<NavigationBarBloc, NavigationBarState>(
          builder: (context, state) {
        return BottomNavigationBar(
          unselectedItemColor: Colors.black87,
          selectedItemColor: textColor,
          currentIndex: state.index,
          onTap: (index) {
            BlocProvider.of<NavigationBarBloc>(context)
                .add(NavigationBarItemSelected(index: index));
          },
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                state.index != 0 ? 'assets/icons/home.svg' : 'assets/icons/home_filled.svg',
                width: 21,
                height: 21,
                color: state.index != 0 ? Colors.black87 :textColor,
              ),
              label: 'Trang Chính',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                state.index != 1 ? 'assets/icons/search.svg' : 'assets/icons/search_filled.svg',
                width: 21,
                height: 21,
                color: state.index != 1 ? Colors.black87 : textColor,
              ),
              label: 'Tìm kiếm',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                state.index != 2 ? 'assets/icons/heart.svg' : 'assets/icons/heart_filled.svg',
                width: 21,
                height: 21,
                color: state.index != 2 ? Colors.black87 : textColor,
              ),
              label: 'Đã lưu',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                state.index != 3 ? 'assets/icons/user.svg' : 'assets/icons/user_filled.svg',
                width: 21,
                height: 21,
                color: state.index != 3 ? Colors.black87 : textColor,
              ),
              label: 'Tài khoản',
            )
          ],
        );
      }),
      body: BlocBuilder<NavigationBarBloc, NavigationBarState>(
        builder: (context, state) {
          return IndexedStack(
            children: [
              HomeArea(),
              SearchArea(),
              SavedArea(),
              UserArea(),
            ],
            index: state.index,
          );
        },
      ),
    );
  }
}
