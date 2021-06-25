import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:rent_finder_hi/data/models/models.dart';

class AdministrationProvider {
  Future<Map<String, dynamic>> administrationData() async {
    return (await _collection.doc('1').get()).data();
  }

  Future<SendReport> sendEmail(
      Message message, AdministrationData adminData) async {
    final smtpServer = mailgun(adminData.smtpUsername, adminData.smtpPassword);
    return await send(message, smtpServer);
  }

  Future<void> incrementIssueNumber() async {
    await _collection
        .doc('1')
        .update({'currentIssueNumber': FieldValue.increment(1)});
  }

  Future<void> incrementReportNumber() async {
    await _collection
        .doc('1')
        .update({'currentReportNumber': FieldValue.increment(1)});
  }

  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('administration');
}
