import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_wall_social_app/components/comment.dart';
import 'package:the_wall_social_app/components/delete_button.dart';
import 'package:the_wall_social_app/components/sized_box.dart';

import '../helper/helper_methods.dart';
import 'comment_button.dart';
import 'like_button.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final String time;

  final List<String> likes; //emails of users who liked the post

  const WallPost({
    Key? key, // Added Key? key parameter
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
    required this.time,
  }) : super(key: key); // Added super with key parameter

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  // comment text controller
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  //toggle like
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      // toggle isLiked

      // access the post document in Firebase
      DocumentReference postRef = FirebaseFirestore.instance
          .collection('User Posts')
          .doc(widget.postId);

      if (isLiked) {
        // add user email to likes list
        postRef.update({
          'Likes': FieldValue.arrayUnion([currentUser.email])
        });
      } else {
        // remove user email from likes list
        postRef.update({
          'Likes': FieldValue.arrayRemove([currentUser.email])
        });
      }
    });
  }

  // add a comment to the post
  void addComment(String commentText) {
    // write comment to Firestore under the comments collection
    FirebaseFirestore.instance
        .collection('User Posts')
        .doc(widget.postId)
        .collection('Comments')
        .add({
      'CommentText': commentText,
      'CommentedBy': currentUser.email,
      'CommentTime': Timestamp.now(), // remember to format this when displaying
    });
  }

  // show a dialog for adding comment text
  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Comment'),
        content: TextField(
          controller: _commentTextController,
          decoration: const InputDecoration(
            hintText: 'Add comment',
          ),
        ),
        actions: [
          // Close button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: const Text('Close'),
          ),
          // Post button
          TextButton(
              onPressed: () {
                // Post text
                addComment(_commentTextController.text);
                // Added Navigator.pop to close the dialog
                Navigator.pop(context);
                _commentTextController.clear();
              },
              child: const Text('Post')),
        ],
      ),
    );
  }

  // delete post
  void deletePost() {
    // SHOW A DIALOG BOX TO CONFIRM DELETION
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          // CANCEL BUTTON
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
            ),
          ),

          // DELETE BUTTON
          TextButton(
            onPressed: () async {
              // DELETE POST FROM FIRESTORE
              // (if you only delete the post, there are still comments in the firestore)
              // SO WE NEED TOGET AND DELETE THE COMMENTS FIRST
              final commentDocs = await FirebaseFirestore.instance
                  .collection('User Posts')
                  .doc(widget.postId)
                  .collection('Comments')
                  .get();

              for (var doc in commentDocs.docs) {
                await FirebaseFirestore.instance
                    .collection('User Posts')
                    .doc(widget.postId)
                    .collection('Comments')
                    .doc(doc.id)
                    .delete();
                // doc.reference.delete();
              }

              // DELETE POST FROM STORAGE
              FirebaseFirestore.instance
                  .collection('User Posts')
                  .doc(widget.postId)
                  .delete()
                  .then((value) => print('post deleted'))
                  .catchError(
                      (error) => print('Failed to delete post: $error'));

              // CLOSE DIALOG
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: Theme.of(context).colorScheme.primary,
      ),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  WALL_POST
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // GROUP OF TEXT (COMMENT, USER, TIME)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Comment
                  Text(widget.message),
                  const MySizedBox10(),
                  // User
                  Row(
                    children: [
                      Text(widget.user,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary)),
                      Text(' : ',
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.bold)),
                      Text(widget.time,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary)),
                    ],
                  ),
                ],
              ),

              // DELETE BUTTON
              if (widget.user == currentUser.email)
                DeleteButton(onTap: deletePost)
            ],
          ),
          const MySizedBox25(),

          // BUTTONS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LIKE
              Column(
                children: [
                  // LIKE BUTTON
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toggleLike,
                  ),
                  // LIKE COUNT
                  const MySizedBox10(),
                  Text(
                    widget.likes.length.toString(),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                ],
              ),
              // COMMENT
              Column(
                children: [
                  // comment button
                  CommentButton(onTap: showCommentDialog),
                  // comment count
                  const MySizedBox10(),
                  Text(
                    '0',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                ],
              ),
            ],
          ),
          const MySizedBox10(),

          // COMMENTS
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('User Posts')
                .doc(widget.postId)
                .collection('Comments')
                .orderBy('CommentTime', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              // SHOW PROGRESS INDICATOR IF NO DATA YET - ELSE SHOW COMMENTS
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  //get the comment
                  final commentData = doc.data() as Map<String, dynamic>;

                  //RETURN COMMENT WIDGET
                  return Comment(
                    text: commentData['CommentText'],
                    user: commentData['CommentedBy'],
                    time: formatData(commentData['CommentTime']),
                  );
                }).toList(),
              );
            },
          )
        ],
      ),
    );
  }
}
