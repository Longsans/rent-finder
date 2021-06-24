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
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final user = await _userRepository.getCurrentUserData();
        yield AuthenticationStateSuccess(user: user);
      } else {
        yield AuthenticationStateFailure();
      }
    } else if (authenticationEvent is AuthenticationEventLoggedIn) {
      yield AuthenticationStateSuccess(
          user: await _userRepository.getCurrentUserData());
    } else if (authenticationEvent is AuthenticationEventLoggedOut) {
      _userRepository.signOut();
      yield AuthenticationStateFailure();
    }
  }
}
