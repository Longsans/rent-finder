import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rent_finder_hi/data/models/models.dart' as model;
import 'package:rent_finder_hi/data/repos/repos.dart';
part 'house_event.dart';
part 'house_state.dart';

class HouseBloc extends Bloc<HouseEvent, HouseState> {
  HouseBloc({this.houseRepository}) : super(HouseLoading());
  final HouseRepository houseRepository;
  final UserRepository userRepository = UserRepository();
  StreamSubscription housesSubscription;
  @override
  Stream<HouseState> mapEventToState(
    HouseEvent event,
  ) async* {
    if (event is AddHouse) {
      yield* _mapAddHouseEventToState(event.house);
    } else if (event is LoadHouses) {
      yield* _mapLoadHousesEventToState();
    } else if (event is FilterByCategory) {
      yield* _mapFilterByCategoryEventToState(event);
    } else if (event is HousesUpdate) {
      yield* _mapHousesUpdateEventToState(event);
    }
  }

  Stream<HouseState> _mapAddHouseEventToState(model.House house) async* {}
  Stream<HouseState> _mapFilterByCategoryEventToState(
      FilterByCategory event) async* {}

  Stream<HouseState> _mapLoadHousesEventToState() async* {
    if (housesSubscription != null) housesSubscription.cancel();
    housesSubscription = houseRepository.houses().listen((houses) {
      add(HousesUpdate(houses: houses));
    });
  }

  Stream<HouseState> _mapHousesUpdateEventToState(HousesUpdate event) async* {
    for (int i = 0; i < event.houses.length; i++) {
      model.User user =
          await userRepository.getUserByUID(event.houses[i].chuNha.uid);
      event.houses[i].setSensitiveInfo(false, user);
    }
    yield HouseLoadSuccess(houses: event.houses);
  }

  @override
  Future<void> close() {
    if (housesSubscription != null) housesSubscription.cancel();
    return super.close();
  }
}
