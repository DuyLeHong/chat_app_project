import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VideoServices {
  static likeVideo(String id) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('videos').doc(id).get();
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await FirebaseFirestore.instance.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await FirebaseFirestore.instance.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  static likeComment(String videoID, String Commentid) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('videos')
        .doc(videoID)
        .collection('commentList')
        .doc(Commentid)
        .get();
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(videoID)
          .collection('commentList')
          .doc(Commentid)
          .update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(videoID)
          .collection('commentList')
          .doc(Commentid)
          .update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  static checkLike(String id) {}
}
