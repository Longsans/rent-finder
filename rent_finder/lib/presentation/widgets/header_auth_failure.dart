import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeaderUserFailure extends StatelessWidget {
  const HeaderUserFailure({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          child: SvgPicture.asset('assets/images/login.svg'),
        ),
        Text(
          'Đăng nhập để có trải nghiệm tốt nhất & đồng bộ hóa tài khoản của bạn trên mọi thiết bị',
          maxLines: 3,
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(fontWeight: FontWeight.w500, fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}