import 'package:bloc/bloc.dart';

class StepperCubit extends Cubit<int> {
  StepperCubit() : super(0);
  void next() => emit(state + 1);
  void cancel() => emit(state - 1);
}
