part of 'house_bloc.dart';

abstract class HouseState extends Equatable {
  const HouseState();

  @override
  List<Object> get props => [];
}

class HouseInitial extends HouseState {}

class HouseLoading extends HouseState {}

class HouseLoadSuccess extends HouseState {
  final List<model.House> houses;

  HouseLoadSuccess({this.houses});
  @override
  List<Object> get props => [houses];
}

class HouseLoadFailure extends HouseState {}
