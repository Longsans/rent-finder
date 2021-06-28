import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rent_finder_hi/data/models/models.dart';
import 'package:rent_finder_hi/data/repos/repos.dart';

part 'detail_house_state.dart';

class DetailHouseCubit extends Cubit<DetailHouseState> {
  DetailHouseCubit() : super(DetailHouseState());
  HouseRepository houseRepository = HouseRepository();
  void click(House house) async {
    emit(state.copyWith(status: DetailStatus.loading));
    try {
      House h = await houseRepository.getHouseByUid(house.uid);
      emit(state.copyWith(house: h, status: DetailStatus.success));
    } catch (err) {
      emit(state.copyWith(status: DetailStatus.failure));
    }
  }
}
