import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rent_finder/constants.dart';

part 'like_event.dart';
part 'like_state.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  LikeBloc(this.houses) : super(LikeState(houses));

  List<House> houses;
  @override
  Stream<LikeState> mapEventToState(
    LikeEvent event,
  ) async* {
    if (event is LikeAddPressed) {
      yield* _mapLikeAddPressedToState(event, state);
    }
    if (event is LikeRemovePressed) {
      yield* _mapLikeRemovePressedToState(event, state);
    }
  }

  Stream<LikeState> _mapLikeAddPressedToState(
      LikeAddPressed event, LikeState state) async* {
    likedHouses.add(event.house);
    yield LikeState(likedHouses);
  }

  Stream<LikeState> _mapLikeRemovePressedToState(
      LikeRemovePressed event, LikeState state) async* {
        likedHouses.remove(event.house);
    yield LikeState(likedHouses);
  }
}
