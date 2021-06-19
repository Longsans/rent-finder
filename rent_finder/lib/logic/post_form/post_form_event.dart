part of 'post_form_bloc.dart';

abstract class PostFormEvent extends Equatable {
  const PostFormEvent();

  @override
  List<Object> get props => [];
}

class StreetChanged extends PostFormEvent {
  final String street;

  StreetChanged({this.street});
  @override
  List<Object> get props => [street];
}

class NumChanged extends PostFormEvent {
  final String num;

  NumChanged({this.num});
  @override
  List<Object> get props => [num];
}

class MoneyChanged extends PostFormEvent {
  final String money;

  MoneyChanged({this.money});
  @override
  List<Object> get props => [money];
}

class DescribeChanged extends PostFormEvent {
  final String describe;

  DescribeChanged({this.describe});
  @override
  List<Object> get props => [describe];
}

class AreaChanged extends PostFormEvent {
  final String area;

  AreaChanged({this.area});
  @override
  List<Object> get props => [area];
}

class PostFormSubmitted extends PostFormEvent {
  final model.House house;
  final List<File> files;
  PostFormSubmitted({this.files, this.house});
  @override
  List<Object> get props => [house, files];
}
