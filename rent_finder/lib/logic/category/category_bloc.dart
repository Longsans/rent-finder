import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rent_finder/constants.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial());
  List<String> queries = [];
  @override
  Stream<CategoryState> mapEventToState(
    CategoryEvent event,
  ) async* {
    if (event is CategoryStarted) {
      yield* _mapCategoryStartedToState(event, state);
    } else if (event is CategoryPressed) {
      yield* _mapCategoryPressedToState(event, state);
    }
  }

  Stream<CategoryState> _mapCategoryStartedToState(
      CategoryStarted event, CategoryState state) async* {
    yield CategoryLoading();
    try {
      await Future<void>.delayed(const Duration(seconds: 2));
      yield CategoryLoaded(houses: houses);
    } catch (_) {
      yield CategoryFailure();
    }
  }

  Stream<CategoryState> _mapCategoryPressedToState(
      CategoryPressed event, CategoryState state) async* {
    if (state is CategoryLoaded) {
      try {
        if (!event.isClicked) {
          print('cc nè');
          queries = List.from(queries)..add(event.query);
        } else {
          queries = List.from(queries)..remove(event.query);
        }
        print(queries.toString());
        if (queries.length == 0) {
          yield CategoryLoaded(houses: houses);
        } else {
          List<House> tmp = houses
              .where((house) => queries.contains(house.category))
              .toList();
          print(tmp);
          yield CategoryLoaded(houses: tmp);
        }
      } on Exception {
        yield CategoryFailure();
      }
    }
  }
}
