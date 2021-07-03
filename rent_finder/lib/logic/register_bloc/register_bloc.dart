import 'package:firebase_auth/firebase_auth.dart';
import 'package:rent_finder_hi/data/repos/user_repository.dart';
import 'package:rent_finder_hi/utils/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'register_event.dart';
part 'register_state.dart';
// import 'package:rxdart/rxdart.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;

  RegisterBloc({UserRepository userRepository})
      : _userRepository = userRepository,
        super(RegisterState.initial());

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterEmailChanged) {
      yield* _mapRegisterEmailChangeToState(event.email);
    } else if (event is RegisterPasswordChanged) {
      yield* _mapRegisterPasswordChangeToState(event.password);
    } else if (event is RegisterSubmitted) {
      yield* _mapRegisterSubmittedToState(
          email: event.email, password: event.password);
    }
  }

  Stream<RegisterState> _mapRegisterEmailChangeToState(String email) async* {
    yield state.update(isEmailValid: Validators.isValidEmail(email));
  }

  Stream<RegisterState> _mapRegisterPasswordChangeToState(
      String password) async* {
    yield state.update(isPasswordValid: Validators.isValidPassword(password));
  }

  Stream<RegisterState> _mapRegisterSubmittedToState(
      {String email, String password}) async* {
    yield RegisterState.loading();
    try {
      await _userRepository.signUpWithEmailAndPassword(email, password);
      yield RegisterState.success();
    } on FirebaseException catch (error) {
      String e = "";
      print(error.code);
      switch (error.code) {
        case 'network-request-failed':
          e = 'Đã có lỗi mạng xảy ra';
          break;
        case 'email-already-in-use':
          e = 'Email của bạn đã tồn tại';
          break;
        default:
          e = 'Đăng ký thất bại';
          break;
      }
      yield RegisterState.failure().copyWith(error: e);
    } on Exception catch (error) {
      yield RegisterState.failure()
          .copyWith(error: 'Đăng ký thất bại: ${error.toString()}');
    }
  }
}
