import 'package:rent_finder_hi/data/models/base_email.dart';

abstract class BaseFeedbackEmail implements BaseEmail {
  String userUid;
  String description;

  String content();

  BaseFeedbackEmail(this.userUid, this.description);
}
