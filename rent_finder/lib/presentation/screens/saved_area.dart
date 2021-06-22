import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                        itemCount: state.houses.length,
                        itemBuilder: (context, index) {
                          return HouseInfoBigCard(
                            house: state.houses[index],
                          );
                        });
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
                          Text('Không có dữ liệu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),),
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
                  Text('Không có dữ liệu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),),
                ],
              ),
            );
            
          }
        }),
      ),
    );
  }
}
