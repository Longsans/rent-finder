import 'package:bloc/bloc.dart';



class CommuneCubit extends Cubit<String> {
  CommuneCubit() : super(null);
  void selectedChange(String value) => emit(value);
}
