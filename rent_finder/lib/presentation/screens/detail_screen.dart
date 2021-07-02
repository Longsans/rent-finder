import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:rent_finder_hi/data/models/models.dart' as model;
import 'package:rent_finder_hi/logic/bloc.dart';
import 'package:rent_finder_hi/presentation/widgets/report_sheet.dart';
import 'package:rent_finder_hi/presentation/widgets/save_button.dart';
import 'package:rent_finder_hi/utils/format.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen({
    Key key,
    this.house,
  }) : super(key: key);
  final double expandedHeight = 300;
  final double roundedContainerHeight = 30;
  model.House house;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return ReportSheet(house1: house,);
              });
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.flag,
                size: 30,
                color: textColor,
              ),
              SizedBox(
                width: defaultPadding,
              ),
              Text(
                'Báo cáo vi phạm',
                style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
          child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverHead(),
              SliverToBoxAdapter(
                child: _buildDetail(context),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black12,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
                SaveButton(house: house),
              ],
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildDetail(BuildContext context) {
    Completer<GoogleMapController> _controller = Completer();
    Set<Marker> markers = {};
    var homeMarker = Marker(
      markerId: MarkerId(house.diaChi),
      position: house.toaDo,
      infoWindow: InfoWindow(
        title: house.diaChi,
        snippet: Format.toMoneyPerMonth(house.tienThueThang),
      ),
    );
    markers.add(homeMarker);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding * 1.5),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoOwner(
            house: house,
          ),
          SizedBox(
            height: defaultPadding * 1.5,
          ),
          Container(
            child: Row(
              children: [
                Icon(
                    house.tinhTrang == model.TinhTrangChoThue.ConTrong
                        ? Icons.verified
                        : house.tinhTrang == model.TinhTrangChoThue.DaThue
                            ? Icons.info
                            : Icons.build_circle_rounded,
                    color: primaryColor,
                    size: 30),
                SizedBox(
                  width: defaultPadding,
                ),
                Text(
                  house.tinhTrang == model.TinhTrangChoThue.ConTrong
                      ? 'Còn trống'
                      : house.tinhTrang == model.TinhTrangChoThue.DaThue
                          ? 'Đã thuê'
                          : 'Bảo trì',
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: textColor),
                ),
              ],
            ),
          ),
          SizedBox(
            height: defaultPadding * 0.5,
          ),
          Row(
            children: [
              Icon(Icons.location_on, color: Color(0xFF0D4880), size: 30),
              SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                flex: 6,
                child: Text(
                  house.diaChi,
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: textColor),
                ),
              ),
              Spacer(),
            ],
          ),
          SizedBox(
            height: defaultPadding * 0.5,
          ),
          Row(
            children: [
              Icon(Icons.attach_money, color: Color(0xFF0D4880), size: 30),
              SizedBox(
                width: defaultPadding,
              ),
              Text(
                Format.toMoneyPerMonth(house.tienThueThang),
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: textColor),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
          SizedBox(
            height: defaultPadding * 1.5,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: GoogleMap(
              markers: markers,
              initialCameraPosition:
                  CameraPosition(target: house.toaDo, zoom: 15),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          SizedBox(
            height: defaultPadding * 1.5,
          ),
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[100],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(defaultPadding * 0.5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child:
                          Icon(Icons.house_siding, size: 30, color: textColor),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${house.dienTich.toStringAsFixed(0)} m2',
                      style: TextStyle(
                          color: textColor, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(defaultPadding * 0.5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Icon(Icons.category, size: 30, color: textColor),
                    ),
                    SizedBox(height: 5),
                    Text(
                      house.loaiChoThue == model.LoaiChoThue.CanHo
                          ? 'Căn hộ'
                          : house.loaiChoThue == model.LoaiChoThue.Nha
                              ? 'Nhà'
                              : 'Phòng',
                      style: TextStyle(
                          color: textColor, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(defaultPadding * 0.5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
<<<<<<< HEAD
                      child: Icon(Icons.king_bed_outlined,
                          size: 30, color: textColor),
=======
                      child: Icon(Icons.king_bed_outlined, size: 30, color: textColor),
>>>>>>> b239d456d269db663b7d06f9a78cd3f2ee288189
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${house.soPhongNgu}',
                      style: TextStyle(
                          color: textColor, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(defaultPadding * 0.5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Icon(Icons.bathtub_outlined,
                          size: 30, color: textColor),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${house.soPhongTam}',
                      style: TextStyle(
                          color: textColor, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: defaultPadding * 1.5,
          ),
          Text(
            "Mô tả",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: defaultPadding / 2,
          ),
          Text(
            house.moTa,
            style: Theme.of(context).textTheme.caption.copyWith(fontSize: 16),
          ),
          SizedBox(
            height: defaultPadding * 1.5,
          ),
          Text(
            "Cơ sở vật chất & tiện nghi",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: defaultPadding / 2,
          ),
          GridView.count(
            crossAxisCount: 4,
            physics: NeverScrollableScrollPhysics(),
            children: _buildUtilitiesList,
            childAspectRatio: 1,
            shrinkWrap: true,
          ),
          SizedBox(
            height: defaultPadding * 1.5,
          ),
          Text(
            "Ảnh",
            style: Theme.of(context).textTheme.button.copyWith(fontSize: 20),
          ),
          SizedBox(
            height: defaultPadding / 2,
          ),
          SizedBox(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: ImageList(house: house),
          ),
          SizedBox(
            height: defaultPadding * 1.5,
          ),
        ],
      ),
    );
  }

  List<Widget> get _buildUtilitiesList {
    return [
      if (house.coSoVatChat.dieuHoa)
        UtilityCard(
          svgSrc: 'assets/icons/air_conditioner.svg',
          title: 'Điều hòa',
        ),
      if (house.coSoVatChat.banCong)
        UtilityCard(
          svgSrc: 'assets/icons/balcony.svg',
          title: 'Ban công',
        ),
      if (house.coSoVatChat.noiThat)
        UtilityCard(
          svgSrc: 'assets/icons/interior.svg',
          title: 'Nội thất',
        ),
      if (house.coSoVatChat.mayGiat)
        UtilityCard(
          svgSrc: 'assets/icons/washer.svg',
          title: 'Máy giặt',
        ),
      if (house.coSoVatChat.gacLung)
        UtilityCard(
          svgSrc: 'assets/icons/mezzanine.svg',
          title: 'Gác lửng',
        ),
      if (house.coSoVatChat.baoVe)
        UtilityCard(
          svgSrc: 'assets/icons/guard.svg',
          title: 'Bảo vệ',
        ),
      if (house.coSoVatChat.hoBoi)
        UtilityCard(
          svgSrc: 'assets/icons/pool.svg',
          title: 'Hồ bơi',
        ),
      if (house.coSoVatChat.baiDauXe)
        UtilityCard(
          svgSrc: 'assets/icons/parking.svg',
          title: 'Bãi đậu xe',
        ),
      if (house.coSoVatChat.cctv)
        UtilityCard(
          svgSrc: 'assets/icons/cctv.svg',
          title: 'CCTV',
        ),
      if (house.coSoVatChat.nuoiThuCung)
        UtilityCard(
          svgSrc: 'assets/icons/pet.svg',
          title: 'Thú cưng',
        ),
      if (house.coSoVatChat.sanThuong)
        UtilityCard(
          svgSrc: 'assets/icons/roof.svg',
          title: 'Sân thượng',
        ),
    ];
  }

  Widget _buildSliverHead() {
    return SliverPersistentHeader(
        delegate: DetailSliverDelegate(
            expandedHeight, house, roundedContainerHeight));
  }
}

class UtilityCard extends StatelessWidget {
  const UtilityCard({
    Key key,
    this.title,
    this.svgSrc,
  }) : super(key: key);

  final String title;
  final String svgSrc;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding / 2),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: SvgPicture.asset(
              svgSrc,
              color: Color(0xFF0D4880),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF0D4880),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageList extends StatelessWidget {
  const ImageList({
    Key key,
    @required this.house,
  }) : super(key: key);

  final model.House house;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: house.urlHinhAnh.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/gallery',
                  arguments: [house.urlHinhAnh, index]);
            },
            child: Container(
              margin: EdgeInsets.only(right: defaultPadding),
              height: 150,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: NetworkImage(house.urlHinhAnh[index]),
                    fit: BoxFit.cover),
              ),
            ),
          );
        });
  }
}

