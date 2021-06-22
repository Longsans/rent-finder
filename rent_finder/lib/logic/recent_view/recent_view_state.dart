part of 'recent_view_bloc.dart';

abstract class RecentViewState extends Equatable {
  const RecentViewState();

  @override
  List<Object> get props => [];
}

class RecentViewLoading extends RecentViewState {}

class RecentViewLoaded extends RecentViewState {
  final List<model.House> houses;

  RecentViewLoaded({this.houses});
  @override

  List<Object> get props => [houses];
}
