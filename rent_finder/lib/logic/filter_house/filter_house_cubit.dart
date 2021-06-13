import 'package:bloc/bloc.dart';

class FilterHouseCubit extends Cubit<bool> {
  FilterHouseCubit() : super(false);
  void click() {
    emit(!state);
    } 
}
