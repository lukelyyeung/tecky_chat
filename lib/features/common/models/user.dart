class User {
  final String id;
  final String displayName;
  final String? profileUrl;

  const User({required this.id, required this.displayName, this.profileUrl});

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'displayName': displayName,
      'profileUrl': profileUrl,
    };
  }

  static const empty = User(displayName: '', id: '');

  User.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        displayName = json['displayName'],
        profileUrl = json['profileUrl'];
}
