import 'package:flutter/cupertino.dart';
import 'package:rent_finder_hi/data/models/models.dart';

class IssueEmail extends BaseFeedbackEmail {
  @override
  String content() {
    return "Reporting user UID: $userUid \n\n$description";
  }

  IssueEmail({@required userUid, @required description})
      : super(userUid, description);
}
