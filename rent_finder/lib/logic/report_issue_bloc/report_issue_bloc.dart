import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:mailer/mailer.dart';
import 'package:rent_finder_hi/data/models/models.dart';
import 'package:rent_finder_hi/data/repos/repos.dart';

part 'report_issue_event.dart';
part 'report_issue_state.dart';

class ReportIssueBloc extends Bloc<ReportIssueEvent, ReportIssueState> {
  ReportIssueBloc() : super(ReportIssueInit());

  @override
  Stream<ReportIssueState> mapEventToState(ReportIssueEvent event) async* {
    try {
      await _adminRepo.sendIssueEmail(IssueEmail(
          userUid: _userRepo.currentUser.uid,
          description: event.issueDescription));
      yield ReportIssueSuccess();
    } on SmtpClientAuthenticationException catch (e) {
      yield ReportIssueFail(errorDescription: e.message);
    } on SmtpClientCommunicationException catch (e) {
      yield ReportIssueFail(errorDescription: e.message);
    } on SocketException catch (e) {
      yield ReportIssueFail(errorDescription: e.message);
    } on SmtpMessageValidationException catch (e) {
      yield ReportIssueFail(errorDescription: e.message);
    } catch (e) {
      yield ReportIssueFail(errorDescription: e.toString());
    }
  }

  final AdministrationRepository _adminRepo = AdministrationRepository();
  final UserRepository _userRepo = UserRepository();
}
