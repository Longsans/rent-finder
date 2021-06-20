import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rent_finder_hi/constants.dart';
import 'package:rent_finder_hi/presentation/widgets/widgets.dart';

class FindHouseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding * 1.25,
          ),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.3,
              ),
              Text(
                'Bạn muốn tìm nhà trọ ở đâu?',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SearchBar(
                      hintText: 'Tìm khu vực hoặc địa chỉ',
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
              Spacer(),
              GestureDetector(
                onTap: () {},
                child: Container(
                  child: Text(
                    'Tôi muốn cho thuê',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                        color: textColor, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
