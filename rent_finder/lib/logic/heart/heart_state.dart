part of 'heart_bloc.dart';

abstract class HeartState extends Equatable {
  const HeartState();
  @override
  List<Object> get props => [];
}

class HeartInitial extends HeartState {}

class HeartFill extends HeartState {}

class HeartOutline extends HeartState {}
