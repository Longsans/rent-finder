part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {
  
}

class CategoryLoading extends CategoryState {
  CategoryLoading();
  @override
  List<Object> get props => [];
}

class CategoryLoaded extends CategoryState {
  final List<House> houses;

  CategoryLoaded({this.houses});
  @override
  List<Object> get props => [houses];
}

class CategoryFailure extends CategoryState {}
