part of 'edit_form_cubit.dart';

enum EditStatus { loading, success, failure }

class EditFormState extends Equatable {
  const EditFormState({this.status = EditStatus.loading});
  final EditStatus status;
  EditFormState copyWith({EditStatus status}) {
    return EditFormState(status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}
