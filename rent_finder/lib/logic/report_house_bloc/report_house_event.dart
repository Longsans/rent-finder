part of 'report_house_bloc.dart';

class ReportHouseEvent extends Equatable {
  final House reportedHouse;
  final String description;

  @override
  List<Object> get props => [];

  ReportHouseEvent({@required this.reportedHouse, @required this.description});
}
