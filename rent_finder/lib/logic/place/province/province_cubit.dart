import 'package:bloc/bloc.dart';


class ProvinceCubit extends Cubit<String> {
  ProvinceCubit() : super(null);
  void selectedChange(String value) => emit(value);
}
