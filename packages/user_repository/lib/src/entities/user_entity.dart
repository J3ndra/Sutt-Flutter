import 'package:equatable/equatable.dart';

class UserEntitiy extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? avatar;

  const UserEntitiy({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
  });

  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
    };
  }

  static UserEntitiy fromDocument(Map<String, dynamic> document) {
    final data = document;

    return UserEntitiy(
      id: data['id'],
      email: data['email'],
      name: data['name'],
      avatar: data['avatar'],
    );
  }

  @override
  List<Object?> get props => [id, email, name, avatar];

  @override
  String toString() {
    return '''UserEntity {
      id: $id,
      email: $email,
      name: $name,
      avatar: $avatar,
    }''';
  }
}