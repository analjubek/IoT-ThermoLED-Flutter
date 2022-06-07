
class IlluminationModel {
  String? link;
  String? state;
  bool? editable;
  String? type;
  String? name;
  String? label;
  String? category;
  List<String>? tags;
  List<String>? groupNames;

  IlluminationModel(
      {this.link,
        this.state,
        this.editable,
        this.type,
        this.name,
        this.label,
        this.category,
        this.tags,
        this.groupNames});

  IlluminationModel.fromJson(Map<String, dynamic> json) {
    link = json['link'];
    state = json['state'];
    editable = json['editable'];
    type = json['type'];
    name = json['name'];
    label = json['label'];
    category = json['category'];
    tags = json['tags'].cast<String>();
    groupNames = json['groupNames'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['link'] = link;
    data['state'] = state;
    data['editable'] = editable;
    data['type'] = type;
    data['name'] = name;
    data['label'] = label;
    data['category'] = category;
    data['tags'] = tags;
    data['groupNames'] = groupNames;
    return data;
  }
}


class TermostatModel {
  final int userId;
  final int id;
  final String title;

  const TermostatModel({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory TermostatModel.fromJson(Map<String, dynamic> json) {
    return TermostatModel(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}
