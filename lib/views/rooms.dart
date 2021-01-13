import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discord/helper/constants.dart';
import 'package:discord/services/db.dart';
import 'package:discord/widget/widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Room extends StatefulWidget {
  final String chatroomId;
  final String reciever;
  final String reciverEmail;
  Room({this.chatroomId, this.reciever, this.reciverEmail});
  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
  TextEditingController message = new TextEditingController();
  Stream messages;
  final formKey = GlobalKey<FormState>();
  DBmethods dBmethods = new DBmethods();
  sendMsg() {
    if (message.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': message.text,
        'reciever': widget.reciever,
        'recieverEmai': widget.reciverEmail,
        'sentBy': Constants.name,
        'sentEmail': Constants.email,
        'timestamp': FieldValue.serverTimestamp(),
      };
      dBmethods.addMessage(widget.chatroomId, messageMap);
      message.text = '';
    }
  }

  // ignore: non_constant_identifier_names
  Widget ChatList() {
    return StreamBuilder(
      stream: messages,
      builder: (BuildContext context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                padding: EdgeInsets.only(bottom: 150),
                // ignore: missing_return
                itemBuilder: (context, index) {
                  return MessageTile(
                    snapshot.data.documents[index].data()['message'],
                    Constants.email ==
                            snapshot.data.documents[index].data()['sentEmail']
                        ? true
                        : false,
                  );
                },
              )
            : Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
      },
    );
  }

  @override
  void initState() {
    dBmethods.getMessages(widget.chatroomId).then((snapshots) {
      setState(() {
        messages = snapshots;
      });
    });
    super.initState();
  }

  Widget MessageTile(String message, final bool sentByAppUser) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: MediaQuery.of(context).size.width,
      alignment: sentByAppUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 26),
        decoration: BoxDecoration(
            gradient: sentByAppUser
                ? LinearGradient(
                    colors: [
                      const Color.fromRGBO(255, 153, 0, 1),
                      const Color.fromRGBO(255, 145, 0, 1),
                    ],
                  )
                : LinearGradient(
                    colors: [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)],
                  ),
            borderRadius: sentByAppUser
                ? BorderRadius.only(
                    topLeft: Radius.circular(500),
                    bottomLeft: Radius.circular(500),
                    topRight: Radius.circular(500),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(500),
                    bottomRight: Radius.circular(500),
                    topRight: Radius.circular(500),
                  )),
        child: Text(
          message,
          style: GoogleFonts.getFont(
            'Chelsea Market',
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent.shade400,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Image.asset(
                'assets/images/discord.jpeg',
                height: 40,
              ),
            ),
            Text(
              'Discord',
              style: GoogleFonts.getFont(
                'Chelsea Market',
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            ChatList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x19FFFFFF),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: message,
                        decoration: InputDecoration(
                          hintText: 'Type a message.......',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                        style: GoogleFonts.getFont('Chelsea Market',
                            color: Colors.white),
                      ),
                    ),
                    Container(
                      child: FloatingActionButton(
                        tooltip: 'Send',
                        backgroundColor: Colors.grey,
                        onPressed: () {
                          sendMsg();
                        },
                        child: Icon(Icons.send),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
