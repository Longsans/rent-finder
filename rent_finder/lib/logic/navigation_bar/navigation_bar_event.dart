part of 'navigation_bar_bloc.dart';

abstract class NavigationBarEvent extends Equatable {
  const NavigationBarEvent();

  @override
  List<Object> get props => [];
}

class NavigationBarItemSelected extends NavigationBarEvent {
  final int index;
  const NavigationBarItemSelected({@required this.index});
}
