part of 'saved_house_bloc.dart';

abstract class SavedHouseEvent extends Equatable {
  const SavedHouseEvent();

  @override
  List<Object> get props => [];
}

class LoadSavedHouses extends SavedHouseEvent {
  final String userUid;

  LoadSavedHouses({this.userUid});
}

class AddToSaved extends SavedHouseEvent {
  final model.User user;
  final model.House house;

  AddToSaved({this.user, this.house});
  List<Object> get props => [user, house];
}

class RemoveSavedHouse extends SavedHouseEvent {
  final model.User user;
  final model.House house;

  RemoveSavedHouse({this.user, this.house});
  @override
  List<Object> get props => [user, house];
}

class SavedHousesUpdate extends SavedHouseEvent {
  final List<String> housesUid;

  SavedHousesUpdate({this.housesUid});
  @override

  List<Object> get props => [housesUid];
}
