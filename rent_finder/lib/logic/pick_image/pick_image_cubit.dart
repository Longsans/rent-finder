import 'package:bloc/bloc.dart';

import 'package:rent_finder/data/repos/user_repository.dart';

class PickImageCubit extends Cubit<String> {
  PickImageCubit({this.userRepository}) : super(null);
  final UserRepository userRepository;

  void pickImage(String pathDaiDien) async {
    emit(pathDaiDien);
  }

  void removeImage() async {
    emit(null);
  }
}
