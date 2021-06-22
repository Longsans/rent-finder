part of 'update_profile_bloc.dart';

abstract class UpdateProfileEvent extends Equatable {
  const UpdateProfileEvent();

  @override
  List<Object> get props => [];
}

class NameChanged extends UpdateProfileEvent {
  final String name;

  NameChanged({this.name});
  @override
  List<Object> get props => [name];
}

class PhoneChanged extends UpdateProfileEvent {
  final String phone;

  PhoneChanged({this.phone});
  @override
  List<Object> get props => [phone];
}

class FormSubmitted extends UpdateProfileEvent {
  final String phone, url, name;

  FormSubmitted({this.phone, this.url, this.name});
  @override
  List<Object> get props => [phone, url, name];
}
