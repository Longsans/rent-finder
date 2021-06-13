import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


class CommuneCubit extends Cubit<String> {
  CommuneCubit() : super(null);
  void selectedChange(String value) => emit(value);
}
