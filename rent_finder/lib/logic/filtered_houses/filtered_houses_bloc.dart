import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rent_finder_hi/data/models/models.dart' as model;
import 'package:rent_finder_hi/logic/bloc.dart';

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
          type: event.type,
          filter: event.filter,
          filteredHouses: _mapHousesToFilteredTodos(
              currentState.houses, event.filter, event.type));
    }
  }

  Stream<FilteredHousesState> _mapHousesUpdatedToState(
    UpdateHouses event,
  ) async* {
    final filter = state is FilteredHousesLoaded
        ? (state as FilteredHousesLoaded).filter
        : model.Filter();
    final type = state is FilteredHousesLoaded
        ? (state as FilteredHousesLoaded).type
        : 0;
    yield FilteredHousesLoaded(
        type: type,
        filter: filter,
        filteredHouses: _mapHousesToFilteredTodos(
            (housesBloc.state as HouseLoadSuccess).houses, filter, type));
  }

  List<model.House> _mapHousesToFilteredTodos(
      List<model.House> houses, model.Filter filter, int type) {
    var res = houses.where((house) {
      if (filter == model.Filter()) {
        return true;
      } else {
        bool res = true;
        if (filter.loaiChoThue != null)
          res = house.loaiChoThue == filter.loaiChoThue;
        if (filter.soPhongNgu != null)
          res = res && (house.soPhongNgu >= filter.soPhongNgu);
        if (filter.soPhongTam != null)
          res = res && (house.soPhongTam >= filter.soPhongTam);
        if (filter.tienThueMin != null)
          res = res && (house.tienThueThang >= filter.tienThueMin);
        if (filter.tienThueMax != null) {
          if (filter.tienThueMax < 30000000)
            res = res && house.tienThueThang <= filter.tienThueMax;
        }
        if (filter.areaMin != null) {
          res = res && (house.dienTich >= filter.areaMin);
        }
        if (filter.areaMax != null) {
          if (filter.areaMax < 100)
            res = res && (house.dienTich <= filter.areaMax);
        }
        if (filter.coSoVatChat != null) {
          if (filter.coSoVatChat.banCong)
            res = res && (house.coSoVatChat.banCong);
          if (filter.coSoVatChat.baoVe) res = res && (house.coSoVatChat.baoVe);
          if (filter.coSoVatChat.cctv) res = res && (house.coSoVatChat.cctv);
          if (filter.coSoVatChat.dieuHoa)
            res = res && (house.coSoVatChat.dieuHoa);
          if (filter.coSoVatChat.gacLung)
            res = res && (house.coSoVatChat.gacLung);
          if (filter.coSoVatChat.hoBoi) res = res && (house.coSoVatChat.hoBoi);
          if (filter.coSoVatChat.noiThat)
            res = res && (house.coSoVatChat.noiThat);
          if (filter.coSoVatChat.nuoiThuCung)
            res = res && (house.coSoVatChat.nuoiThuCung);
          if (filter.coSoVatChat.sanThuong)
            res = res && (house.coSoVatChat.sanThuong);
          if (filter.coSoVatChat.baiDauXe)
            res = res && (house.coSoVatChat.baiDauXe);
          if (filter.coSoVatChat.mayGiat)
            res = res && (house.coSoVatChat.mayGiat);
        }
        return res;
      }
    }).toList();
    if (filter != null) {
      if (filter.onlyEmpty)
      res = res.where(
          (element) => element.tinhTrang == model.TinhTrangChoThue.ConTrong).toList();
    }
    if (type == 0)
      res.sort((a, b) => b.ngayCapNhat.compareTo(a.ngayCapNhat));
    else if (type == 1)
      res.sort((a, b) => a.tienThueThang.compareTo(b.tienThueThang));
    else
      res.sort((a, b) => b.tienThueThang.compareTo(a.tienThueThang));
    return res;
  }

  @override
  Future<void> close() {
    housesSubscription.cancel();
    return super.close();
  }
}
