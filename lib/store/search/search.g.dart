// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SearchStore on SearchStoreMobx, Store {
  final _$isLoadingAtom = Atom(name: 'SearchStoreMobx.isLoading');

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

  final _$hasNextPageAtom = Atom(name: 'SearchStoreMobx.hasNextPage');

  @override
  bool get hasNextPage {
    _$hasNextPageAtom.reportRead();
    return super.hasNextPage;
  }

  @override
  set hasNextPage(bool value) {
    _$hasNextPageAtom.reportWrite(value, super.hasNextPage, () {
      super.hasNextPage = value;
    });
  }

  final _$qPageAtom = Atom(name: 'SearchStoreMobx.qPage');

  @override
  num get qPage {
    _$qPageAtom.reportRead();
    return super.qPage;
  }

  @override
  set qPage(num value) {
    _$qPageAtom.reportWrite(value, super.qPage, () {
      super.qPage = value;
    });
  }

  final _$qLimitAtom = Atom(name: 'SearchStoreMobx.qLimit');

  @override
  num get qLimit {
    _$qLimitAtom.reportRead();
    return super.qLimit;
  }

  @override
  set qLimit(num value) {
    _$qLimitAtom.reportWrite(value, super.qLimit, () {
      super.qLimit = value;
    });
  }

  final _$searchKeyAtom = Atom(name: 'SearchStoreMobx.searchKey');

  @override
  String get searchKey {
    _$searchKeyAtom.reportRead();
    return super.searchKey;
  }

  @override
  set searchKey(String value) {
    _$searchKeyAtom.reportWrite(value, super.searchKey, () {
      super.searchKey = value;
    });
  }

  final _$searchDataAtom = Atom(name: 'SearchStoreMobx.searchData');

  @override
  VodListDao get searchData {
    _$searchDataAtom.reportRead();
    return super.searchData;
  }

  @override
  set searchData(VodListDao value) {
    _$searchDataAtom.reportWrite(value, super.searchData, () {
      super.searchData = value;
    });
  }

  final _$searchListsAtom = Atom(name: 'SearchStoreMobx.searchLists');

  @override
  ObservableList<dynamic> get searchLists {
    _$searchListsAtom.reportRead();
    return super.searchLists;
  }

  @override
  set searchLists(ObservableList<dynamic> value) {
    _$searchListsAtom.reportWrite(value, super.searchLists, () {
      super.searchLists = value;
    });
  }

  final _$fetchDataAsyncAction = AsyncAction('SearchStoreMobx.fetchData');

  @override
  Future<dynamic> fetchData({@required dynamic searchKey}) {
    return _$fetchDataAsyncAction
        .run(() => super.fetchData(searchKey: searchKey));
  }

  final _$fetchMusicDataAsyncAction =
      AsyncAction('SearchStoreMobx.fetchMusicData');

  @override
  Future<dynamic> fetchMusicData(String keyword, String type) {
    return _$fetchMusicDataAsyncAction
        .run(() => super.fetchMusicData(keyword, type));
  }

  final _$SearchStoreMobxActionController =
      ActionController(name: 'SearchStoreMobx');

  @override
  void changeQuery({dynamic page, dynamic limit = 10}) {
    final _$actionInfo = _$SearchStoreMobxActionController.startAction(
        name: 'SearchStoreMobx.changeQuery');
    try {
      return super.changeQuery(page: page, limit: limit);
    } finally {
      _$SearchStoreMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeSearchKey(String key) {
    final _$actionInfo = _$SearchStoreMobxActionController.startAction(
        name: 'SearchStoreMobx.changeSearchKey');
    try {
      return super.changeSearchKey(key);
    } finally {
      _$SearchStoreMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetData() {
    final _$actionInfo = _$SearchStoreMobxActionController.startAction(
        name: 'SearchStoreMobx.resetData');
    try {
      return super.resetData();
    } finally {
      _$SearchStoreMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
hasNextPage: ${hasNextPage},
qPage: ${qPage},
qLimit: ${qLimit},
searchKey: ${searchKey},
searchData: ${searchData},
searchLists: ${searchLists}
    ''';
  }
}
