import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';



class DistrictCubit extends Cubit<String> {
  DistrictCubit() : super(null);
  void selectedChange(String value) => emit(value);
}