class InfoOwner extends StatelessWidget {
  const InfoOwner({
    Key key,
    this.house,
  }) : super(key: key);
  final model.House house;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CachedNetworkImage(
          imageUrl: house.chuNha.urlHinhDaiDien ?? '',
          imageBuilder: (context, imageProvider) => Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => SizedBox(
              height: 60,
              width: 60,
              child: Center(child: CircularProgressIndicator())),
          errorWidget: (context, url, error) => Icon(
            Icons.account_circle_outlined,
            size: 60,
            color: Color(0xFF0D4880),
          ),
        ),
        SizedBox(
          width: defaultPadding,
        ),
        Container(
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                house.chuNha.hoTen ?? 'Chưa đặt tên',
                style: Theme.of(context).textTheme.subtitle1,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Chủ sở hữu",
                style: Theme.of(context).textTheme.caption,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )
            ],
          ),
        ),
        Spacer(),
        CircleAvatar(
          backgroundColor: Color(0xffEEEEEE),
          child: IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Gọi điện'),
                      content: Text(
                          "Bạn có muốn gọi đến số ${house.chuNha.sdt} không?"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              _makeCall('tel:${house.chuNha.sdt}');
                            },
                            child: Text('Có')),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Không')),
                      ],
                    );
                  });
            },
            icon: Icon(
              Icons.phone,
              color: Color(0xFF0D4880),
            ),
          ),
        ),
        SizedBox(
          width: defaultPadding,
        ),
        CircleAvatar(
          backgroundColor: Color(0xffEEEEEE),
          child: IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Nhắn tin'),
                      content: Text(
                          "Bạn có muốn nhắn tin đến số ${house.chuNha.sdt} không?"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              _makeSms('${house.chuNha.sdt}');
                            },
                            child: Text('Có')),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Không')),
                      ],
                    );
                  });
            },
            icon: Icon(
              Icons.mail,
              color: Color(0xFF0D4880),
            ),
          ),
        ),
      ],
    );
  }

  void _makeCall(String number) async {
    await launch('tel:$number');
  }

  void _makeSms(String number) async {
    await launch('sms:$number');
  }
}

class DetailSliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final model.House house;
  final double roundedContainerHeight;
  DetailSliverDelegate(
      this.expandedHeight, this.house, this.roundedContainerHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: house.urlHinhAnh[0] ?? '',
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(
            Icons.account_circle_outlined,
            size: 30,
            color: Color(0xFF0D4880),
          ),
        ),
        Positioned(
          top: expandedHeight - roundedContainerHeight - shrinkOffset,
          left: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: roundedContainerHeight,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )),
          ),
        )
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

}
