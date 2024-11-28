// models/posts_model.dart
import 'package:adna/models/comment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
int get timestampAsSecond =>
      (DateTime.now().millisecondsSinceEpoch / 1000).round();
class PostModel {
  String postOwnerName,
      description,
      urlOwnerName,
      secteur,
      uid,
      location,
      postId,
      fcmToken;
  List favorites, imagePost;
  int like, comment, share, timestamp;
  List<CommentModel> commentaires;
  final format = DateFormat('dd-MM-yyyy');
  final format2 = DateFormat('dd.MM.yyyyTHH:mm');
  
  String formatTimeStamp() {
    return format.format(
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal());
  }

  String formatTimeStamp2() {
    return format2.format(
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal());
  }

  PostModel({
    this.postId = '',
    required this.postOwnerName,
    required this.description,
    required this.urlOwnerName,
    required this.secteur,
    this.uid = '',
    required this.fcmToken,
    required this.location,
    required this.favorites,
    required this.imagePost,
    required this.like,
    required this.comment,
    required this.share,
    required this.timestamp,
    required this.commentaires,
  });

  Map<String, dynamic> toMap() => {
        'postOwnerName':postOwnerName,
        'description': description,
        'urlOwnerName': urlOwnerName,
        'secteur': secteur,
        "uid":uid,
        "location": location,
        "favorites": [],
        'imagePost': imagePost,
        'timestamp': timestampAsSecond,
        'commentaires': [],
        'fcmToken': fcmToken,
        "comment": 0,
        "share": 0,
        "like": 0
      };

  // ignore: non_constant_identifier_names
  static PostModel frompostDocumentSnapshot(DocumentSnapshot DocumentSnapshot) {
    final Map<String, dynamic> post =
        DocumentSnapshot.data() as Map<String, dynamic>;
    return PostModel(
      postId: DocumentSnapshot.id,
      postOwnerName: post["postOwnerName"],
      description: post["description"],
      urlOwnerName: post["urlOwnerName"],
      secteur: post['secteur'],
      location: post['location'],
      favorites: post['favorites'],
      imagePost: post['imagePost'],
      like: post["like"],
      comment: post['comment'],
      fcmToken: post['fcmToken'],
      share: post["share"],
      uid: post['uid'],
      timestamp: post["timestamp"],
      commentaires: [],
    );
  }

  // ignore: non_constant_identifier_names
  static List<PostModel> PostListModel(QuerySnapshot querySnapshot) {
    List<PostModel> posts = [];
    for (final post in querySnapshot.docs) {
      var postOne = frompostDocumentSnapshot(post);
      posts.add(postOne);
    } // end for
    return posts;
  }
}

Future<void> addLikePost(postId) async {
  try {
    await FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'like': FieldValue.increment(1),
    });
  } catch (e) {
    print('Error adding book: $e');
  }
}

Future<void> removeLikePost(postId) async {
  try {
    await FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'like': FieldValue.increment(-1),
    });
  } catch (e) {
    print('Error adding book: $e');
  }
}

Future<void> addFavoriteUser(postId, userId) async {
  try {
    await FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'favorites': FieldValue.arrayUnion([userId]),
    });
  } catch (e) {
    print('Error adding book: $e');
  }
}

Future<void> removeFavoriteUser(postId, userId) async {
  try {
    await FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'favorites': FieldValue.arrayRemove([userId]),
    });
  } catch (e) {
    print('Error adding book: $e');
  }
}
