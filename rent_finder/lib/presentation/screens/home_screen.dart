import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rent_finder/presentation/widgets/bottom_nav_bar.dart';
import 'package:rent_finder/presentation/widgets/search_bar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavBar(size: size),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              SearchBar(
                hintText: "Quận 3, TP.HCM",
              ),
              Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      ClipRRect(  
                        borderRadius: BorderRadius.circular(20),                     
                        child: MaterialButton(
                          height: size.height * 0.06,
                          shape: StadiumBorder(),
                           color: Colors.white,
                          onPressed: () {},
                          child: Text("Bộ lọc"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Nhà trọ',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    shape: CircleBorder(),
                    color: Colors.white,
                    child: SvgPicture.asset(
                      "assets/icons/ascending_sort.svg",
                      height: 21,
                      width: 21,
                    ),
                    height: 50,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
