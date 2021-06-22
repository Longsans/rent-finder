import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class SliderCubit extends Cubit<RangeValues> {
  SliderCubit() : super(null);
  void setValues(RangeValues val) => emit(val);
}
