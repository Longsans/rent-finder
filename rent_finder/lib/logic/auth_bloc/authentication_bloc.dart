import 'package:rent_finder_hi/data/repos/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_finder_hi/data/models/models.dart' as model;
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;
  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(AuthenticationStateInitial()); //initial state

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent authenticationEvent) async* {
    if (authenticationEvent is AuthenticationEventStarted) {
      if (!_userRepository.isSignedIn())
        await _userRepository.signInAnonymously();
      final user = await _userRepository.getCurrentUserData();

      if (_userRepository.isAuthenticated())
        yield AuthenticationStateAuthenticated(user: user);
      else
        yield AuthenticationStateSuccess(user: user);
    } else if (authenticationEvent is AuthenticationEventLoggedIn) {
      yield AuthenticationStateAuthenticated(
          user: await _userRepository.getCurrentUserData());
    } else if (authenticationEvent is AuthenticationEventLoggedOut) {
      await _userRepository.signOut();
      yield AuthenticationStateSuccess(
          user: await _userRepository.getCurrentUserData());
    }
  }
}
