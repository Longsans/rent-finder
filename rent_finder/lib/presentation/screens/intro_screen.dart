import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:rent_finder/presentation/screens/login_screen.dart';
import 'package:rent_finder/presentation/screens/register_screen.dart';
import 'package:rent_finder/presentation/screens/screens.dart';


class IntroPage extends StatefulWidget {
  // final UserRepository userRepository;
  const IntroPage({ Key key }) : super(key: key);
  //    : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  //final UserRepository userRepository;
  //_IntroPageState(this.userRepository);
  bool clicked = false;
  void afterIntroComplete (){

    setState(() {
      clicked = true;
    });
  }



  final List<PageViewModel> pages = [


    PageViewModel(
      titleWidget: Column(
        children: <Widget>[
          Text('Món quà miễn phí', style: TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.w600
          ),),
          SizedBox(height: 8,),
          Container(
            height: 3,
            width: 100,
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10)
            ),
          )
        ],
      ),
      body: "Tìm kiếm trọ một cách dễ dàng hơn, nhanh hơn, tiện lợi hơn.",
      image: Center(
          child: SvgPicture.asset("assets/icons/gift.svg")
      ),

      decoration: const PageDecoration(
          pageColor: Colors.white,
          bodyTextStyle: TextStyle(color: Colors.black54, fontSize: 16,),
          descriptionPadding: EdgeInsets.only(left: 20, right: 20),
          imagePadding: EdgeInsets.all(20)
      ),
    ),
    PageViewModel(
      titleWidget: Column(
        children: <Widget>[
          Text('Hệ sinh thái',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.w600,
            ),),
          SizedBox(height: 8,),
          Container(
            height: 3,
            width: 100,
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10)
            ),
          )
        ],
      ),
      body: "Quy mô rộng lớn, bao phủ khắp nơi. Dễ dàng xác định được các trọ ở xung quanh bạn.",
      image: Center(
          child: SizedBox(
            width: 450.0,
            child: SvgPicture.asset("assets/icons/payment.svg"),
          )
      ),

      decoration: const PageDecoration(
          pageColor: Colors.white,
          bodyTextStyle: TextStyle(color: Colors.black54, fontSize: 16,),
          descriptionPadding: EdgeInsets.only(left: 20, right: 20),
          imagePadding: EdgeInsets.all(20)
      ),
    ),
    PageViewModel(
      titleWidget: Column(
        children: <Widget>[
          Text('Trung tâm hỗ trợ', style: TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.w600
          ),),
          SizedBox(height: 8,),
          Container(
            height: 3,
            width: 100,
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10)
            ),
          )
        ],
      ),
      body: "Chúng tôi luôn có mặt để hỗ trợ những thắc mặc của bạn, hotline 24/24, facebook, gmaill",
      image: Center(
          child: SizedBox(
            width: 450.0,
            child: SvgPicture.asset("assets/icons/call.svg"),
          )
      ),

      decoration: const PageDecoration(
          pageColor: Colors.white,
          bodyTextStyle: TextStyle(color: Colors.black54, fontSize: 16,),
          descriptionPadding: EdgeInsets.only(left: 20, right: 20),
          imagePadding: EdgeInsets.all(20)
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return  clicked ? LoginScreen():IntroductionScreen(
      pages: pages,
      onDone: () {
        afterIntroComplete();
        UserArea();
      },
      onSkip: () {
        afterIntroComplete();
        UserArea();
      },
      showSkipButton: true,
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
      next: const Icon(Icons.navigate_next),
      done: const Text("DONE", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
          size: const Size.square(7.0),
          activeSize: const Size(20.0, 5.0),
          activeColor: Colors.blue,
          color: Colors.black12,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0))),
    ) ;
  }
}
