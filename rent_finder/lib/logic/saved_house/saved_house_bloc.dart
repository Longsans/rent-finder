import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rent_finder_hi/data/models/models.dart' as model;
import 'package:rent_finder_hi/data/repos/repos.dart';
part 'saved_house_event.dart';
part 'saved_house_state.dart';

class SavedHouseBloc extends Bloc<SavedHouseEvent, SavedHouseState> {
  SavedHouseBloc() : super(SavedHouseLoading());

  final HouseRepository houseRepository = HouseRepository();
  StreamSubscription housesSubscription;
  @override
  Stream<SavedHouseState> mapEventToState(
    SavedHouseEvent event,
  ) async* {
    if (event is LoadSavedHouses) {
      yield* _mapLoadSavedHousesToState(event);
    } else if (event is AddToSaved) {
      yield* _mapAddToSavedToState(event);
    } else if (event is RemoveSavedHouse) {
      yield* _mapRemoveSavedHouseToState(event);
    } else if (event is SavedHousesUpdate) {
      yield* _mapSavedHousesUpdateToState(event);
    }
  }

  Stream<SavedHouseState> _mapLoadSavedHousesToState(
    LoadSavedHouses event,
  ) async* {
    if (housesSubscription != null) housesSubscription.cancel();
    housesSubscription =
        houseRepository.savedHouses(event.userUid).listen((houses) {
      add(SavedHousesUpdate(houses: houses));
    });
  }

  Stream<SavedHouseState> _mapAddToSavedToState(
    AddToSaved event,
  ) async* {
    // print(event.user.uid + event.house.uid);
    await houseRepository.addHouseToUserSavedHouses(
        event.user.uid, event.house);
  }

  Stream<SavedHouseState> _mapRemoveSavedHouseToState(
    RemoveSavedHouse event,
  ) async* {
    await houseRepository.removeHouseFromUserSavedHouses(
        event.user.uid, event.house.uid);
  }

  Stream<SavedHouseState> _mapSavedHousesUpdateToState(
    SavedHousesUpdate event,
  ) async* {
    yield SavedHouseLoaded(houses: event.houses);
  }

  @override
  Future<void> close() {
    housesSubscription.cancel();
    return super.close();
  }
}
