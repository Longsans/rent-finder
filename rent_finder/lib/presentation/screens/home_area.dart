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
import 'package:url_launcher/url_launcher.dart';
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
              if (state is AuthenticationStateAuthenticated) {
                if (state.user.hoTen == null ||
                    state.user.sdt == null ||
                    state.user.hoTen == "" ||
                    state.user.sdt == "") {
                  var t = showDialog<bool>(
                    context: context,
                    builder: (context) => ConfirmDialog(
                        title:
                            'Bạn chưa cập nhật thông tin, chuyển đến phần cập nhật?'),
                  );
                  t.then(
                    (value) {
                      if (value != null) {
                        if (value) {
                          Navigator.of(context)
                              .pushNamed('/profile', arguments: [state.user]);
                        }
                      }
                    },
                  );
                  return;
                }
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
              } else
                Fluttertoast.showToast(
                    msg: 'Cần đăng nhập để thực hiện chức năng này');
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
                            .add(LoadHouses('Quận 1', null, sortType: 0));
                        Navigator.pushNamed(context, '/result',
                            arguments: ['Quận 1', null]);
                      },
                      title: 'Quận 1',
                      svgSrc: 'assets/images/quan_1.jpg',
                    ),
                    DistrictCard(
                      press: () {
                        BlocProvider.of<HouseBloc>(context)
                            .add(LoadHouses('Quận 3', null, sortType: 0));
                        Navigator.pushNamed(context, '/result',
                            arguments: ['Quận 3', null]);
                      },
                      title: 'Quận 3',
                      svgSrc: 'assets/images/quan_3.jpg',
                    ),
                    DistrictCard(
                      press: () {
                        BlocProvider.of<HouseBloc>(context).add(
                            LoadHouses('Quận Bình Thạnh', null, sortType: 0));
                        Navigator.pushNamed(context, '/result',
                            arguments: ['Quận Bình Thạnh', null]);
                      },
                      title: 'Bình Thạnh',
                      svgSrc: 'assets/images/binh_thanh.jpg',
                    ),
                    DistrictCard(
                      press: () {
                        BlocProvider.of<HouseBloc>(context)
                            .add(LoadHouses('Quận Thủ Đức', null, sortType: 0));
                        Navigator.pushNamed(context, '/result',
                            arguments: ['Quận Thủ Đức', null]);
                      },
                      title: 'Thủ Đức',
                      svgSrc: 'assets/images/thu_duc.jpg',
                    ),
                    DistrictCard(
                      press: () {
                        BlocProvider.of<HouseBloc>(context)
                            .add(LoadHouses('Quận 10', null, sortType: 0));
                        Navigator.pushNamed(context, '/result',
                            arguments: ['Quận 10', null]);
                      },
                      title: 'Quận 10',
                      svgSrc: 'assets/images/quan_10.jpg',
                    ),
                    DistrictCard(
                      press: () {
                        BlocProvider.of<HouseBloc>(context)
                            .add(LoadHouses('Quận 7', null, sortType: 0));
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
                      'Cập nhật gần đây',
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
                        BlocProvider.of<HouseBloc>(context)
                            .add(LoadHouses(null, null, sortType: 0));
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
                color: Colors.white54,
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
              SizedBox(
                height: defaultPadding / 2,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                height: 250,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    NewsCard(
                      size: size,
                      title: 'Những nhà trọ hào phóng ở Sài Gòn',
                      urlPost:
                          'https://vnexpress.net/nhung-chu-nha-tro-hao-phong-o-sai-gon-4293332.html',
                      urlImage:
                          'https://i1-giadinh.vnecdn.net/2021/06/13/z2549223051104-e726f60b5d8d7f0-1373-8104-1623559223.jpg?w=1020&h=0&q=100&dpr=1&fit=crop&s=c1IXY3mIwasDGD4Aq-Rggw',
                    ),
                    NewsCard(
                      size: size,
                      title: 'Cải tạo dãy phòng trọ thành tổ ấm trong mơ',
                      urlPost:
                          'https://vnexpress.net/cai-tao-day-phong-tro-thanh-to-am-trong-mo-4290794.html',
                      urlImage:
                          'https://i1-giadinh.vnecdn.net/2021/06/09/AICCSS001-3580-1623222371.jpg?w=1020&h=0&q=100&dpr=1&fit=crop&s=SVUYNEhzFHy_gW9yjokZdw',
                    ),
                    NewsCard(
                      size: size,
                      title: 'Phong toả khu nhà trọ ở Sài Gòn',
                      urlPost:
                          'https://vnexpress.net/phong-toa-khu-nha-tro-o-sai-gon-4280372.html',
                      urlImage:
                          'https://i1-vnexpress.vnecdn.net/2021/05/18/quan-7-3-6956-1621350739.jpg?w=1020&h=0&q=100&dpr=1&fit=crop&s=aFASOvSMylOAdEMqkUBCjg',
                    ),
                  ],
                ),
              )
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
    return BlocProvider(
      create: (context) => DetailHouseCubit(),
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, authState) {
          return BlocBuilder<RecentViewBloc, RecentViewState>(
            builder: (context, state) =>
                BlocListener<DetailHouseCubit, DetailHouseState>(
              listener: (context, detailState) {
                if (detailState.status == DetailStatus.success) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  if (detailState.house.daGO == true) {
                    Fluttertoast.showToast(
                        msg: 'Nhà đã bị gỡ xin vui lòng xem nhà khác');
                  } else if (detailState.house.dangCapNhat) {
                    Fluttertoast.showToast(
                        msg:
                            'Nhà đang được cập nhật, hãy thử lại sau một lát!');
                  } else {
                    if (state is RecentViewLoaded &&
                        authState is AuthenticationStateSuccess) {
                      if (state.houses
                          .map((e) => e.uid)
                          .toList()
                          .contains(house.uid)) {
                        BlocProvider.of<RecentViewBloc>(context).add(
                            RemoveViewedHouse(
                                user: authState.user, house: house));
                      }
                      BlocProvider.of<RecentViewBloc>(context)
                          .add(AddToViewed(user: authState.user, house: house));
                    }
                    Navigator.of(context)
                        .pushNamed('/detail', arguments: [detailState.house]);
                  }
                } else if (detailState.status == DetailStatus.loading) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(" Đang tải..."),
                            CircularProgressIndicator(),
                          ],
                        ),
                      ),
                    );
                } else
                  Fluttertoast.showToast(msg: 'Đã có lỗi xảy ra');
              },
              child: GestureDetector(
                onTap: () {
                  BlocProvider.of<DetailHouseCubit>(context).click(house);
                },
                child: Container(
                  width: size.width * 0.8,
                  margin: EdgeInsets.only(right: defaultPadding),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(color: Colors.black26),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: CachedNetworkImage(
                              imageUrl: house.urlHinhAnh[0] ?? '',
                              imageBuilder: (context, imageProvider) =>
                                  Container(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Text(
                                    Format.toMoneyPerMonth(house.tienThueThang),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: Colors.blue),
                                    maxLines: 1,
                                  ),
                                  Spacer(),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: SvgPicture.asset(
                                          'assets/icons/bed.svg',
                                        ),
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
                                        ),
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
                                        child: SvgPicture.asset(
                                          'assets/icons/area.svg',
                                        ),
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: defaultPadding / 2),
                              decoration: BoxDecoration(),
                              child: Center(
                                child: Text(
                                  house.diaChi,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xffB3B3B3),
                                  ),
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
              ),
            ),
          );
        },
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
            width: double.infinity,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/icons/logo.png",
                  height: 50,
                ),
                SizedBox(
                  height: defaultPadding,
                ),
                Text(
                  'Rent Finder',
                  style: Theme.of(context).textTheme.headline5.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
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
                .add(LoadHouses(value[0], value[1], sortType: 0));
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

class NewsCard extends StatelessWidget {
  const NewsCard({
    Key key,
    @required this.size,
    this.title,
    this.urlImage,
    this.urlPost,
  }) : super(key: key);

  final Size size;
  final String title, urlImage, urlPost;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(urlPost)) {
          await launch(urlPost);
        } else
          Fluttertoast.showToast(msg: 'Đã có lỗi xảy ra. Vui lòng thử lại sau');
      },
      child: Container(
        width: size.width * 0.7,
        margin: EdgeInsets.only(right: defaultPadding),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(urlImage),
                    ),
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
