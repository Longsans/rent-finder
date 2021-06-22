import 'package:bloc/bloc.dart';

class EnableCubit extends Cubit<bool> {
  EnableCubit() : super(false);
  void click() {
    emit(!state);
    } 
}
