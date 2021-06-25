import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rent_finder_hi/data/models/models.dart';
import 'package:rent_finder_hi/data/repos/repos.dart';

part 'newest_house_state.dart';

class NewestHouseCubit extends Cubit<NewestHouseState> {
  NewestHouseCubit() : super(NewestHouseState());
  final HouseRepository houseRepository = HouseRepository();
  StreamSubscription housesSubscription;
  void loadNewestHouse() {
    if (housesSubscription != null) housesSubscription.cancel();
    housesSubscription = houseRepository.newestHouses().listen((houses) {
      updateNewestHouse(houses);
    });
  }

  void updateNewestHouse(List<House> houses) {
    emit(state.copyWith(status: Status.success, houses: houses));
  }
  @override
  Future<void> close() {
    if (housesSubscription != null) housesSubscription.cancel();
    return super.close();
  }
}
