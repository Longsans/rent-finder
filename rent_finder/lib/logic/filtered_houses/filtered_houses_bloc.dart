import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rent_finder/data/models/models.dart' as model;
import 'package:rent_finder/logic/bloc.dart';

part 'filtered_houses_event.dart';
part 'filtered_houses_state.dart';

class FilteredHousesBloc
    extends Bloc<FilteredHousesEvent, FilteredHousesState> {
  FilteredHousesBloc({@required this.housesBloc})
      : super(
          housesBloc.state is HouseLoadSuccess
              ? FilteredHousesLoaded(
                  filteredHouses: (housesBloc.state as HouseLoadSuccess).houses,
                  filter: model.Filter())
              : FilteredHousesLoading(),
        ) {
    housesSubscription = housesBloc.stream.listen(
      (state) {
        if (state is HouseLoadSuccess) add(UpdateHouses(houses: state.houses));
      },
    );
  }
  final HouseBloc housesBloc;
  StreamSubscription housesSubscription;
  @override
  Stream<FilteredHousesState> mapEventToState(
    FilteredHousesEvent event,
  ) async* {
    if (event is UpdateFilter) {
      yield* _mapUpdateFilterToState(event);
    } else if (event is UpdateHouses) {
      yield* _mapHousesUpdatedToState(event);
    }
  }

  Stream<FilteredHousesState> _mapUpdateFilterToState(
    UpdateFilter event,
  ) async* {
    final currentState = housesBloc.state;
    if (currentState is HouseLoadSuccess) {
      yield FilteredHousesLoaded(
          filter: event.filter,
          filteredHouses:
              _mapHousesToFilteredTodos(currentState.houses, event.filter));
    }
  }

  Stream<FilteredHousesState> _mapHousesUpdatedToState(
    UpdateHouses event,
  ) async* {
    final filter = state is FilteredHousesLoaded
        ? (state as FilteredHousesLoaded).filter
        : model.Filter();
    yield FilteredHousesLoaded(
        filter: filter,
        filteredHouses: _mapHousesToFilteredTodos(
            (housesBloc.state as HouseLoadSuccess).houses, filter));
  }

  List<model.House> _mapHousesToFilteredTodos(
      List<model.House> houses, model.Filter filter) {
    return houses.where((house) {
      if (filter == model.Filter()) {
        return true;
      } else {
        bool res = true;
        // if (filter == null) return true;
        if (filter.loaiChoThue != null)
          res = house.loaiChoThue == filter.loaiChoThue;
        if (filter.soPhongNgu != null)
          res = res && (house.soPhongNgu >= filter.soPhongNgu);
        if (filter.soPhongTam != null)
          res = res && (house.soPhongTam >= filter.soPhongTam);
        if (filter.tienThueMin != null && filter.tienThueMax != null)
          res = res &&
              (house.tienThueThang >= filter.tienThueMin &&
                  house.tienThueThang <= filter.tienThueMax);
        if (filter.quanHuyen != null)
          res = res && (house.quanHuyen == filter.quanHuyen);
        if (filter.phuongXa != null)
          res = res && (house.phuongXa == filter.phuongXa);
        return res;
      }
    }).toList();
  }

  @override
  Future<void> close() {
    housesSubscription.cancel();
    return super.close();
  }
}
