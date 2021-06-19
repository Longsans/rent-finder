import 'dart:io';

import 'package:bloc/bloc.dart';


import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PickMultiImageCubit extends Cubit<List<File>> {
  PickMultiImageCubit() : super([]);
  void pickImages(List<AssetEntity> list) async {
    List<File> result = [];
    if (list == null) {
      emit(state);
      return;
    }
    for (int i = 0; i < list.length; i++) {
      File t = await list[i].originFile;
      result.add(t);
    }
    emit(result);
  }
}
