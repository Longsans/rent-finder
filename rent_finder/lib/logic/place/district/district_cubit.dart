import 'package:bloc/bloc.dart';




class DistrictCubit extends Cubit<String> {
  DistrictCubit() : super(null);
  void selectedChange(String value) => emit(value);
}
