part of 'my_houses_bloc.dart';

abstract class MyHousesState extends Equatable {
  const MyHousesState();
  
  @override
  List<Object> get props => [];
}


class MyHousesLoading extends MyHousesState {}

class MyHousesLoaded extends MyHousesState {
final List<model.House> houses;

  MyHousesLoaded(this.houses);
  @override

  List<Object> get props => [houses];
}
