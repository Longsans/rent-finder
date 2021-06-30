import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class UrlImageCubit extends Cubit<List<String>> {
  UrlImageCubit() : super(null);
  void loadUrl(List<String> url) => emit(url);
}
