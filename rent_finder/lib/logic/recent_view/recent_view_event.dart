part of 'recent_view_bloc.dart';

abstract class RecentViewEvent extends Equatable {
  const RecentViewEvent();

  @override
  List<Object> get props => [];
}

class LoadViewedHouses extends RecentViewEvent {
  final String userUid;

  LoadViewedHouses({this.userUid});
}

class AddToViewed extends RecentViewEvent {
  final model.User user;
  final model.House house;

  AddToViewed({this.user, this.house});
  List<Object> get props => [user, house];
}

class RemoveViewedHouse extends RecentViewEvent {
  final model.User user;
  final model.House house;

  RemoveViewedHouse({this.user, this.house});
  @override
  List<Object> get props => [user, house];
}

class ViewedHousesUpdate extends RecentViewEvent {
  final List<model.House> houses;

  ViewedHousesUpdate({this.houses});
  @override
  List<Object> get props => [houses];
}
