import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent_finder/data/repos/user_repository.dart';
import 'package:rent_finder/presentation/screens/home_screen.dart';
import 'package:rent_finder/presentation/screens/login_screen.dart';
import 'package:rent_finder/presentation/screens/screens.dart';
import 'package:rent_finder/presentation/widgets/small_button.dart';
import 'package:rent_finder/presentation/widgets/custom_list_tile.dart';
class ProfilePage extends StatefulWidget {
  final UserRepository _userRepository;
  final User _user;
  ProfilePage({@required UserRepository userRepository,User user})
      : assert(1==1),
        _userRepository = userRepository,
        _user=user;
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool turnOnNotification = false;
  bool turnOnLocation = false;
  User get _user => widget._user;
  UserRepository get _userRepository => widget._userRepository;


  @override
  Widget build(BuildContext context) {
    if(_user==null){
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 120.0,
                        width: 120.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60.0),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 3.0,
                                offset: Offset(0, 4.0),
                                color: Colors.black38),
                          ],
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/images/avatar1.png",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "email....",
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "",
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          SmallButton(btnText: "Edit"),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    "Account",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Card(
                    elevation: 3.0,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          CustomListTile(
                            icon: Icons.location_on,
                            text: "Location",
                            text2:"Ho Chi Minh city",
                          ),
                          Divider(
                            height: 10.0,
                            color: Colors.grey,
                          ),
                          CustomListTile(
                            icon: Icons.visibility,
                            text: "Change Password",
                          ),
                          Divider(
                            height: 10.0,
                            color: Colors.grey,
                          ),
                          CustomListTile(
                            icon: Icons.timer,
                            text: "Shipping",
                          ),
                          Divider(
                            height: 10.0,
                            color: Colors.grey,
                          ),
                          CustomListTile(
                            icon: Icons.payment,
                            text: "Payment",
                          ),
                          Divider(
                            height: 10.0,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    "Notifications",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Card(
                    elevation: 3.0,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "App Notification",
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              Switch(
                                value: turnOnNotification,
                                onChanged: (bool value) {
                                  // print("The value: $value");
                                  setState(() {
                                    turnOnNotification = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          Divider(
                            height: 10.0,
                            color: Colors.grey,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Location Tracking",
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              Switch(
                                value: turnOnLocation,
                                onChanged: (bool value) {
                                  // print("The value: $value");
                                  setState(() {
                                    turnOnLocation = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          Divider(
                            height: 10.0,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    "Other",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Language", style: TextStyle(fontSize: 16.0)),
                            // SizedBox(height: 10.0,),
                            Divider(
                              height: 30.0,
                              color: Colors.grey,
                            ),
                            Text("Currency", style: TextStyle(fontSize: 16.0)),

                            // SizedBox(height: 10.0,),
                            Divider(
                              height: 30.0,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text("Đăng nhập"),
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginScreen();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    else{
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 120.0,
                        width: 120.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60.0),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 3.0,
                                offset: Offset(0, 4.0),
                                color: Colors.black38),
                          ],
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/images/avatar1.png",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Email: ${_user.email}",
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "",
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          SmallButton(btnText: "Edit"),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    "Account",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Card(
                    elevation: 3.0,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          CustomListTile(
                            icon: Icons.location_on,
                            text: "Location",
                            text2:"Ho Chi Minh city",
                          ),
                          Divider(
                            height: 10.0,
                            color: Colors.grey,
                          ),
                          CustomListTile(
                            icon: Icons.visibility,
                            text: "Change Password",
                            text2: "******",
                          ),
                          Divider(
                            height: 10.0,
                            color: Colors.grey,
                          ),
                          CustomListTile(
                            icon: Icons.timer,
                            text: "Checkin",
                            text2: "${_user.metadata.creationTime}",
                          ),
                          Divider(
                            height: 10.0,
                            color: Colors.grey,
                          ),
                          CustomListTile(
                            icon: Icons.payment,
                            text: "Payment",
                          ),
                          Divider(
                            height: 10.0,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    "Notifications",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Card(
                    elevation: 3.0,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "App Notification",
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              Switch(
                                value: turnOnNotification,
                                onChanged: (bool value) {
                                  // print("The value: $value");
                                  setState(() {
                                    turnOnNotification = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          Divider(
                            height: 10.0,
                            color: Colors.grey,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Location Tracking",
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              Switch(
                                value: turnOnLocation,
                                onChanged: (bool value) {
                                  // print("The value: $value");
                                  setState(() {
                                    turnOnLocation = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          Divider(
                            height: 10.0,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    "Other",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Language", style: TextStyle(fontSize: 16.0)),
                            // SizedBox(height: 10.0,),
                            Divider(
                              height: 30.0,
                              color: Colors.grey,
                            ),
                            Text("Currency", style: TextStyle(fontSize: 16.0)),

                            // SizedBox(height: 10.0,),
                            Divider(
                              height: 30.0,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text("Đăng xuất"),
                    onPressed: (){
                      _userRepository.signOut();

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return ProfilePage(userRepository: _userRepository);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

  }
}