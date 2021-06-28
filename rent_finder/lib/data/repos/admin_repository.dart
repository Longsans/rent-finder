import 'package:mailer/mailer.dart';
import 'package:rent_finder_hi/data/data_providers/data_providers.dart';
import 'package:rent_finder_hi/data/models/issue_email.dart';
import 'package:rent_finder_hi/data/models/models.dart';

class AdministrationRepository {
  Future<AdministrationData> getAdministrationData() async {
    return await _adminProvider
        .getAdministrationData()
        .then((value) => AdministrationData.fromJson(value));
  }

  Future<SendReport> sendReportEmail(ReportEmail email) async {
    await _adminProvider.incrementReportNumber();
    _adminData = await getAdministrationData();

    final message = Message()
      ..from = Address(_adminData.smtpUsername, 'Rent Finder')
      ..recipients.add(_myDumbEmail)
      ..subject = 'Content report no. ${_adminData.reportNumber}'
      ..text = email.content();

    return await _adminProvider.sendEmail(message, _adminData);
  }

  Future<SendReport> sendIssueEmail(IssueEmail email) async {
    await _adminProvider.incrementIssueNumber();
    _adminData = await getAdministrationData();

    final message = Message()
      ..from = Address(_adminData.smtpUsername, 'Rent Finder')
      ..recipients.add(_myDumbEmail)
      ..subject = 'App issue report no. ${_adminData.issueNumber}'
      ..text = email.content();

    return await _adminProvider.sendEmail(message, _adminData);
  }

  Future<SendReport> sendContentAttentionEmail(
      ContentAttentionEmail email) async {
    if (_adminData == null) _adminData = await getAdministrationData();

    final message = Message()
      ..from = Address(_adminData.smtpUsername, 'Rent Finder')
      ..recipients.add(_myDumbEmail)
      ..subject = email.header
      ..text = email.content();

    return await _adminProvider.sendEmail(message, _adminData);
  }

  AdministrationData _adminData;
  final String _myDumbEmail = '19521777@gm.uit.edu.vn';
  final AdministrationProvider _adminProvider = AdministrationProvider();
}
