import 'package:bloc/bloc.dart';

import 'package:rent_finder/data/models/models.dart' as model;
import 'package:rent_finder/data/repos/user_repository.dart';

class PickImageCubit extends Cubit<model.User> {
  PickImageCubit({this.userRepository}) : super(model.User());
  final UserRepository userRepository;
  void start(model.User user) {
    emit(user);
  }

  void pickImage(String pathDaiDien, model.User user) async {
    state.urlHinhDaiDien = await userRepository.getDownURL(
        pathHinhDaiDien: pathDaiDien, user: user);
    emit(state);
  }
}
