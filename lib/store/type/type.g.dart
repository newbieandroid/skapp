// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'type.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Type on TypeMobx, Store {
  final _$isLoadingAtom = Atom(name: 'TypeMobx.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$typeAtom = Atom(name: 'TypeMobx.type');

  @override
  SkType get type {
    _$typeAtom.reportRead();
    return super.type;
  }

  @override
  set type(SkType value) {
    _$typeAtom.reportWrite(value, super.type, () {
      super.type = value;
    });
  }

  final _$typeIndexAtom = Atom(name: 'TypeMobx.typeIndex');

  @override
  SkType get typeIndex {
    _$typeIndexAtom.reportRead();
    return super.typeIndex;
  }

  @override
  set typeIndex(SkType value) {
    _$typeIndexAtom.reportWrite(value, super.typeIndex, () {
      super.typeIndex = value;
    });
  }

  final _$typeAllAtom = Atom(name: 'TypeMobx.typeAll');

  @override
  ObservableList<dynamic> get typeAll {
    _$typeAllAtom.reportRead();
    return super.typeAll;
  }

  @override
  set typeAll(ObservableList<dynamic> value) {
    _$typeAllAtom.reportWrite(value, super.typeAll, () {
      super.typeAll = value;
    });
  }

  final _$movieAllAtom = Atom(name: 'TypeMobx.movieAll');

  @override
  dynamic get movieAll {
    _$movieAllAtom.reportRead();
    return super.movieAll;
  }

  @override
  set movieAll(dynamic value) {
    _$movieAllAtom.reportWrite(value, super.movieAll, () {
      super.movieAll = value;
    });
  }

  final _$currentSearchTypeIndexAtom =
      Atom(name: 'TypeMobx.currentSearchTypeIndex');

  @override
  int get currentSearchTypeIndex {
    _$currentSearchTypeIndexAtom.reportRead();
    return super.currentSearchTypeIndex;
  }

  @override
  set currentSearchTypeIndex(int value) {
    _$currentSearchTypeIndexAtom
        .reportWrite(value, super.currentSearchTypeIndex, () {
      super.currentSearchTypeIndex = value;
    });
  }

  final _$fetchDataAsyncAction = AsyncAction('TypeMobx.fetchData');

  @override
  Future<dynamic> fetchData() {
    return _$fetchDataAsyncAction.run(() => super.fetchData());
  }

  final _$fetchIndexDataAsyncAction = AsyncAction('TypeMobx.fetchIndexData');

  @override
  Future<dynamic> fetchIndexData() {
    return _$fetchIndexDataAsyncAction.run(() => super.fetchIndexData());
  }

  final _$fetchAllTypeDataAsyncAction =
      AsyncAction('TypeMobx.fetchAllTypeData');

  @override
  Future<dynamic> fetchAllTypeData() {
    return _$fetchAllTypeDataAsyncAction.run(() => super.fetchAllTypeData());
  }

  final _$fetchMovieInfoAsyncAction = AsyncAction('TypeMobx.fetchMovieInfo');

  @override
  Future<dynamic> fetchMovieInfo() {
    return _$fetchMovieInfoAsyncAction.run(() => super.fetchMovieInfo());
  }

  final _$TypeMobxActionController = ActionController(name: 'TypeMobx');

  @override
  void changeLoading() {
    final _$actionInfo =
        _$TypeMobxActionController.startAction(name: 'TypeMobx.changeLoading');
    try {
      return super.changeLoading();
    } finally {
      _$TypeMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeCurrentSearchTypeIndex(int index) {
    final _$actionInfo = _$TypeMobxActionController.startAction(
        name: 'TypeMobx.changeCurrentSearchTypeIndex');
    try {
      return super.changeCurrentSearchTypeIndex(index);
    } finally {
      _$TypeMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
type: ${type},
typeIndex: ${typeIndex},
typeAll: ${typeAll},
movieAll: ${movieAll},
currentSearchTypeIndex: ${currentSearchTypeIndex}
    ''';
  }
}
