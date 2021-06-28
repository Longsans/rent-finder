import 'package:flutter/cupertino.dart';
import 'package:rent_finder_hi/data/models/models.dart';

class ContentAttentionEmail extends BaseEmail {
  House house;

  String get header =>
      'Content attention needed for post with House UID ${house.uid}';

  @override
  String content() {
    String result =
        'Content attention needed for post with House UID: ${house.uid} \n\nHouse address: ${house.diaChi}.';
    if (house.toaDo != null)
      result +=
          '\nRetrieved coordinates: ${house.toaDo.latitude}, ${house.toaDo.longitude}.';
    else
      result += '\nCoordinates couldn\'t be retrieved.';

    result +=
        '\n\nOwner UID: ${house.chuNha.uid} \nOwner name: ${house.chuNha.hoTen}';

    return result;
  }

  ContentAttentionEmail({@required this.house});
}
