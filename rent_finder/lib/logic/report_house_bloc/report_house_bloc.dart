import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mailer/mailer.dart';
import 'package:rent_finder_hi/data/models/models.dart';
import 'package:rent_finder_hi/data/repos/repos.dart';

part 'report_house_event.dart';
part 'report_house_state.dart';

class ReportHouseBloc extends Bloc<ReportHouseEvent, ReportHouseState> {
  ReportHouseBloc() : super(ReportHouseInit());

  @override
  Stream<ReportHouseState> mapEventToState(ReportHouseEvent event) async* {
    try {
      await _adminRepo.sendReportEmail(ReportHouseEmail(
          userUid: _userRepo.currentUser.uid,
          reportedHouseUid: event.reportedHouse.uid,
          reportedUserUid: event.reportedHouse.chuNha.uid,
          description: event.description));
      yield ReportHouseSuccess();
    } on SmtpClientAuthenticationException catch (e) {
      yield ReportHouseFail(errorDescription: e.message);
    } on SmtpClientCommunicationException catch (e) {
      yield ReportHouseFail(errorDescription: e.message);
    } on SocketException catch (e) {
      yield ReportHouseFail(errorDescription: e.message);
    } on SmtpMessageValidationException catch (e) {
      yield ReportHouseFail(errorDescription: e.message);
    } catch (e) {
      yield ReportHouseFail(errorDescription: e.toString());
    }
  }

  final AdministrationRepository _adminRepo = AdministrationRepository();
  final UserRepository _userRepo = UserRepository();
}
