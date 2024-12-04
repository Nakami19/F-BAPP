class Privilege {
  final String moduleName;
  final String description;
  final String status;
  final String page;
  final String icon;
  final List<Action> actions;

  Privilege({
    required this.moduleName,
    required this.description,
    required this.status,
    required this.page,
    required this.icon,
    required this.actions,
  });

  factory Privilege.fromJson(Map<String, dynamic> json) {
    return Privilege(
      moduleName: json['moduleName'],
      description: json['description'],
      status: json['status'],
      page: json['page'],
      icon: json['icon'],
      actions: (json['actions'] as List)
          .map((actionJson) => Action.fromJson(actionJson))
          .toList(),
    );
  }
}

class Action {
  final String actionName;
  final String key;
  final String description;
  final String status;
  final String page;
  final String image;
  final bool showInMenu;
  final List<String> apis;

  Action({
    required this.actionName,
    required this.key,
    required this.description,
    required this.status,
    required this.page,
    required this.image,
    required this.showInMenu,
    required this.apis,
  });

  factory Action.fromJson(Map<String, dynamic> json) {
    return Action(
      actionName: json['actionName'],
      key: json['key'],
      description: json['description'],
      status: json['status'],
      page: json['page'],
      image: json['image'],
      showInMenu: json['showInMenu'],
      apis: List<String>.from(json['apis']),
    );
  }
}