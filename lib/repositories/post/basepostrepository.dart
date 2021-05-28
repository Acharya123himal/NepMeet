import 'package:nepmeet/models/models.dart';

abstract class BasePostRepository {
  Future<void> createPost({Post post});
  Future<void> createComment({Comment comment});
  Stream<List<Future<Post>>> getUserPost({String userId});
  Stream<List<Future<Comment>>> getUserComment({String postId});
}
