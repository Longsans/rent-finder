import 'package:bloc/bloc.dart';

class DropButtonCubit extends Cubit<String> {
  DropButtonCubit() : super(null);
  void selectedChange(String value) => emit(value);
}
