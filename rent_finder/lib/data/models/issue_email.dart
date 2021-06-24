import 'package:rent_finder_hi/data/models/base_feedback_email.dart';

class IssueEmail extends BaseFeedbackEmail {
  @override
  String content() {
    return "Reporting user UID: $userUid \n\n$description";
  }
}
