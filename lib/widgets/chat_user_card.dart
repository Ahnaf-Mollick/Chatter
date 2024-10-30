import 'package:chatter/main.dart';
import 'package:chatter/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

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
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(CupertinoIcons.person),
            ),
            title: Text(widget.user.name),
            subtitle: Text(
              maxLines: 1,
              widget.user.about,
            ),
            trailing: const Text('12:00 PM'),
          ),
        ));
  }
}
