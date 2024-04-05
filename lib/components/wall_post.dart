import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialskills/components/comment.dart';
import 'package:socialskills/components/comment_button.dart';
import 'package:socialskills/components/delete_button.dart';
import 'package:socialskills/components/like_button.dart';
import 'package:socialskills/helper/helper_methods.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;
  const WallPost({
    super.key,
    required this.message,
    required this.user,
    required this.likes,
    required this.time,
    required this.postId,
  });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  //comment text controller
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  // toggle likes
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    // Access the document in firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
      //if the post is liked, add the user's email to the 'Likes' field
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      // if the post is now unliked, remove the user's email from the 'Likes' field
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  // add a comment
  void addComment(String commentText) {
    //write the comment to firestore under the comments collection for this post
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser.email,
      "CommentTime": Timestamp.now()
    });
  }

  // show a dialog box for adding comments
  void showCommentDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Add Comment"),
              content: TextField(
                controller: _commentTextController,
                decoration: const InputDecoration(hintText: "Write a comment.."),
              ),
              actions: [
                // cancel button
                TextButton(
                  onPressed: () {
                    //pop box
                    Navigator.pop(context);

                    //clear controller
                    _commentTextController.clear();
                  },
                  child: const Text("Cancel"),
                ),

                //post button
                TextButton(
                  onPressed: () {
                    // add comment
                    addComment(_commentTextController.text);

                    //pop box
                    Navigator.pop(context);

                    //clear controller
                    _commentTextController.clear();
                  },
                  child: const Text("Post"),
                ),
              ],
            ));
  }

  // delete post
  void deletePost() {
    //show a dialog box asking for confirmation before deleting the post
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Delete Post"),
              content: const Text("Are you sure you want to delete this post?"),
              actions: [
                //CANCEL BUTTON
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),

                //DELETE BUTTON
                TextButton(
                  onPressed: () async {
                    // we have to delete the comments first
                    final commentDocs = await FirebaseFirestore.instance
                        .collection("User Posts")
                        .doc(widget.postId)
                        .collection("Comments")
                        .get();

                    for (var doc in commentDocs.docs) {
                      await FirebaseFirestore.instance
                          .collection("User Posts")
                          .doc(widget.postId)
                          .collection("Comments")
                          .doc(doc.id)
                          .delete();
                    }

                    // then delete the post
                    FirebaseFirestore.instance
                        .collection("User Posts")
                        .doc(widget.postId)
                        .delete()
                        // ignore: avoid_print
                        .then((value) => print("Post deleted"))
                        .catchError(
                            // ignore: avoid_print
                            (error) => print("Failed to delete post: $error"));

                    // dismiss the dialog
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                  child: const Text("Delete"),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //wall
          // message and user email
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                // group of text (message + user email)
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //message
                  Text(widget.message),

                  const SizedBox(height: 5),

                  //USER
                  Row(
                    children: [
                      Text(
                        widget.user,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      Text(
                        " . ",
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      Text(
                        widget.time,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),

              // delete button
               DeleteButton(onTap: deletePost) 
              
            ],
          ),

          const SizedBox(
            width: 20,
          ),

          // buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LIKE
              Column(
                children: [
                  // like button
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toggleLike,
                  ),

                  const SizedBox(height: 5),

                  // like count
                  Text(
                    widget.likes.length.toString(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(width: 10),

              // COMMENT
              Column(
                children: [
                  // comment button
                  CommentButton(onTap: showCommentDialog),

                  const SizedBox(height: 5),

                  // like count
                  const Text(
                    '0',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // comments under the posts
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("User Posts")
                  .doc(widget.postId)
                  .collection("Comments")
                  .orderBy("CommentTime", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                // show loading circle if no data yet
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs.map((doc) {
                    // get the comment
                    final commentData = doc.data() as Map<String, dynamic>;

                    // return the comment
                    return Comment(
                      text: commentData["CommentText"],
                      user: commentData["CommentedBy"],
                      time: formatDate(commentData["CommentTime"]),
                    );
                  }).toList(),
                );
              })
        ],
      ),
    );
  }
}
