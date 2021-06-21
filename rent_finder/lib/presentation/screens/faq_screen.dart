import 'package:flutter/material.dart';


class FAQPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: new AppBar(
          title: Text('Câu hỏi thường gặp',
            style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }
          ),

        ),
        body: Stack(
            children: <Widget>[

              ListView.builder(
                itemBuilder: (BuildContext context, int index) =>
                    EntryItem(data[index]),
                itemCount: data.length,
              ),



            ]
        )
    );}

}


// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.title, [this.children = const <Entry>[]]);

  final String title;
  final List<Entry> children;
}

// The entire multilevel list displayed by this app.
final List<Entry> data = <Entry>[
  Entry(
    'Ứng dụng Rent-Finder là gì',
    <Entry>[
      Entry('Là một ứng dụng di động được tạo ra để cung cấp thông tin liên quan đến thuê nhà, tìm kiếm nhà ở, trọ, căn hộ chung cư,... trên một khu vực địa lý nhất định trong bản dồ. '),
    ],
  ),
  Entry(
    'Ứng dụng Rent-Finder hỗ trợ trên thiết bị nào',
    <Entry>[
      Entry('Ứng dụng di động Rent-Finder hiện được hỗ trợ trên các thiết bị iOS và Android'),
    ],
  ),
  Entry(
    'Tôi có thể thực hiện những thao tác nào với ứng dụng Rent-Finder?',
    <Entry>[
      Entry('Ứng dụng cho phép bạn tạo tài khoản mặc định hoặc sử dụng tài khoản có sẵn của Google. Cho phép bạn đăng tin thuê nhà hoặc là khách hàng đi xem thông tin các nhà cho thuê.'),
    ],
  ),
  Entry(
    'Ứng dụng có những ngôn ngữ nào?',
    <Entry>[
      Entry('Hiện tại ứng dụng chỉ phục vụ nhu cầu tìm kiếm trọ cho người Việt Nam. Tương lai đội ngũ phát triễn sẽ nâng cấp ngôn ngữ để đa dạng, phù hợp với nhiều đối tượng tiếp cận hơn.'),
    ],
  ),

  Entry(
    'Đối tượng thường xuyên sử dụng Rent-Finder',
    <Entry>[
      Entry('Đối với người thuê: Đa số là các bạn sinh viên, các cô chú công nhân, người mới ra trường và mới đi làm. Đối với người cho thuê: Đa số là cô chú lớn tuổi, các chủ nhà trọ, căn hộ chung cư,...'),
    ],
  ),
];

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      leading: Icon(Icons.question_answer_outlined),
      title: Text(root.title),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}

