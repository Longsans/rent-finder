part of 'update_profile_bloc.dart';

class UpdateProfileState extends Equatable {
  const UpdateProfileState(
      {this.isSubmitting,
      this.isSuccess,
      this.isFailure,
      this.isPhoneValid,
      this.isNameValid});
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final bool isPhoneValid;
  final bool isNameValid;

  UpdateProfileState copyWith(
      {bool isSubmitting,
      bool isSuccess,
      bool isFailure,
      bool isPhoneValid,
      bool isNameValid}) {
    return UpdateProfileState(
      isFailure: isFailure ?? this.isFailure,
      isSuccess: isSuccess ?? this.isSuccess,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      isNameValid: isNameValid ?? this.isNameValid,
    );
  }

  bool get isFormValid => isNameValid && isPhoneValid;
  UpdateProfileState update({bool isPhoneValid, bool isNameValid}) {
    return copyWith(
        isFailure: false,
        isSubmitting: false,
        isSuccess: false,
        isNameValid: isNameValid,
        isPhoneValid: isPhoneValid);
  }

  factory UpdateProfileState.initial() {
    return UpdateProfileState(
      isNameValid: true,
      isPhoneValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }
  factory UpdateProfileState.loading() {
    return UpdateProfileState(
      isNameValid: true,
      isPhoneValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }
  factory UpdateProfileState.failure() {
    return UpdateProfileState(
      isNameValid: true,
      isPhoneValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }
  factory UpdateProfileState.success() {
    return UpdateProfileState(
      isNameValid: true,
      isPhoneValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  @override
  List<Object> get props =>
      [isSubmitting, isSuccess, isFailure, isPhoneValid, isNameValid];
}
