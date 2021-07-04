import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:rent_finder_hi/data/repos/user_repository.dart';
import 'package:rent_finder_hi/utils/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'login_state.dart';
part 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;

  LoginBloc({UserRepository userRepository})
      : _userRepository = userRepository,
        super(LoginState.initial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginEmailChange) {
      yield* _mapLoginEmailChangeToState(event.email);
    } else if (event is LoginPasswordChanged) {
      yield* _mapLoginPasswordChangeToState(event.password);
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
          email: event.email, password: event.password);
    } else if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGooglePressedToState();
    }
  }

  Stream<LoginState> _mapLoginEmailChangeToState(String email) async* {
    yield state.update(isEmailValid: Validators.isValidEmail(email));
  }

  Stream<LoginState> _mapLoginPasswordChangeToState(String password) async* {
    yield state.update(isPasswordValid: password != null && password != "");
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState(
      {String email, String password}) async* {
    yield LoginState.loading();
    try {
      await _userRepository.signInWithCredentials(email, password);
      if (await _userRepository.isEmailVerified())
        yield LoginState.success();
      else {
        await _userRepository.signOut();
        yield LoginState.failure().copyWith(
            error: 'Bạn cần xác nhận email trước khi đăng nhập');
      }
    } catch (error) {
      if (error is FirebaseAuthException) {
        String e = "";
        print(error.code);
        switch (error.code) {
          case 'user-not-found':
          case 'wrong-password':
            e = 'Thông tin đăng nhập không chính xác';
            break;
          default:
            e = 'Đăng nhập thất bại';
            break;
        }
        yield LoginState.failure().copyWith(error: e);
      } else {
        yield LoginState.failure().copyWith(error: "Đăng nhập thất bại");
      }
    }
  }

  Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
    yield LoginState.loading();
    try {
      await _userRepository.signInWithGoogle();
      yield LoginState.success();
    } catch (error) {
      String e = "";
      if (error is PlatformException) {
        switch (error.code) {
          case 'network_error':
            e = "Lỗi kết nối";
            break;
          default:
            e = "Lỗi không xác định";
            break;
        }
      } else
        e = "Đăng nhập thất bại";
      yield LoginState.failure().copyWith(error: e);
    }
  }
}
