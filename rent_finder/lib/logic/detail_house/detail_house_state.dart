part of 'detail_house_cubit.dart';

enum DetailStatus { loading, success, failure }

class DetailHouseState extends Equatable {
  const DetailHouseState({this.status = DetailStatus.loading, this.house});
  final DetailStatus status;
  final House house;
  @override
  List<Object> get props => [status, house];
  DetailHouseState copyWith({
    DetailStatus status,
    House house,
  }) {
    return DetailHouseState(
        status: status ?? this.status, house: house ?? this.house);
  }
}
