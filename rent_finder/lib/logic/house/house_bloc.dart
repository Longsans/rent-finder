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
  // StreamSubscription housesSubscription;
  @override
  Stream<HouseState> mapEventToState(
    HouseEvent event,
  ) async* {
    if (event is AddHouse) {
      yield* _mapAddHouseEventToState(event.house);
    } else if (event is LoadHouses) {
      yield* _mapLoadHousesEventToState(event);
    } else if (event is FilterByCategory) {
      yield* _mapFilterByCategoryEventToState(event);
    } else if (event is HousesUpdate) {
      yield* _mapHousesUpdateEventToState(event);
    }
  }

  Stream<HouseState> _mapAddHouseEventToState(model.House house) async* {}
  Stream<HouseState> _mapFilterByCategoryEventToState(
      FilterByCategory event) async* {}

  Stream<HouseState> _mapLoadHousesEventToState(LoadHouses event) async* {
    yield HouseLoading();
    try {
      var houses = await houseRepository.getHousesByLocation(
          event.quanHuyen, event.phuongXa);
      yield HouseLoadSuccess(
          houses: houses.where((element) => element.daGO != true).toList());
    } catch (err) {
      yield HouseLoadFailure();
    }
  }

  Stream<HouseState> _mapHousesUpdateEventToState(HousesUpdate event) async* {}
}
