// models/comment_model.dart
// models/comment_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String photoURL, displayName, message, userId;
  List imagePost;
  int like;
  int dislike;
  int commentCount;
  int timestamp;
  String commentId;
  CommentModel(
      {required this.timestamp,
      required this.commentCount,
      this.commentId = '',
      required this.dislike,
      required this.displayName,
      required this.imagePost,
      required this.like,
      required this.message,
      required this.photoURL,
      this.userId = ''});

  Map<String, dynamic> toMap() => {
        'displayName': displayName,
        'photoURL': photoURL,
        'message': message,
        'userId': userId,
        "imagePost": imagePost,
        "like": like,
        "dislike": dislike,
        'commentCount': commentCount,
        "timestamp": timestamp,
      };

  // ignore: non_constant_identifier_names
  static CommentModel fromCommentDocumentSnapshot(
      DocumentSnapshot DocumentSnapshot) {
    final Map<String, dynamic> post =
        DocumentSnapshot.data() as Map<String, dynamic>;
    return CommentModel(
        commentId: DocumentSnapshot.id,
        displayName: post["displayName"],
        photoURL: post["photoURL"],
        message: post["message"],
        userId: post['userId'],
        imagePost: post['imagePost'],
        like: post['like'],
        dislike: post['dislike'],
        commentCount: post["commentCount"],
        timestamp: post["timestamp"]);
  }

  // ignore: non_constant_identifier_names
  static List<CommentModel> CommentListModel(QuerySnapshot querySnapshot) {
    List<CommentModel> commentaires = [];
    for (final comment in querySnapshot.docs) {
      var commentOne = fromCommentDocumentSnapshot(comment);
      commentaires.add(commentOne);
    } // end for
    return commentaires;
  }
}

Future<void> addUserComment(postId, comment) async {
  try {
    await FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'commentaires': FieldValue.arrayUnion(
        [comment],
      ),
      'comment': FieldValue.increment(1),
    });
  } catch (e) {
    print('Error adding user comment: $e');
  }
}

Future<void> removeUserComment(postId, comment) async {
  try {
    await FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'commentaires': FieldValue.arrayRemove([comment]),
      'comment': FieldValue.increment(-1),
    });
  } catch (e) {
    print('Error removing user comment: $e');
  }
}
