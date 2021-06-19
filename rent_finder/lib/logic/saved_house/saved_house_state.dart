part of 'saved_house_bloc.dart';

abstract class SavedHouseState extends Equatable {
  const SavedHouseState();

  @override
  List<Object> get props => [];
}

class SavedHouseLoading extends SavedHouseState {}

class SavedHouseLoaded extends SavedHouseState {
  final List<model.House> houses;

  SavedHouseLoaded({this.houses});
  @override

  List<Object> get props => [houses];
}
