part of 'report_issue_bloc.dart';

class ReportIssueState extends Equatable {
  @override
  List<Object> get props => [];
}

class ReportIssueInit extends ReportIssueState {}

class ReportIssueSuccess extends ReportIssueState {}

class ReportIssueFail extends ReportIssueState {
  final String errorCode;
  final String errorDescription;

  ReportIssueFail({this.errorCode, this.errorDescription});
}
