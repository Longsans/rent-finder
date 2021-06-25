import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rent_finder_hi/constants.dart';
import 'package:rent_finder_hi/data/models/models.dart';
import 'package:rent_finder_hi/logic/bloc.dart';
import 'package:rent_finder_hi/presentation/widgets/widgets.dart';
import 'package:rent_finder_hi/utils/format.dart';
import 'screens.dart';

class HomeArea extends StatelessWidget {
  const HomeArea({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton:
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          return FloatingActionButton(
            backgroundColor: primaryColor,
            child: Icon(Icons.add),
            onPressed: () {
              if (state is AuthenticationStateSuccess)
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
                    ),
                  ),
                );
              else
                Fluttertoast.showToast(
                    msg: 'Cần đnăg nhập để thực hiện chức năng này');
            },
          );
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWithSearchBox(size: size),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(
                  'Khám phá',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: EdgeInsets.all(defaultPadding),
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: defaultPadding / 2,
                  crossAxisSpacing: defaultPadding / 2,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    DistrictCard(
                      press: () {
                        BlocProvider.of<HouseBloc>(context)
                            .add(LoadHouses('Quận 1', null));
                        Navigator.pushNamed(context, '/result',
                            arguments: ['Quận 1', null]);
                      },
                      title: 'Quận 1',
                      svgSrc: 'assets/images/quan_1.jpg',
                    ),
                    DistrictCard(
                      press: () {
                        BlocProvider.of<HouseBloc>(context)
                            .add(LoadHouses('Quận 3', null));
                        Navigator.pushNamed(context, '/result',
                            arguments: ['Quận 3', null]);
                      },
                      title: 'Quận 3',
                      svgSrc: 'assets/images/quan_3.jpg',
                    ),
                    DistrictCard(
                      press: () {
                        BlocProvider.of<HouseBloc>(context)
                            .add(LoadHouses('Quận Bình Thạnh', null));
                        Navigator.pushNamed(context, '/result',
                            arguments: ['Quận Bình Thạnh', null]);
                      },
                      title: 'Bình Thạnh',
                      svgSrc: 'assets/images/binh_thanh.jpg',
                    ),
                    DistrictCard(
                      press: () {
                        BlocProvider.of<HouseBloc>(context)
                            .add(LoadHouses('Quận Thủ Đức', null));
                        Navigator.pushNamed(context, '/result',
                            arguments: ['Quận Thủ Đức', null]);
                      },
                      title: 'Thủ Đức',
                      svgSrc: 'assets/images/thu_duc.jpg',
                    ),
                    DistrictCard(
                      press: () {
                        BlocProvider.of<HouseBloc>(context)
                            .add(LoadHouses('Quận 10', null));
                        Navigator.pushNamed(context, '/result',
                            arguments: ['Quận 10', null]);
                      },
                      title: 'Quận 10',
                      svgSrc: 'assets/images/quan_10.jpg',
                    ),
                    DistrictCard(
                      press: () {
                        BlocProvider.of<HouseBloc>(context)
                            .add(LoadHouses('Quận 7', null));
                        Navigator.pushNamed(context, '/result',
                            arguments: ['Quận 7', null]);
                      },
                      title: 'Quận 7',
                      svgSrc: 'assets/images/quan_7.jpg',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mới đăng gần đây',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(primaryColor),
                      ),
                      onPressed: () {
                        BlocProvider.of<HouseBloc>(context).add(LoadHouses(null, null));
                        Navigator.of(context)
                            .pushNamed('/result', arguments: [null, null]);
                      },
                      child: Text(
                        "Thêm",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: defaultPadding / 2,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                height: 250,
                child: BlocBuilder<NewestHouseCubit, NewestHouseState>(
                  builder: (context, state) {
                    if (state.status == Status.success)
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return HouseMediumCard(
                              size: size, house: state.houses[index]);
                        },
                        itemCount: state.houses.length,
                      );
                    else
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                  },
                ),
              ),
              SizedBox(
                height: defaultPadding / 2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(
                  'Tin tức',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HouseMediumCard extends StatelessWidget {
  const HouseMediumCard({
    Key key,
    this.size,
    this.house,
  }) : super(key: key);

  final Size size;
  final House house;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        
        Navigator.of(context).pushNamed('/detail', arguments: [house]);
      },
      child: Container(
        width: size.width * 0.8,
        margin: EdgeInsets.only(right: defaultPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black26),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: house.urlHinhAnh[0] ?? '',
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error_outline,
                      size: 100,
                      color: Colors.red,
                    ),
                  ),
                  flex: 6,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Text(
                          Format.toMoneyPerMonth(house.tienThueThang),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: textColor),
                          maxLines: 1,
                        ),
                        Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: SvgPicture.asset('assets/icons/bed.svg',
                                  color: primaryColor),
                            ),
                            Text(house.soPhongNgu.toString()),
                          ],
                        ),
                        SizedBox(
                          width: defaultPadding,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: SvgPicture.asset(
                                  'assets/icons/bathtub.svg',
                                  color: primaryColor),
                            ),
                            Text(house.soPhongTam.toString()),
                          ],
                        ),
                        SizedBox(
                          width: defaultPadding,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: SvgPicture.asset('assets/icons/area.svg',
                                  color: primaryColor),
                            ),
                            Text(house.dienTich.toStringAsFixed(0)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.black26)),
                    ),
                    child: Center(
                      child: Text(
                        house.diaChi,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: textColor),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                  flex: 2,
                ),
              ],
            ),
            Positioned(
              left: 8,
              top: 8,
              child: Container(
                padding: EdgeInsets.all(defaultPadding / 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: textColor,
                ),
                child: Text(
                  house.loaiChoThue == LoaiChoThue.CanHo
                      ? 'Căn hộ'
                      : house.loaiChoThue == LoaiChoThue.Nha
                          ? 'Nhà'
                          : 'Phòng',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DistrictCard extends StatelessWidget {
  const DistrictCard({
    Key key,
    this.title,
    this.svgSrc,
    this.press,
  }) : super(key: key);
  final String title;
  final String svgSrc;
  final Function press;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image:
                  DecorationImage(image: AssetImage(svgSrc), fit: BoxFit.cover),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: defaultPadding / 2),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                )),
          ),
        ],
      ),
    );
  }
}

