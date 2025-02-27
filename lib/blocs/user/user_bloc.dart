import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;

  UserBloc({
    required UserRepository myUserRepository,
  }) : _userRepository = myUserRepository, super(const UserState.loading()) {
    on<GetUser>((event, emit) async {
      try {
        UserModel userModel = await _userRepository.getUserData(event.userId);
        emit(UserState.success(userModel));
      } catch (e) {
        log(e.toString());
        emit(const UserState.failure());
      }
    });
  }
}
