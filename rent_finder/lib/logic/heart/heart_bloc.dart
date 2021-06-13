import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rent_finder/constants.dart';

part 'heart_event.dart';
part 'heart_state.dart';

class HeartBloc extends Bloc<HeartEvent, HeartState> {
  HeartBloc(this.house) : super(HeartInitial());
  final House house;
  @override
  Stream<HeartState> mapEventToState(
    HeartEvent event,
  ) async* {
    if (event is HeartPressed) yield* mapHeartPressedEventToState(event, state);
    if (event is HeartStarted) yield* mapHeartStartedEventToState(event, state);
  }

  Stream<HeartState> mapHeartPressedEventToState(
      HeartPressed event, HeartState state) async* {
    if (state is HeartOutline) {
      yield HeartFill();
    } else
      yield HeartOutline();
  }

  Stream<HeartState> mapHeartStartedEventToState(
      HeartStarted event, HeartState state) async* {
    if (event.houses.contains(house)) {
      yield HeartFill();
    } else
      yield HeartOutline();
  }
}
