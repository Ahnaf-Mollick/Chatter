class ChatUser {
  String? image;
  String? about;
  String? name;
  String? createdAt;
  String? id;
  String? lastActive;
  bool? isOnline;
  String? email;
  String? pushToken;

  ChatUser(
      {this.image,
      this.about,
      this.name,
      this.createdAt,
      this.id,
      this.lastActive,
      this.isOnline,
      this.email,
      this.pushToken});

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    about = json['about'];
    name = json['name'];
    createdAt = json['created_at'];
    id = json['id'];
    lastActive = json['last_active'];
    isOnline = json['is_online'];
    email = json['email'];
    pushToken = json['push_token'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['about'] = about;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['last_active'] = lastActive;
    data['is_online'] = isOnline;
    data['email'] = email;
    data['push_token'] = pushToken;
    return data;
  }
}
