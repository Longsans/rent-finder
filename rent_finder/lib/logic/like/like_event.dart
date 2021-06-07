part of 'like_bloc.dart';

abstract class LikeEvent extends Equatable {
  const LikeEvent();

  @override
  List<Object> get props => [];
}

class LikeAddPressed extends LikeEvent {
  const LikeAddPressed(this.house);
  final House house;
  @override
  List<Object> get props => [house];
}
class LikeRemovePressed extends LikeEvent {
  const LikeRemovePressed(this.house);
  final House house;
  @override
  List<Object> get props => [house];
}
