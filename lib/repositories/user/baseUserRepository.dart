import 'package:nepmeet/models/models.dart';

abstract class BaseUserRepository {
  Future<User> getUserWithId({String userId});
  Future<void> updateUser({User user});
  Future<List<User>> searchUser({String query});
  void followUser({String userId, String followUserId});
  void unFollowUser({String userId, String unFollowUserId});
  Future<bool> isFollowing({String userId, String otherUserId});
}
