import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'welcome_screen.dart';

final _cloud = Firestore.instance;

FirebaseUser loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String route = '/chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;

  final textMessageController = TextEditingController();

  String text;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCurrentUserName();
  }

  void getCurrentUserName() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void messageStream() async {
    await for (var snapshot in _cloud.collection('messages').snapshots()) {
      for (var message in snapshot.documents) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pushNamed(context, WelcomeScreen.route);
              }),
        ],
        title: Text('Group Chat'),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textMessageController,
                      onChanged: (value) {
                        //Do something with the user input.
                        text = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                      textMessageController.clear();
                      _cloud
                          .collection('messages')
                          .add({'sender': loggedInUser.email, 'text': text});
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _cloud.collection('messages').snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MessageBubble> messageBubbles = [];
          final messages = snapshot.data.documents.reversed;
          for (var message in messages) {
            final messageText = message.data['text'];
            final sender = message.data['sender'];
            final currentUser = loggedInUser.email;

            final messageBubble = MessageBubble(
              sender: sender,
              text: messageText,
              isMe: sender == currentUser,
            );
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              children: messageBubbles,
            ),
          );
        }
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;

  final String text;

  final bool isMe;

  MessageBubble({this.sender, this.text, this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.00,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.00),
                topRight: Radius.circular(30.00),
                bottomLeft:
                    isMe ? Radius.circular(30.00) : Radius.circular(00.00),
                bottomRight:
                    isMe ? Radius.circular(00.00) : Radius.circular(30.00)),
            elevation: 5.0,
            color: isMe ? Colors.blueAccent : Colors.white70,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.00, vertical: 10.00),
              child: Text(
                '$text',
                style: TextStyle(
                  fontSize: 15.0,
                  color: isMe ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
