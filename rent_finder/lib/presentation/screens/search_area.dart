import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rent_finder/constants.dart';
import 'package:rent_finder/logic/category/category_bloc.dart';
import 'package:rent_finder/logic/heart/heart_bloc.dart';
import 'package:rent_finder/logic/like/like_bloc.dart';
import 'package:rent_finder/presentation/widgets/filter_basic_dialog.dart';
import 'package:rent_finder/presentation/widgets/header_search_screen.dart';
import 'package:rent_finder/presentation/widgets/search_bar.dart';

class SearchArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderSearchScreen(size: size),
              SizedBox(height: defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SearchBar(
                      hintText: "Tìm theo khu vực hoặc địa chỉ",
                      press: () {
                        BlocProvider.of<CategoryBloc>(context)..queries = [];
                         Navigator.pushNamed(context, '/result');
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: defaultPadding),
              Text(
                'Đã xem gần đây',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: defaultPadding),
              Expanded(
                child: ListView.builder(
                  itemCount: houses.length,
                  itemBuilder: (context, index) {
                    return RecentHomeListTile(
                      size: size,
                      house: houses[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecentHomeListTile extends StatelessWidget {
  const RecentHomeListTile({
    Key key,
    @required this.size,
    this.house,
  }) : super(key: key);

  final Size size;
  final House house;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HeartBloc>(
      create: (context) => HeartBloc(house),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/detail',
                  arguments: [house]);
            },
            child: Container(
              margin: EdgeInsets.only(bottom: defaultPadding / 2),
              padding: EdgeInsets.all(defaultPadding * 0.75),
              width: double.infinity,
              height: size.height * 0.15,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(19),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(house.imgSrc),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: defaultPadding / 2,
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          house.price,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff318E99),
                          ),
                        ),
                        SizedBox(
                          height: defaultPadding / 2,
                        ),
                        Text(
                          house.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xffB3B3B3),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/icons/bed.svg',
                                    width: 25,
                                    height: 25,
                                  ),
                                  SizedBox(
                                    width: defaultPadding / 2,
                                  ),
                                  Text('${house.numOfBed}'),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/icons/bathtub.svg',
                                    width: 25,
                                    height: 25,
                                  ),
                                  SizedBox(
                                    width: defaultPadding / 2,
                                  ),
                                  Text('${house.numOfBath}'),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/icons/area.svg',
                                    width: 25,
                                    height: 25,
                                  ),
                                  SizedBox(
                                    width: defaultPadding / 2,
                                  ),
                                  Text('${house.area}'),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
          BlocBuilder<HeartBloc, HeartState>(
            builder: (context, state) {
              return BlocBuilder<LikeBloc, LikeState>(
                builder: (context, state1) {
                  BlocProvider.of<HeartBloc>(context).add(HeartStarted(
                      houses: BlocProvider.of<LikeBloc>(context).houses));
                  return GestureDetector(
                    onTap: () {
                      BlocProvider.of<HeartBloc>(context).add(HeartPressed());
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
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.all(defaultPadding * 0.75),
                        child: SvgPicture.asset(
                          (state is HeartFill)
                              ? 'assets/icons/heart_filled.svg'
                              : 'assets/icons/heart.svg',
                          height: 25,
                          width: 25,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

