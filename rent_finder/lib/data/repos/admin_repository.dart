import 'package:mailer/mailer.dart';
import 'package:rent_finder_hi/data/data_providers/data_providers.dart';
import 'package:rent_finder_hi/data/models/issue_email.dart';
import 'package:rent_finder_hi/data/models/models.dart';

class AdministrationRepository {
  Stream<AdministrationData> administrationData() {
    return _adminProvider
        .administrationData()
        .map((event) => AdministrationData.fromJson(event));
  }

  Future<SendReport> sendReportEmail(ReportEmail email) async {
    await _adminProvider.incrementReportNumber();

    final message = Message()
      ..from = Address(_adminData.smtpUsername, 'Rent Finder')
      ..recipients.add(_myDumbEmail)
      ..subject = 'Content report no. ${_adminData.reportNumber}'
      ..text = email.content();

    return await _adminProvider.sendEmail(message, _adminData);
  }

  Future<SendReport> sendIssueEmail(IssueEmail email) async {
    await _adminProvider.incrementIssueNumber();

    final message = Message()
      ..from = Address(_adminData.smtpUsername, 'Rent Finder')
      ..recipients.add(_myDumbEmail)
      ..subject = 'App issue report no. ${_adminData.issueNumber}'
      ..text = email.content();

    return await _adminProvider.sendEmail(message, _adminData);
  }

  AdministrationRepository() {
    administrationData().listen((event) {
      _adminData = event;
    });
  }

  AdministrationData _adminData;
  final String _myDumbEmail = '19521777@gm.uit.edu.vn';
  final AdministrationProvider _adminProvider = AdministrationProvider();
}
