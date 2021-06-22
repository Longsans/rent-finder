import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rent_finder_hi/constants.dart';
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
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: primaryColor,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) {
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => PostFormBloc(),
                          ),
                          BlocProvider(
                            create: (context) => PickMultiImageCubit(),
                          ),
                        ],
                        child: PostHouseScreen(
                          user: (state as AuthenticationStateSuccess).user,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          body: Container(
            padding: EdgeInsets.all(defaultPadding),
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, authState) {
              if (authState is AuthenticationStateSuccess) {
                BlocProvider.of<MyHousesBloc>(context)
                    .add(LoadMyHouses(userUid: authState.user.uid));
                return BlocBuilder<MyHousesBloc, MyHousesState>(
                  builder: (context, state) {
                    if (state is MyHousesLoaded) {
                      if (state.houses.length > 0)
                        return ListView.builder(
                            itemCount: state.houses.length,
                            itemBuilder: (context, index) {
                              return HouseInfoSmallCard(
                                size: MediaQuery.of(context).size,
                                house: state.houses[index],
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
                              Text('Không có dữ liệu'),
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
