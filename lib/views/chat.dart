import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discord/helper/constants.dart';
import 'package:discord/helper/helper.dart';
import 'package:discord/services/db.dart';
import 'package:discord/views/rooms.dart';
import 'package:discord/views/search.dart';
import 'package:discord/widget/widget.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:google_fonts/google_fonts.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Stream rooms;
  String imgAssetImg;
  Random imgAsset = new Random();
  QuerySnapshot snapshot;
  Widget RoomList() {
    return StreamBuilder(
      stream: rooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return RoomTile(
                    snapshot.data.documents[index].data()['users'][1],
                    snapshot.data.documents[index].data()['userMails'][1],
                    snapshot.data.documents[index].data()['roomId'],
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
    print(imgAssetImg);
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.email = await HelperFunc.getUserEmail();
    Constants.name = await HelperFunc.getUserName();
    setState(() {});
    DBmethods().getRooms(Constants.email).then((value) {
      setState(() {
        rooms = value;
      });
    });
  }

  Widget RoomTile(String userName, String userMail, String roomId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Room(
              chatroomId: roomId,
              reciever: userName,
              reciverEmail: userMail,
            ),
          ),
        );
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(
          vertical: 25,
          horizontal: 16,
        ),
        margin: EdgeInsets.only(top: 10),
        child: Row(
          children: [
            Container(
              child: CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/images/welcome${imgAsset.nextInt(7) + 1}.jpeg',
                ),
                child: Text(
                  userName.substring(0, 1).toUpperCase(),
                  style: GoogleFonts.getFont(
                    'Chelsea Market',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName.toUpperCase(),
                  style: GoogleFonts.getFont(
                    'Chelsea Market',
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                Text(
                  userMail,
                  style: GoogleFonts.getFont(
                    'Chelsea Market',
                    fontSize: 10,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context),
      body: RoomList(),
      floatingActionButton: FloatingActionButton(
        heroTag: 'Search_btn',
        backgroundColor: Colors.orangeAccent.shade400,
        tooltip: 'Search',
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Search(),
            ),
          );
        },
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
