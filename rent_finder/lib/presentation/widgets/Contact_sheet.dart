import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdvanceCustomAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
        ),
        child: Stack(
          overflow: Overflow.visible,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 250,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 50, 10, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Liên hệ với chúng tôi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    SizedBox(height: 20,),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              String phoneo="tel:0793111038";
                              launch(phoneo);
                            },
                            child: Icon(Icons.settings_phone, color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(10),
                              primary: Colors.blue, // <-- Button color
                            ),
                          ),
                          Text("Hotline: +0793111038")
                        ]
                    ),
                    SizedBox(height: 10,),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              final url ='mailto:vhao1509@gmail.com?subject=${Uri.encodeFull("Cần liên hệ với Rent-Finder")}&body=${Uri.encodeFull("")}';
                              launch(url);
                              },
                            child: Icon(Icons.mail_sharp, color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(10),
                              primary: Colors.blue, // <-- Button color
                            ),
                          ),
                          Text("vhao1509@gmail.com")
                        ]
                    ),

                  ],
                ),
              ),
            ),
            Positioned(
                top: -60,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/giphy.gif'),
                )
            ),
          ],
        )
    );
  }
}
