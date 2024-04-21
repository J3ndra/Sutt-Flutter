import 'package:equatable/equatable.dart';
import 'package:user_repository/src/entities/entities.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? avatar;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
  });

  // Empty user which represents an unauthenticated user
  static const empty = UserModel(
    id: '',
    email: '',
    name: '',
    avatar: '',
  );

  // Modify UserModel parameters
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
    );
  }

  // Convenience getter to determine wether the current user is empty
  bool get isEmpty => this == UserModel.empty;

  // Convenience getter to determine wether the current user is not empty
  bool get isNotEmpty => this != UserModel.empty;

  UserEntitiy toEntity() {
    return UserEntitiy(
      id: id,
      email: email,
      name: name,
      avatar: avatar,
    );
  }

  static UserModel fromEntity(UserEntitiy entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      avatar: entity.avatar,
    );
  }

  @override
  List<Object?> get props => [id, email, name, avatar];
}