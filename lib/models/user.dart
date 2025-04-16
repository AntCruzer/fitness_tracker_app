// USER MODEL CLASS USED TO REPRESENT A REGISTERED USER
class User {

  // OPTIONAL USER ID FROM DATABASE (PRIMARY KEY)
  final int? id;

  // USERNAME STRING FIELD
  final String username;

  // EMAIL STRING FIELD (MUST BE UNIQUE)
  final String email;

  // PASSWORD STRING FIELD
  final String password;

  // CONSTRUCTOR TO INITIALIZE A USER INSTANCE
  User({
    this.id,                  // OPTIONAL ID
    required this.username,   // REQUIRED USERNAME
    required this.email,      // REQUIRED EMAIL
    required this.password,   // REQUIRED PASSWORD
  });

  // CONVERT USER INSTANCE TO MAP FOR STORING IN SQLITE
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
    };
  }

  // FACTORY CONSTRUCTOR TO CREATE USER INSTANCE FROM MAP
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
    );
  }
}