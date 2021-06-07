part of 'like_bloc.dart';
 class LikeState extends Equatable {
  const LikeState(this.houses);
  final List<House> houses;
  @override
  List<Object> get props => [];
}


// class LikeAdd extends LikeState {
//   final List<House> houses;

//   LikeAdd({this.houses});
//   @override
//   // TODO: implement props
//   List<Object> get props => [houses];
// }
// class LikeRemove extends LikeState {
//   final List<House> houses;

//   LikeRemove({this.houses});
//   List<Object> get props => [houses];
// }
