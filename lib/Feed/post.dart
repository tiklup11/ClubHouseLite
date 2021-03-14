import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String ownerUid;
  String ownerName;
  String ownerAvatarUrl;
  String postUrl;
  String caption;
  String location;
  String blurHash;
  String postId;

  Post(
      {this.caption,
      this.location,
      this.ownerAvatarUrl,
      this.ownerName,
      this.ownerUid,
      this.postUrl,
      this.blurHash,
      this.postId
      });

  factory Post.from(DocumentSnapshot doc) {
    return Post(
        caption: doc.data()['caption'],
        location: doc.data()['location'],
        ownerAvatarUrl: doc.data()['ownerAvatarUrl'],
        ownerName: doc.data()['ownerName'],
        ownerUid: doc.data()['ownerId'],
        postUrl: doc.data()['postUrl'],
        blurHash: doc.data()['blurHash'],
        postId: doc.data()['postId']
        );
  }
}
