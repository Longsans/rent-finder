import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rent_finder/constants.dart';
import 'package:rent_finder/presentation/widgets/bottom_nav_bar.dart';
import 'package:rent_finder/presentation/widgets/header_search_screen.dart';
import 'package:rent_finder/presentation/widgets/search_bar.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavBar(
        size: size,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderSearchScreen(size: size),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SearchBar(
                      hintText: "Tìm theo khu vực hoặc địa chỉ",
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    shape: CircleBorder(),
                    color: Colors.white,
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: SvgPicture.asset(
                        "assets/icons/ascending_sort.svg",
                      ),
                    ),
                    height: 50,
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
                  itemCount: recentHomes.length,
                  itemBuilder: (context, index) {
                    return RecentHomeListTile(
                      size: size,
                      recentHome: recentHomes[index],
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
    this.recentHome,
  }) : super(key: key);

  final Size size;
  final RecentHome recentHome;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                image: AssetImage(recentHome.imgSrc),
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
                  recentHome.price,
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
                  recentHome.location,
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
                          Text('${recentHome.numOfBed}'),
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
                          Text('${recentHome.numOfBath}'),
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
                          Text('${recentHome.area}'),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Spacer(),
          SvgPicture.asset(
            recentHome.isLiked
                ? 'assets/icons/heart_filled.svg'
                : 'assets/icons/heart.svg',
            height: 25,
            width: 25,
            color: Colors.redAccent,
          ),
        ],
      ),
    );
  }
}
