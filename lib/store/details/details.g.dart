// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'details.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DetailsStore on DetailsStoreMobx, Store {
  final _$isLoadingAtom = Atom(name: 'DetailsStoreMobx.isLoading');

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

  final _$showAdAtom = Atom(name: 'DetailsStoreMobx.showAd');

  @override
  bool get showAd {
    _$showAdAtom.reportRead();
    return super.showAd;
  }

  @override
  set showAd(bool value) {
    _$showAdAtom.reportWrite(value, super.showAd, () {
      super.showAd = value;
    });
  }

  final _$isDlnaAtom = Atom(name: 'DetailsStoreMobx.isDlna');

  @override
  bool get isDlna {
    _$isDlnaAtom.reportRead();
    return super.isDlna;
  }

  @override
  set isDlna(bool value) {
    _$isDlnaAtom.reportWrite(value, super.isDlna, () {
      super.isDlna = value;
    });
  }

  final _$pickColorAtom = Atom(name: 'DetailsStoreMobx.pickColor');

  @override
  bool get pickColor {
    _$pickColorAtom.reportRead();
    return super.pickColor;
  }

  @override
  set pickColor(bool value) {
    _$pickColorAtom.reportWrite(value, super.pickColor, () {
      super.pickColor = value;
    });
  }

  final _$vodIdAtom = Atom(name: 'DetailsStoreMobx.vodId');

  @override
  String get vodId {
    _$vodIdAtom.reportRead();
    return super.vodId;
  }

  @override
  set vodId(String value) {
    _$vodIdAtom.reportWrite(value, super.vodId, () {
      super.vodId = value;
    });
  }

  final _$vodAtom = Atom(name: 'DetailsStoreMobx.vod');

  @override
  VodDao get vod {
    _$vodAtom.reportRead();
    return super.vod;
  }

  @override
  set vod(VodDao value) {
    _$vodAtom.reportWrite(value, super.vod, () {
      super.vod = value;
    });
  }

  final _$playersAtom = Atom(name: 'DetailsStoreMobx.players');

  @override
  ObservableList<dynamic> get players {
    _$playersAtom.reportRead();
    return super.players;
  }

  @override
  set players(ObservableList<dynamic> value) {
    _$playersAtom.reportWrite(value, super.players, () {
      super.players = value;
    });
  }

  final _$pTabsAtom = Atom(name: 'DetailsStoreMobx.pTabs');

  @override
  ObservableList<dynamic> get pTabs {
    _$pTabsAtom.reportRead();
    return super.pTabs;
  }

  @override
  set pTabs(ObservableList<dynamic> value) {
    _$pTabsAtom.reportWrite(value, super.pTabs, () {
      super.pTabs = value;
    });
  }

  final _$vipListsAtom = Atom(name: 'DetailsStoreMobx.vipLists');

  @override
  ObservableList<dynamic> get vipLists {
    _$vipListsAtom.reportRead();
    return super.vipLists;
  }

  @override
  set vipLists(ObservableList<dynamic> value) {
    _$vipListsAtom.reportWrite(value, super.vipLists, () {
      super.vipLists = value;
    });
  }

  final _$currentTabsAtom = Atom(name: 'DetailsStoreMobx.currentTabs');

  @override
  int get currentTabs {
    _$currentTabsAtom.reportRead();
    return super.currentTabs;
  }

  @override
  set currentTabs(int value) {
    _$currentTabsAtom.reportWrite(value, super.currentTabs, () {
      super.currentTabs = value;
    });
  }

  final _$currentPlayersAtom = Atom(name: 'DetailsStoreMobx.currentPlayers');

  @override
  int get currentPlayers {
    _$currentPlayersAtom.reportRead();
    return super.currentPlayers;
  }

  @override
  set currentPlayers(int value) {
    _$currentPlayersAtom.reportWrite(value, super.currentPlayers, () {
      super.currentPlayers = value;
    });
  }

  final _$isClickPlayersAtom = Atom(name: 'DetailsStoreMobx.isClickPlayers');

  @override
  bool get isClickPlayers {
    _$isClickPlayersAtom.reportRead();
    return super.isClickPlayers;
  }

  @override
  set isClickPlayers(bool value) {
    _$isClickPlayersAtom.reportWrite(value, super.isClickPlayers, () {
      super.isClickPlayers = value;
    });
  }

  final _$currentUrlAtom = Atom(name: 'DetailsStoreMobx.currentUrl');

  @override
  String get currentUrl {
    _$currentUrlAtom.reportRead();
    return super.currentUrl;
  }

  @override
  set currentUrl(String value) {
    _$currentUrlAtom.reportWrite(value, super.currentUrl, () {
      super.currentUrl = value;
    });
  }

  final _$fetchVodDataAsyncAction =
      AsyncAction('DetailsStoreMobx.fetchVodData');

  @override
  Future<dynamic> fetchVodData() {
    return _$fetchVodDataAsyncAction.run(() => super.fetchVodData());
  }

  final _$setCurrentUrlAsyncAction =
      AsyncAction('DetailsStoreMobx.setCurrentUrl');

  @override
  Future<dynamic> setCurrentUrl(String status) {
    return _$setCurrentUrlAsyncAction.run(() => super.setCurrentUrl(status));
  }

  final _$DetailsStoreMobxActionController =
      ActionController(name: 'DetailsStoreMobx');

  @override
  void changeShowAd(bool showAd) {
    final _$actionInfo = _$DetailsStoreMobxActionController.startAction(
        name: 'DetailsStoreMobx.changeShowAd');
    try {
      return super.changeShowAd(showAd);
    } finally {
      _$DetailsStoreMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  void formatPD(String vodPlayUrl) {
    final _$actionInfo = _$DetailsStoreMobxActionController.startAction(
        name: 'DetailsStoreMobx.formatPD');
    try {
      return super.formatPD(vodPlayUrl);
    } finally {
      _$DetailsStoreMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  void formatPDTbas(String vodPlayFrom) {
    final _$actionInfo = _$DetailsStoreMobxActionController.startAction(
        name: 'DetailsStoreMobx.formatPDTbas');
    try {
      return super.formatPDTbas(vodPlayFrom);
    } finally {
      _$DetailsStoreMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeVodId(String vodId) {
    final _$actionInfo = _$DetailsStoreMobxActionController.startAction(
        name: 'DetailsStoreMobx.changeVodId');
    try {
      return super.changeVodId(vodId);
    } finally {
      _$DetailsStoreMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changePickColor(bool v) {
    final _$actionInfo = _$DetailsStoreMobxActionController.startAction(
        name: 'DetailsStoreMobx.changePickColor');
    try {
      return super.changePickColor(v);
    } finally {
      _$DetailsStoreMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeCurrentTabs(int current) {
    final _$actionInfo = _$DetailsStoreMobxActionController.startAction(
        name: 'DetailsStoreMobx.changeCurrentTabs');
    try {
      return super.changeCurrentTabs(current);
    } finally {
      _$DetailsStoreMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeCurrentPlayers(int current) {
    final _$actionInfo = _$DetailsStoreMobxActionController.startAction(
        name: 'DetailsStoreMobx.changeCurrentPlayers');
    try {
      return super.changeCurrentPlayers(current);
    } finally {
      _$DetailsStoreMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeIsClickPlayers() {
    final _$actionInfo = _$DetailsStoreMobxActionController.startAction(
        name: 'DetailsStoreMobx.changeIsClickPlayers');
    try {
      return super.changeIsClickPlayers();
    } finally {
      _$DetailsStoreMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeDlna(bool v) {
    final _$actionInfo = _$DetailsStoreMobxActionController.startAction(
        name: 'DetailsStoreMobx.changeDlna');
    try {
      return super.changeDlna(v);
    } finally {
      _$DetailsStoreMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  void playNext() {
    final _$actionInfo = _$DetailsStoreMobxActionController.startAction(
        name: 'DetailsStoreMobx.playNext');
    try {
      return super.playNext();
    } finally {
      _$DetailsStoreMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
showAd: ${showAd},
isDlna: ${isDlna},
pickColor: ${pickColor},
vodId: ${vodId},
vod: ${vod},
players: ${players},
pTabs: ${pTabs},
vipLists: ${vipLists},
currentTabs: ${currentTabs},
currentPlayers: ${currentPlayers},
isClickPlayers: ${isClickPlayers},
currentUrl: ${currentUrl}
    ''';
  }
}
