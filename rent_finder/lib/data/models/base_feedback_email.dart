abstract class BaseFeedbackEmail {
  String userUid;
  String description;

  String content();

  BaseFeedbackEmail(this.userUid, this.description);
}
