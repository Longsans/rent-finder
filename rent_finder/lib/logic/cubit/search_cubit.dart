import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class SearchCubit extends Cubit<List<String>> {
  SearchCubit() : super([]);
  void search(String q, String p) => emit([q, p]);
}
