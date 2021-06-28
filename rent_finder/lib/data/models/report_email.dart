import 'package:flutter/cupertino.dart';
import 'package:rent_finder_hi/data/models/models.dart';

abstract class ReportEmail extends BaseFeedbackEmail {
  String reportedUserUid;

  ReportEmail(
      {@required userUid,
      @required this.reportedUserUid,
      @required description})
      : super(userUid, description);
}

class ReportHouseEmail extends ReportEmail {
  String reportedHouseUid;

  @override
  String content() {
    return 'Reporting user UID: $userUid \nReported house: $reportedHouseUid \nOwned by user with UID: $reportedUserUid \n\n$description';
  }

  ReportHouseEmail(
      {@required userUid,
      @required this.reportedHouseUid,
      @required reportedUserUid,
      @required description})
      : super(
            userUid: userUid,
            reportedUserUid: reportedUserUid,
            description: description);
}
