part of 'filtered_houses_bloc.dart';

abstract class FilteredHousesState extends Equatable {
  const FilteredHousesState();

  @override
  List<Object> get props => [];
}

class FilteredHousesLoading extends FilteredHousesState {}

class FilteredHousesLoaded extends FilteredHousesState {
  final List<model.House> filteredHouses;
  final model.Filter filter;

  FilteredHousesLoaded({this.filteredHouses, this.filter});
  @override
  List<Object> get props => [filter, filteredHouses];
}
