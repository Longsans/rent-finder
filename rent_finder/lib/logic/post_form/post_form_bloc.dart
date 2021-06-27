import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rent_finder_hi/data/models/models.dart' as model;
import 'package:rent_finder_hi/data/repos/house_repository.dart';

part 'post_form_event.dart';
part 'post_form_state.dart';

class PostFormBloc extends Bloc<PostFormEvent, PostFormState> {
  PostFormBloc() : super(PostFormState.initial());
  HouseRepository houseRepository = HouseRepository();
  @override
  Stream<PostFormState> mapEventToState(
    PostFormEvent event,
  ) async* {
    if (event is StreetChanged) {
      yield* _mapStreetChangedToState(event.street);
    } else if (event is NumChanged) {
      yield* _mapNumChangedToState(event.num);
    } else if (event is AreaChanged) {
      yield* _mapAreaChangedToState(event.area);
    } else if (event is MoneyChanged) {
      yield* _mapMoneyChangedToState(event.money);
    } else if (event is DescribeChanged) {
      yield* _mapDescribeChangedToState(event.describe);
    } else if (event is PostFormSubmitted) {
      yield* _mapFormSubmittedToState(event.house, event.files);
    }
  }

  Stream<PostFormState> _mapAreaChangedToState(
    String area,
  ) async* {
    yield state.update(
        isAreaValid:
            (area != null && area != "" && double.tryParse(area) != null));
  }

  Stream<PostFormState> _mapStreetChangedToState(
    String street,
  ) async* {
    yield state.update(isStreetValid: (street != null && street != ""));
  }

  Stream<PostFormState> _mapMoneyChangedToState(
    String money,
  ) async* {
    yield state.update(
        isMoneyValid:
            (money != null && money != "" && double.tryParse(money) != null));
  }

  Stream<PostFormState> _mapNumChangedToState(
    String num,
  ) async* {
    yield state.update(isNumValid: (num != null && num != ""));
  }

  Stream<PostFormState> _mapDescribeChangedToState(
    String describe,
  ) async* {
    yield state.update(isDescribeValid: (describe != null && describe != ""));
  }

  Stream<PostFormState> _mapFormSubmittedToState(
      model.House house, List<File> files) async* {
    yield PostFormState.loading();
    try {
      //TODO: implement geolocation validation on address
      // house.toaDo = LatLng(10.7853985, 106.7066477);
      await houseRepository.createHouse(house, files);

      yield PostFormState.success();
    } catch (err) {
      yield PostFormState.failure();
    }
  }
}
