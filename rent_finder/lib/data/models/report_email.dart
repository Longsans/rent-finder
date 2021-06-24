import 'package:rent_finder_hi/data/models/base_feedback_email.dart';

class ReportEmail extends BaseFeedbackEmail {
  bool reportHouse;
  String reportedUserUid;
  String reportedHouseUid;

  @override
  String content() {
    String result = 'Reporting user UID: $userUid';
    if (reportHouse)
      result +=
          '\nReported house: $reportedHouseUid \nOwned by user with UID: $reportedUserUid';
    else
      result += '\nReported user UID: $reportedUserUid';

    result += '\n\n$description';
    return result;
  }
}
