
part of 'authentication_bloc.dart';
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override

  List<Object> get props => [];
}
class AuthenticationStateInitial extends AuthenticationState {}
class AuthenticationLoading extends AuthenticationState {}
class AuthenticationStateSuccess extends AuthenticationState {
  final model.User user;
  const AuthenticationStateSuccess({this.user});
  @override

  List<Object> get props => [user];


}
class AuthenticationStateFailure extends AuthenticationState {}