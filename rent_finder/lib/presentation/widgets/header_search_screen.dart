import 'package:flutter/material.dart';

class HeaderSearchScreen extends StatelessWidget {
  const HeaderSearchScreen({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
           height: size.height * 0.3,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.none,
                image: AssetImage("assets/images/mine_art.png"),
                alignment: Alignment.bottomCenter),
          ),
        ),         
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Tìm nhà trọ lý tưởng cho bạn",
                style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
