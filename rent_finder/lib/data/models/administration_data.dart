class AdministrationData {
  String smtpUsername;
  String smtpPassword;
  int issueNumber;
  int reportNumber;

  AdministrationData.fromJson(Map<String, dynamic> json)
      : smtpUsername = json['smtpUsername'],
        smtpPassword = json['smtpPassword'],
        issueNumber = json['currentIssueNumber'],
        reportNumber = json['currentReportNumber'];
}
