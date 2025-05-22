class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(name: json['name'], email: json['email']);

  Map<String, dynamic> toJson() => {'name': name, 'email': email};
}
