part of 'navigation_bar_bloc.dart';

class NavigationBarState extends Equatable {
  const NavigationBarState({@required this.index});
  final int index;

  @override
  List<Object> get props => [index];
}

