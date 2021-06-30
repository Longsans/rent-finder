import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rent_finder_hi/data/models/models.dart';
import 'package:rent_finder_hi/data/repos/repos.dart';

part 'edit_form_state.dart';

class EditFormCubit extends Cubit<EditFormState> {
  EditFormCubit() : super(EditFormState());
  void submitForm(House updatedHouse, List<File> housePictures) async {
    emit(state.copyWith(status: EditStatus.loading));
    try {
      await HouseRepository().updateHouse(updatedHouse, housePictures);
      emit(state.copyWith(status: EditStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditStatus.failure));
    }
  }
}
