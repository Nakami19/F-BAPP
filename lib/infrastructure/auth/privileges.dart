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
          .map((action) => Action.fromJson(action))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'moduleName': moduleName,
      'description': description,
      'status': status,
      'page': page,
      'icon': icon,
      'actions': actions.map((action) => action.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return '''
      Privilege(
      moduleName: $moduleName,
      description: $description,
      status: $status,
      page: $page,
      icon: $icon,
      actions: [
        ${actions.map((action) => action.toString()).join(',\n      ')}
      ]
    )
    ''';
}
}

class Action {
  final String actionName;
  final String key;
  final String description;
  final String status;
  final String tagStatus;
  final String page;
  final String image;
  final bool hideAction;
  final List<String> apis;

  Action({
    required this.actionName,
    required this.key,
    required this.description,
    required this.status,
    required this.tagStatus,
    required this.page,
    required this.image,
    required this.hideAction,
    required this.apis,
  });

  factory Action.fromJson(Map<String, dynamic> json) {
    return Action(
      actionName: json['actionName'],
      key: json['key'],
      description: json['description'],
      status: json['status'],
      tagStatus: json['tag_status'],
      page: json['page'],
      image: json['image'],
      hideAction: json['hideAction'],
      apis: List<String>.from(json['apis']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'actionName': actionName,
      'key': key,
      'description': description,
      'status': status,
      'tag_status': tagStatus,
      'page': page,
      'image': image,
      'hideAction': hideAction,
      'apis': apis,
    };
  }

@override
  String toString() { 
    return '''
      Action(
      actionName: $actionName,
      key: $key,
      description: $description,
      status: $status,
      tagStatus: $tagStatus,
      page: $page,
      image: $image,
      hideAction: $hideAction,
      apis: $apis
    )
  ''';
}
}