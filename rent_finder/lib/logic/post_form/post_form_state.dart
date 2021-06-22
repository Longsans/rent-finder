part of 'post_form_bloc.dart';

class PostFormState extends Equatable {
  const PostFormState(
      {this.isDescribeValid,
      this.isMoneyValid,
      this.isAreaValid,
      this.isSubmitting,
      this.isSuccess,
      this.isFailure,
      this.isNumValid,
      this.isStreetValid});
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final bool isNumValid;
  final bool isStreetValid;
  final bool isDescribeValid;
  final bool isMoneyValid;
  final bool isAreaValid;

  PostFormState copyWith(
      {bool isSubmitting,
      bool isSuccess,
      bool isFailure,
      bool isNumValid,
      bool isDescribeValid,
      bool isMoneyValid,
      bool isAreaValid,
      bool isStreetValid}) {
    return PostFormState(
      isAreaValid: isAreaValid ?? this.isAreaValid,
      isMoneyValid: isMoneyValid ?? this.isMoneyValid,
      isDescribeValid: isDescribeValid ?? this.isDescribeValid,
      isFailure: isFailure ?? this.isFailure,
      isSuccess: isSuccess ?? this.isSuccess,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isNumValid: isNumValid ?? this.isNumValid,
      isStreetValid: isStreetValid ?? this.isStreetValid,
    );
  }

  bool get isForm1Valid => isStreetValid && isNumValid;
  bool get isForm2Valid => isMoneyValid && isAreaValid;
  bool get isForm3Valid => isStreetValid && isNumValid;
  bool get isForm4Valid => isStreetValid && isNumValid;
  PostFormState update({
    bool isNumValid,
    bool isStreetValid,
    bool isDescribeValid,
    bool isMoneyValid,
    bool isAreaValid,
  }) {
    return copyWith(
        isAreaValid: isAreaValid,
        isDescribeValid: isDescribeValid,
        isMoneyValid: isMoneyValid,
        isFailure: false,
        isSubmitting: false,
        isSuccess: false,
        isNumValid: isNumValid,
        isStreetValid: isStreetValid);
  }

  factory PostFormState.initial() {
    return PostFormState(
      isStreetValid: true,
      isNumValid: true,
      isAreaValid: true,
      isDescribeValid: true,
      isMoneyValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }
  factory PostFormState.loading() {
    return PostFormState(
      isStreetValid: true,
      isAreaValid: true,
      isDescribeValid: true,
      isMoneyValid: true,
      isNumValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }
  factory PostFormState.failure() {
    return PostFormState(
      isStreetValid: true,
      isNumValid: true,
      isAreaValid: true,
      isDescribeValid: true,
      isMoneyValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }
  factory PostFormState.success() {
    return PostFormState(
      isStreetValid: true,
      isNumValid: true,
      isAreaValid: true,
      isDescribeValid: true,
      isMoneyValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  @override
  List<Object> get props =>
      [isSubmitting, isSuccess, isFailure, isNumValid, isStreetValid, isAreaValid, isDescribeValid, isMoneyValid];
}
