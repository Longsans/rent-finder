import 'package:bloc/bloc.dart';

class CategoryCubit extends Cubit<String> {
  CategoryCubit() : super(null);
  void click(String s) => emit(s);
}
