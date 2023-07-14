import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_wall_social_app/components/sized_box.dart';
import 'package:the_wall_social_app/components/text_field.dart';
import 'package:the_wall_social_app/helper/helper_methods.dart';

import '../components/drawer.dart';
import '../components/wall_post.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // user
  User? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  // get the current user
  void getCurrentUser() {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      setState(() {
        currentUser = auth.currentUser;
      });
    }
  }

  //text editing controllers
  final textConroller = TextEditingController();

  //sign out function
  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void postMessage() {
    //only post if there is text
    if (textConroller.text.isNotEmpty) {
      //post message
      FirebaseFirestore.instance.collection('User Posts').add({
        'UserEmail': currentUser?.email,
        'Message': textConroller.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });

      //clear text field
      textConroller.clear();
    }

    //clear text field
    setState(() {
      textConroller.clear();
    });
  }

  //go to profile page
  void goToProfilePage() {
    // pop menu drawer
    Navigator.pop(context);

    //go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          'the Wall',
        ),
        centerTitle: true,
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOutTap: signOut,
      ),
      body: Center(
        child: Column(
          children: [
            //the wall
            Expanded(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('User Posts').orderBy("TimeStamp", descending: false).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];
                        return WallPost(
                          message: post['Message'],
                          user: post['UserEmail'],
                          postId: post.id,
                          likes: List<String>.from(post['Likes'] ?? []),
                          time: formatData(post['TimeStamp']),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),

            //post a message
            Padding(
              padding: const EdgeInsets.all(25),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(controller: textConroller, hintText: "post something", obscureText: false),
                  ),
                  IconButton(
                    onPressed: postMessage,
                    icon: const Icon(
                      Icons.arrow_circle_up_outlined,
                    ),
                  ),
                ],
              ),
            ),

            // logged in as
            if (currentUser != null)
              Text(
                'Logged in as: ${currentUser!.email}',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            const MySizedBox50(),
          ],
        ),
      ),
    );
  }
}
