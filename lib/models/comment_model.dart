import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:nepmeet/config/paths.dart';
import 'package:nepmeet/models/user_model.dart';

class Comment extends Equatable {
  final String id;
  final String postId;
  final User author;
  final String content;
  final DateTime date;
  final int commentLikes;

  Comment(
    @required this.id,
    @required this.postId,
    @required this.author,
    @required this.content,
    @required this.date,
    @required this.commentLikes,
  );

  @override
  List<Object> get props => [
        id,
        postId,
        author,
        content,
        date,
        commentLikes,
      ];

  Comment copyWith({
    String id,
    String postId,
    User author,
    String content,
    DateTime date,
    int commentLikes,
  }) {
    return Comment(
      id ?? this.id,
      postId ?? this.postId,
      author ?? this.author,
      content ?? this.content,
      date ?? this.date,
      commentLikes ?? this.commentLikes,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'postId': postId,
      'author':
          FirebaseFirestore.instance.collection(Paths.users).doc(author.id),
      'content': content,
      'date': Timestamp.fromDate(date),
      'commentLikes': commentLikes
    };
  }

  static Future<Comment> fromDocument(DocumentSnapshot doc) async {
    if (doc == null) return null;
    final data = doc.data();
    final authorRef = data['author'] as DocumentReference;
    if (authorRef != null) {
      final authorDoc = await authorRef.get();
      if (authorDoc.exists) {
        return Comment(
          doc.id,
          data['postId'] ?? '',
          User.fromDocument(authorDoc),
          data['content'] ?? '',
          (data['date'] as Timestamp).toDate(),
          data['commentLikes'] ?? '',
        );
      }
    }
    return null;
  }
}
