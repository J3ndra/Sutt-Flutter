part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetUser extends UserEvent {
  final String userId;

  const GetUser(this.userId);

  @override
  List<Object> get props => [userId];
}
