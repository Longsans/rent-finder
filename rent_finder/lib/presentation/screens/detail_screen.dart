import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../constants.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({
    Key key,
    this.house,
  }) : super(key: key);
  final double expandedHeight = 300;
  final double roundedContainerHeight = 30;
  final House house;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          CustomScrollView(slivers: [
            _buildSliverHead(),
            SliverToBoxAdapter(
              child: _buildDetail(context),
            )
          ]),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: defaultPadding,
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    onPressed: () {
                      print('cc');
                    },
                    icon: SizedBox(
                      height: 20,
                      width: 20,
                      child: SvgPicture.asset(
                        house.isLiked
                            ? 'assets/icons/heart_filled.svg'
                            : 'assets/icons/heart.svg',
                        color: Colors.yellowAccent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildDetail(BuildContext context) {
    Completer<GoogleMapController> _controller = Completer();
    Set<Marker> markers = {};
    var homeMarker = Marker(
      markerId: MarkerId(house.location),
      position: house.latLocation,
      infoWindow: InfoWindow(
        title: house.location,
        snippet: house.price,
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
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: Colors.greenAccent,
                size: 30,
              ),
              SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                flex: 6,
                child: Text(
                  house.location,
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
              Icon(
                Icons.price_change,
                color: Colors.purple[100],
                size: 30,
              ),
              SizedBox(
                width: defaultPadding,
              ),
              Text(
                house.price,
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
                  CameraPosition(target: house.latLocation, zoom: 15),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
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
            house.description,
            style: Theme.of(context).textTheme.caption.copyWith(fontSize: 16),
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
          Text(
            "Cơ sở vật chất & tiện nghi",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: defaultPadding * 1.5,
          ),
          Text(
            "Địa điểm xung quanh",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverHead() {
    return SliverPersistentHeader(
        delegate: DetailSliverDelegate(
            expandedHeight, house, roundedContainerHeight));
  }
}

class ImageList extends StatelessWidget {
  const ImageList({
    Key key,
    @required this.house,
  }) : super(key: key);

  final House house;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: house.imgList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/gallery', arguments: [house.imgList, index]);
            },
            child: Container(
              margin: EdgeInsets.only(right: defaultPadding),
              height: 150,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: AssetImage(house.imgList[index]), fit: BoxFit.cover),
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
  final House house;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(house.avatar),
          radius: 30,
        ),
        SizedBox(
          width: defaultPadding,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              house.owner,
              style: Theme.of(context).textTheme.subtitle1,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              "Chủ sở hữu",
              style: Theme.of(context).textTheme.caption,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            )
          ],
        ),
        Spacer(),
        CircleAvatar(
          backgroundColor: Color(0xffEEEEEE),
          child: IconButton(
            onPressed: () {
              print('cc');
            },
            icon: Icon(
              Icons.phone,
              color: Colors.yellow,
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
              print('cc');
            },
            icon: Icon(
              Icons.mail,
              color: Colors.yellow,
            ),
          ),
        ),
      ],
    );
  }
}

class DetailSliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final House house;
  final double roundedContainerHeight;
  DetailSliverDelegate(
      this.expandedHeight, this.house, this.roundedContainerHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      children: [
        Image.asset(
          house.imgSrc,
          width: MediaQuery.of(context).size.width,
          height: expandedHeight,
          fit: BoxFit.cover,
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
