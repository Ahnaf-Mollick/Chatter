import 'package:chatter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: mq.width * .01, vertical: 4),
        color: Colors.white70,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 1,
        child: InkWell(
          onTap: () {},
          child: const ListTile(
            leading: CircleAvatar(
              child: Icon(CupertinoIcons.person),
            ),
            title: Text('Avoy Mollick'),
            subtitle: Text(
              'Hey good to see you again',
              maxLines: 1,
            ),
            trailing: Text('12:00 PM'),
          ),
        ));
  }
}
