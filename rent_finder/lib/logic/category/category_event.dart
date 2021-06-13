part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class CategoryStarted extends CategoryEvent {
  final bool isClicked;
  final String query;
  CategoryStarted({this.isClicked, this.query});
}

class CategoryPressed extends CategoryEvent {
  final String query;
  final bool isClicked;
  CategoryPressed({
    this.isClicked,
    this.query,
  });
}
