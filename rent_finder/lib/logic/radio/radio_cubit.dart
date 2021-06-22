import 'package:bloc/bloc.dart';


class RadioCubit extends Cubit<int> {
  RadioCubit() : super(0);
  void click(int a) => emit(a);
}
