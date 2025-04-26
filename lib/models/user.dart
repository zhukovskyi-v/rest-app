class User {
  final int? id;
  final String email;
  final String password;
  final String? name;
  final int createdAt;
  
  User({
    this.id,
    required this.email,
    required this.password,
    this.name,
    int? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;
  
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'email': email,
      'password': password,
      'name': name,
      'created_at': createdAt,
    };
  }
  
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      name: map['name'],
      createdAt: map['created_at'],
    );
  }
}