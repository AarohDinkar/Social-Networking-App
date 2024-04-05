import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialskills/components/drawer.dart';
import 'package:socialskills/components/textfield.dart';
import 'package:socialskills/components/wall_post.dart';
import 'package:socialskills/helper/helper_methods.dart';
import 'package:socialskills/pages/intro_page.dart';
import 'package:socialskills/pages/message_home.dart';
import 'package:socialskills/pages/profile.dart';

class HomePage extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // user
  final user = FirebaseAuth.instance.currentUser!;

  // text controller
  final textController = TextEditingController();

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  // post message
  void postMessage() {
    // only post if there is something in the textfield
    if (textController.text.isNotEmpty) {
      // strore in firebase
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': user.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }

    // clear the textfiled
    setState(() {
      textController.clear();
    });
  }

  // navigate to intro page
  void gotoIntroPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const IntroPage(),
      ),
    );
  }

  // navigate to profile page
  void goToProfilePage() {
    // pop menu drawer
    Navigator.pop(context);

    // go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  // go to chat home page
  void goToChatHome() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MessageHome(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text("Skill Exchange"),
          actions: [
            IconButton(
                onPressed: goToChatHome, icon: const Icon(Icons.message),),
            IconButton(onPressed: gotoIntroPage, icon: const Icon(Icons.add),),    
          ],
        ),
        drawer: MyDrawer(
          onProfileTap: goToProfilePage,
          onSignOut: signUserOut,
        ),
        body: Center(
          child: Column(
            children: [
              // post page section
              Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("User Posts")
                          .orderBy("TimeStamp", descending: false)
                          .snapshots(),
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
                                likes: List<String>.from(post['Likes'] ?? {}),
                                time: formatDate(post['TimeStamp']),
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('error:${snapshot.error}'),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      })),
              // post message

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    // textfield
                    Expanded(
                      child: MyTextField(
                        controller: textController,
                        hintText: "Write something..",
                        obscureText: false,
                      ),
                    ),

                    // post button
                    IconButton(
                      onPressed: postMessage,
                      icon: const Icon(Icons.arrow_circle_up),
                    ),
                  ],
                ),
              ),
              // logged in as
              Text(
                "Logged in as: ${user.email!}",
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(
                height: 30,
              )
            ],
          ),
        ));
  }
}
