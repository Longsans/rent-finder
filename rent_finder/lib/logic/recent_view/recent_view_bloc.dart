import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rent_finder_hi/data/models/models.dart' as model;
import 'package:rent_finder_hi/data/repos/repos.dart';

part 'recent_view_event.dart';
part 'recent_view_state.dart';

class RecentViewBloc extends Bloc<RecentViewEvent, RecentViewState> {
  RecentViewBloc() : super(RecentViewLoading());

  HouseRepository houseRepository = HouseRepository();
  StreamSubscription housesSubscription;
  @override
  Stream<RecentViewState> mapEventToState(
    RecentViewEvent event,
  ) async* {
    if (event is LoadViewedHouses) {
      yield* _mapLoadViewedHousesToState(event);
    } else if (event is AddToViewed) {
      yield* _mapAddToViewedToState(event);
    } else if (event is RemoveViewedHouse) {
      yield* _mapRemoveViewedHouseToState(event);
    } else if (event is ViewedHousesUpdate) {
      yield* _mapViewedHousesUpdateToState(event);
    }
  }

  Stream<RecentViewState> _mapLoadViewedHousesToState(
    LoadViewedHouses event,
  ) async* {
    if (housesSubscription != null) housesSubscription.cancel();
    housesSubscription =
        houseRepository.viewedHouses(event.userUid).listen((houses) {
      add(ViewedHousesUpdate(houses: houses));
    });
  }

  Stream<RecentViewState> _mapAddToViewedToState(
    AddToViewed event,
  ) async* {
    await houseRepository.addHouseToUserViewedHouses(
        event.user.uid, event.house);
  }

  Stream<RecentViewState> _mapRemoveViewedHouseToState(
    RemoveViewedHouse event,
  ) async* {
    await houseRepository.removeHouseFromUserViewHouses(
        event.user.uid, event.house.uid);
  }

  Stream<RecentViewState> _mapViewedHousesUpdateToState(
    ViewedHousesUpdate event,
  ) async* {
    yield RecentViewLoaded(houses: event.houses);
  }

  @override
  Future<void> close() {
    housesSubscription.cancel();
    return super.close();
  }
}
