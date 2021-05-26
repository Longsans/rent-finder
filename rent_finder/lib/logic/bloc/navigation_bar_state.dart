part of 'navigation_bar_bloc.dart';

abstract class NavigationBarState extends Equatable {
  const NavigationBarState({@required this.index});
  final int index;

  @override
  List<Object> get props => [index];
}

class NavigationBarInitial extends NavigationBarState {
  NavigationBarInitial(int index) : super(index: index);
}

class NavigationBarHome extends NavigationBarState {
   NavigationBarHome(int index) : super(index: index);
}

class NavigationBarUser extends NavigationBarState {
   NavigationBarUser(int index) : super(index: index);
}

class NavigationBarSaved extends NavigationBarState {
   NavigationBarSaved (int index) : super(index: index);
}

class NavigationBarSearch extends NavigationBarState {
   NavigationBarSearch(int index) : super(index: index);
}
