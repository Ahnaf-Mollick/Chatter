import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatter/main.dart';
import 'package:chatter/models/chat_user.dart';
import 'package:chatter/models/message.dart';
import 'package:chatter/widgets/message_card.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../api/apis.dart';
import '../helper/dialogs.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  File? _image;
  List<Message> _list = [];
  final _textController = TextEditingController();
  bool _showEmoji = false, _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if (_showEmoji) {
              setState(() {
                _showEmoji = !_showEmoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white70,
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),
            backgroundColor: const Color.fromARGB(255, 195, 229, 250),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: APIs.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();
                        // TODO: Handle this case.
                        case ConnectionState.active:
                        // TODO: Handle this case.
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _list = data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                                itemCount: _list.length,
                                reverse: true,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return MessageCard(
                                    message: _list[index],
                                  );
                                });
                          } else {
                            return const Center(
                              child: Text(
                                "Say Hi!👋",
                                style:
                                    TextStyle(fontSize: 30, color: Colors.grey),
                              ),
                            );
                          }
                      } //Switch
                    },
                  ),
                ),
                if (_isUploading)
                  const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.lightBlueAccent))),
                _chatInput(),
                if (_showEmoji)
                  SizedBox(
                    height: mq.height * 0.33,
                    child: EmojiPicker(
                      textEditingController: _textController,
                      // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                      config: Config(
                        emojiViewConfig: EmojiViewConfig(
                          backgroundColor:
                              const Color.fromARGB(255, 195, 229, 250),
                          columns: 7,
                          emojiSizeMax: 28 * (Platform.isIOS ? 1.20 : 1.0),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.black87,
              )),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CachedNetworkImage(
              width: mq.height * .05,
              height: mq.height * .05,
              fit: BoxFit.cover,
              imageUrl: widget.user.image,
              errorWidget: (context, url, error) => const CircleAvatar(
                child: Icon(CupertinoIcons.person),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 2),
              const Text(
                'Last Seen Not Available',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          _showEmoji = !_showEmoji;
                        });
                      },
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Colors.lightBlueAccent,
                        size: 25,
                      )),
                  Expanded(
                      child: TextField(
                    keyboardType: TextInputType.multiline,
                    controller: _textController,
                    maxLines: null,
                    onTap: () {
                      setState(() {
                        if (_showEmoji) _showEmoji = !_showEmoji;
                      });
                    },
                    decoration: const InputDecoration(
                        hintText: 'Type Something....',
                        hintStyle: TextStyle(
                            color: Colors.lightBlueAccent, fontSize: 13),
                        border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final List<XFile> images =
                            await picker.pickMultiImage(imageQuality: 70);
                        for (var i in images) {
                          setState(() {
                            _isUploading = true;
                          });
                          await APIs.sendChatImage(widget.user, File(i.path));
                          setState(() {
                            _isUploading = false;
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.image,
                        color: Colors.lightBlueAccent,
                        size: 26,
                      )),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          setState(() {
                            _isUploading = true;
                          });
                          await APIs.sendChatImage(
                              widget.user, File(image.path));
                          setState(() {
                            _isUploading = false;
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.lightBlueAccent,
                        size: 26,
                      )),
                  const SizedBox(width: 5)
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textController.text, Type.text);
                _textController.text = '';
              }
            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 8),
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(
              Icons.send_rounded,
              color: Colors.white,
              size: 28,
            ),
          )
        ],
      ),
    );
  }
}
