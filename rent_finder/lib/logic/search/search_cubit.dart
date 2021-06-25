import 'package:bloc/bloc.dart';


class SearchCubit extends Cubit<List<String>> {
  SearchCubit() : super([]);
  void search(String q, String p) => emit([q, p]);
}
