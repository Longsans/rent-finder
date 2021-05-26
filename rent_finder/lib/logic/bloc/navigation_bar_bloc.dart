import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'navigation_bar_event.dart';
part 'navigation_bar_state.dart';

class NavigationBarBloc extends Bloc<NavigationBarEvent, NavigationBarState> {
  NavigationBarBloc() : super(NavigationBarHome(0));

  @override
  Stream<NavigationBarState> mapEventToState(
    NavigationBarEvent event,
  ) async* {
    if (event is NavigationBarItemSelected)
      yield* mapNavigationBarSelectedToState(event);
  }

  Stream<NavigationBarState> mapNavigationBarSelectedToState(
    NavigationBarItemSelected event,
  ) async* {
    switch (event.index) {
      case 0:
        yield NavigationBarHome(event.index);
        break;
      case 1:
        yield NavigationBarSearch(event.index);
        break;
      case 2:
        yield NavigationBarSaved(event.index);
        break;
      case 3:
        yield NavigationBarUser(event.index);
        break;
      default:
    }
  }
}
