import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/src/models/models.dart';

abstract class UserRepository {
  Stream<User?> get user;
  Future<void> signIn(String email, String password);
  Future<UserModel> signUp(UserModel userModel, String password);
  Future<void> signOut();
  Future<void> setUserData(UserModel userModel);
  Future<UserModel> getUserData(String userId);
}