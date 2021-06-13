part of 'heart_bloc.dart';

abstract class HeartEvent extends Equatable {
  const HeartEvent();

  @override
  List<Object> get props => [];
}
class HeartStarted extends HeartEvent {
  const HeartStarted({this.houses});
  final List<House> houses;
  @override
  List<Object> get props => [houses];
}
class HeartPressed extends HeartEvent {
  const HeartPressed();
  @override
  List<Object> get props => [];
}
