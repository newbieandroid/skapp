class AppAdsDao {
  Loading loading;
  Splash splash;
  Splash prestrain;
  Pause pause;

  AppAdsDao({this.loading, this.splash, this.prestrain, this.pause});

  AppAdsDao.fromJson(Map<String, dynamic> json) {
    loading =
        json['loading'] != null ? new Loading.fromJson(json['loading']) : null;
    splash =
        json['splash'] != null ? new Splash.fromJson(json['splash']) : null;
    prestrain = json['prestrain'] != null
        ? new Splash.fromJson(json['prestrain'])
        : null;
    pause = json['pause'] != null ? new Pause.fromJson(json['pause']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.loading != null) {
      data['loading'] = this.loading.toJson();
    }
    if (this.splash != null) {
      data['splash'] = this.splash.toJson();
    }
    if (this.prestrain != null) {
      data['prestrain'] = this.prestrain.toJson();
    }
    if (this.pause != null) {
      data['pause'] = this.pause.toJson();
    }
    return data;
  }
}

class Loading {
  bool show;
  int timer;

  Loading({this.show, this.timer});

  Loading.fromJson(Map<String, dynamic> json) {
    show = json['show'];
    timer = json['timer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['show'] = this.show;
    data['timer'] = this.timer;
    return data;
  }
}

class Splash {
  bool show;
  int timer;
  String type;
  String src;
  String href;

  Splash({this.show, this.timer, this.type, this.src, this.href});

  Splash.fromJson(Map<String, dynamic> json) {
    show = json['show'];
    timer = json['timer'];
    type = json['type'];
    src = json['src'];
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['show'] = this.show;
    data['timer'] = this.timer;
    data['type'] = this.type;
    data['src'] = this.src;
    data['href'] = this.href;
    return data;
  }
}

class Pause {
  bool show;
  String type;
  String src;
  String href;

  Pause({this.show, this.type, this.src, this.href});

  Pause.fromJson(Map<String, dynamic> json) {
    show = json['show'];
    type = json['type'];
    src = json['src'];
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['show'] = this.show;
    data['type'] = this.type;
    data['src'] = this.src;
    data['href'] = this.href;
    return data;
  }
}
