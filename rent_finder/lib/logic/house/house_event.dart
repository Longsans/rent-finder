part of 'house_bloc.dart';

abstract class HouseEvent extends Equatable {
  const HouseEvent();

  @override
  List<Object> get props => [];
}

class AddHouse extends HouseEvent {
  final model.House house;

  AddHouse(this.house);
  @override
  List<Object> get props => [house];
}

class LoadHouses extends HouseEvent {}

class FilterByCategory extends HouseEvent {
  final model.LoaiChoThue loaiChoThue;

  FilterByCategory({this.loaiChoThue});
  @override

  List<Object> get props => [loaiChoThue];
}

class HousesUpdate extends HouseEvent {
  final List<model.House> houses;

  HousesUpdate({this.houses});
  @override
  List<Object> get props => [houses];
}
