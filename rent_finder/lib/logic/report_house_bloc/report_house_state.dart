part of 'report_house_bloc.dart';

class ReportHouseState extends Equatable {
  @override
  List<Object> get props => [];
}

class ReportHouseInit extends ReportHouseState {}

class ReportHouseSuccess extends ReportHouseState {}

class ReportHouseFail extends ReportHouseState {
  final String errorCode;
  final String errorDescription;

  ReportHouseFail({this.errorCode, this.errorDescription});
}
