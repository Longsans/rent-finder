part of 'filtered_houses_bloc.dart';

abstract class FilteredHousesEvent extends Equatable {
  const FilteredHousesEvent();

  @override
  List<Object> get props => [];
}

class UpdateFilter extends FilteredHousesEvent {
  final model.Filter filter;
  final int type;
  UpdateFilter({this.type, this.filter});
  @override
  List<Object> get props => [filter, type];
}

class UpdateHouses extends FilteredHousesEvent {
  final List<model.House> houses;

  UpdateHouses({this.houses});
  @override
  List<Object> get props => [houses];
}