class HeaderWithSearchBox extends StatelessWidget {
  const HeaderWithSearchBox({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: defaultPadding * 2.5),
      height: size.height * 0.25,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: defaultPadding,
              right: defaultPadding,
              bottom: 36 + defaultPadding,
            ),
            height: size.height * 0.25 - 27,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SearchBarHome(),
          )
        ],
      ),
    );
  }
}

class SearchBarHome extends StatelessWidget {
  const SearchBarHome({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var t = showModalBottomSheet<List<String>>(
            context: context,
            builder: (context) {
              return LocationBottomSheet();
            });
        t.then((value) {
          if (value != null) {
            BlocProvider.of<HouseBloc>(context)
                .add(LoadHouses(value[0], value[1]));
            Navigator.pushNamed(context, '/result',
                arguments: [value[0], value[1]]);
          }
        });
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: defaultPadding),
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        height: 54,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 50,
              color: primaryColor.withOpacity(0.23),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                enabled: false,
                onChanged: (value) {},
                decoration: InputDecoration(
                  hintText: "Tìm kiếm",
                  hintStyle: TextStyle(
                    color: primaryColor.withOpacity(0.5),
                  ),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  // surffix isn't working properly  with SVG
                  // thats why we use row
                  // suffixIcon: SvgPicture.asset("assets/icons/search.svg"),
                ),
              ),
            ),
            SvgPicture.asset("assets/icons/search.svg"),
          ],
        ),
      ),
    );
  }
}
