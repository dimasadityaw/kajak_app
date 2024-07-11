class HomeModel {
  final String route;
  final String title;
  final String desc;

  HomeModel({required this.route, required this.title, required this.desc});

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      route: json['route'],
      title: json['title'],
      desc: json['desc'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'route': route,
      'title': title,
      'desc': desc,
    };
  }
}