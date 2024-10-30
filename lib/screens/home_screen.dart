import 'package:chatter/models/chat_user.dart';
import 'package:chatter/screens/auth/login_screen.dart';
import 'package:chatter/screens/profile_screem.dart';
import 'package:chatter/widgets/chat_user_card.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../api/apis.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.home),
        title: const Text('Chatter'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProfileScreen(user: list[0])));
              },
              icon: const Icon(Icons.more_vert)),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.white70,
          child: const Icon(Icons.add_comment),
        ),
      ),
      body: StreamBuilder(
        stream: APIs.firestore.collection('user').snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(child: CircularProgressIndicator());
            // TODO: Handle this case.
            case ConnectionState.active:
            // TODO: Handle this case.
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

              if (list.isNotEmpty) {
                return ListView.builder(
                    itemCount: list.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ChatUserCard(user: list[index]);
                      //return Text('Name:${list[index]}');
                    });
              } else {
                return const Center(
                  child: Text(
                    "No Contacts",
                    style: TextStyle(fontSize: 30, color: Colors.grey),
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
