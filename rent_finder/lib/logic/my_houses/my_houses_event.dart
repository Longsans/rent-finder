part of 'my_houses_bloc.dart';

abstract class MyHousesEvent extends Equatable {
  const MyHousesEvent();

  @override
  List<Object> get props => [];
}

class LoadMyHouses extends MyHousesEvent {
  final String userUid;

  LoadMyHouses({this.userUid});
  @override
  List<Object> get props => [userUid];
}

class EditMyHouses extends MyHousesEvent {}

class MyHousesUpdate extends MyHousesEvent {
  final List<model.House> houses;

  MyHousesUpdate(this.houses);
  @override
  List<Object> get props => [houses];
}
