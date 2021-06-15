import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rent_finder/data/repos/user_repository.dart';
import 'package:rent_finder/utils/validators.dart';
part 'update_profile_event.dart';
part 'update_profile_state.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  UpdateProfileBloc({this.userRepository})
      : super(UpdateProfileState.initial());
  final UserRepository userRepository;
  @override
  Stream<UpdateProfileState> mapEventToState(
    UpdateProfileEvent event,
  ) async* {
    if (event is NameChanged) {
      yield* _mapNameChangedToState(event.name);
    } else if (event is PhoneChanged) {
      yield* _mapPhoneChangedToState(event.phone);
    } else if (event is FormSubmitted) {
      yield* _mapFormSubmittedToState(event.name, event.phone, event.url);
    } 
  }

  Stream<UpdateProfileState> _mapNameChangedToState(
    String name,
  ) async* {
    yield state.update(isNameValid: (name != null && name != ""));
  }

  Stream<UpdateProfileState> _mapPhoneChangedToState(
    String phone,
  ) async* {
    yield state.update(isPhoneValid: Validators.isValidPhone(phone));
  }

  Stream<UpdateProfileState> _mapFormSubmittedToState(
      String name, String phone, String url) async* {
    yield UpdateProfileState.loading();

    try {
     await userRepository.updateUser(phone, name, url);
      yield UpdateProfileState.success();
    } catch (err) {
      print(err);
      yield UpdateProfileState.failure();
    }
  }
}
