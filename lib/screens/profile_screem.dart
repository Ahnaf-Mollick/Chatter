import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatter/helper/dialogs.dart';
import 'package:chatter/main.dart';
import 'package:chatter/models/chat_user.dart';
import 'package:chatter/screens/auth/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../api/apis.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  List<ChatUser> list = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('User Profile'),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: FloatingActionButton.extended(
              onPressed: () async {
                Dialogs.showProgressbar(context);

                await APIs.auth.signOut().then((value) async {
                  await GoogleSignIn().signOut().then((value) {
                    Navigator.pop(context);
                    Navigator.pop(context);

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()));
                  });
                });
              },
              backgroundColor: Colors.redAccent,
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: mq.width,
                      height: mq.height * .03,
                    ),
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(mq.height * .1),
                          child: CachedNetworkImage(
                            width: mq.height * .2,
                            height: mq.height * .2,
                            fit: BoxFit.fill,
                            imageUrl: widget.user.image,
                            errorWidget: (context, url, error) =>
                                const CircleAvatar(
                              child: Icon(CupertinoIcons.person),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            onPressed: () {},
                            shape: const CircleBorder(),
                            color: Colors.white,
                            child: const Icon(
                              Icons.edit,
                              color: Colors.purple,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: mq.height * .03),
                    Text(
                      widget.user.email,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.blueGrey),
                    ),
                    SizedBox(height: mq.height * .05),
                    TextFormField(
                      initialValue: widget.user.name,
                      onSaved: (val) => APIs.me.name = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.person, color: Colors.purple),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: 'eg. John Martston',
                          label: const Text('Name')),
                    ),
                    SizedBox(height: mq.height * .03),
                    TextFormField(
                      initialValue: widget.user.about,
                      onSaved: (val) => APIs.me.about = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.info_outline_sharp,
                              color: Colors.purple),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: 'eg. Good to go with',
                          label: const Text('About')),
                    ),
                    SizedBox(height: mq.height * .05),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          APIs.updateUserInfo();
                          Dialogs.showSnackbar(context, 'Information Updated');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(mq.width * .4, mq.height * .05)),
                      icon: const Icon(
                        Icons.edit,
                        size: 25,
                      ),
                      label: const Text(
                        'Update',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
