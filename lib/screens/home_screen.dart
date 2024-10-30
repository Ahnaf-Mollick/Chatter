import 'dart:convert';

import 'package:chatter/screens/auth/login_screen.dart';
import 'package:chatter/widgets/chat_user_card.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer' as developer;
import '../api/apis.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.home),
        title: const Text('Chatter'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: FloatingActionButton(
          onPressed: () async {
            await APIs.auth.signOut();
            await GoogleSignIn().signOut();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const LoginScreen()));
          },
          backgroundColor: Colors.white70,
          child: const Icon(Icons.add_comment),
        ),
      ),
      body: StreamBuilder(
        stream: APIs.firestore.collection('user').snapshots(),
        builder: (context, snapshot) {
          final list = [];
          if (snapshot.hasData) {
            final data = snapshot.data?.docs;
            for (var i in data!) {
              developer.log('Data: ${jsonEncode(i.data())}');
              list.add(i.data()['name']);
            }
          }
          return ListView.builder(
              itemCount: list.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Text('Name:${list[index]}');
              });
        },
      ),
    );
  }
}
