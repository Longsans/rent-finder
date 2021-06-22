import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rent_finder_hi/data/models/models.dart' as model;
import 'package:rent_finder_hi/data/repos/repos.dart';
part 'my_houses_event.dart';
part 'my_houses_state.dart';

class MyHousesBloc extends Bloc<MyHousesEvent, MyHousesState> {
  MyHousesBloc() : super(MyHousesLoading());
  final UserRepository userRepository = UserRepository();
  HouseRepository houseRepository = HouseRepository();
  StreamSubscription housesSubscription;
  @override
  Stream<MyHousesState> mapEventToState(
    MyHousesEvent event,
  ) async* {
    if (event is LoadMyHouses) {
      yield* _mapLoadMyHousesToState(event);
    } else if (event is MyHousesUpdate) {
      yield* _mapMyHousesUpdateToState(event);
    }
  }

  Stream<MyHousesState> _mapLoadMyHousesToState(
    LoadMyHouses event,
  ) async* {
    if (housesSubscription != null) housesSubscription.cancel();
    housesSubscription =
        houseRepository.myHouses(event.userUid).listen((houses) {
      add(MyHousesUpdate(houses));
    });
  }

  Stream<MyHousesState> _mapMyHousesUpdateToState(
    MyHousesUpdate event,
  ) async* {
    for (int i = 0; i < event.houses.length; i++) {
      model.User user =
          await userRepository.getUserByUID(event.houses[i].chuNha.uid);
      event.houses[i].setSensitiveInfo(false, user);
    }
    yield MyHousesLoaded(event.houses);
  }

  @override
  Future<void> close() {
    if (housesSubscription != null) housesSubscription.cancel();
    return super.close();
  }
}
