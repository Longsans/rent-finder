part of 'newest_house_cubit.dart';

enum Status { loading, success, failure }

class NewestHouseState extends Equatable {
  const NewestHouseState({this.houses, this.status = Status.loading});
  final List<House> houses;
  final Status status;
  NewestHouseState copyWith({Status status, List<House> houses}) {
    return NewestHouseState(houses: houses ?? this.houses, status: status ?? this.status);
  }

  @override
  List<Object> get props => [houses, status];
}
