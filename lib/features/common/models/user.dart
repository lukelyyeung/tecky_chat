class User {
  final String id;
  final String displayName;
  final String? profileUrl;

  const User({required this.id, required this.displayName, this.profileUrl});

  static const empty = User(displayName: '', id: '');
}
