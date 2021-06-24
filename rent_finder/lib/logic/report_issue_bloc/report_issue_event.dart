part of 'report_issue_bloc.dart';

class ReportIssueEvent extends Equatable {
  final String issueDescription;

  ReportIssueEvent({@required this.issueDescription});

  @override
  List<Object> get props => [];
}
