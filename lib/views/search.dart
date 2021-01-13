// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discord/helper/constants.dart';
import 'package:discord/helper/helper.dart';
import 'package:discord/services/db.dart';
// ignore: unused_import
import 'package:discord/views/chat.dart';
import 'package:discord/views/rooms.dart';
// ignore: unused_import
import 'package:discord/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DBmethods dBmethods = new DBmethods();
  TextEditingController userName = new TextEditingController();
  String userEmail;
  QuerySnapshot searchSnapshot;

  initSearch() {
    dBmethods.getUsers(userName.text).then((value) {
      if (value.docs[0].data()['email'] != Constants.email) {
        setState(() {
          userEmail = value.docs[0].data()['email'];
          searchSnapshot = value;
        });
      } else if (value == null ||
          value.docs[0].data()['email'] == Constants.email) {
        setState(() {
          searchSnapshot = null;
        });
      } else {
        setState(() {
          searchSnapshot = null;
        });
      }
    });
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (context, index) {
              return SearchTile(
                userEmail: searchSnapshot.docs[0].data()['email'],
                userName: searchSnapshot.docs[0].data()['userName'],
              );
            },
          )
        : Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.only(top: 50),
              width: double.infinity,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Search for Users with their user name to chat...',
                    style: GoogleFonts.getFont(
                      'Chelsea Market',
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_______$a";
    } else {
      return "$a\_______$b";
    }
  }

  createChatRoom(String userName) async {
    String roomId = await getChatRoomId(Constants.name, userName);
    List<String> users = [Constants.name, userName];
    List<String> userMails = [Constants.email, userEmail];
    Map<String, dynamic> chatRoomMap = {
      'users': users,
      'roomId': roomId,
      'createdAt': FieldValue.serverTimestamp(),
      'userMails': userMails,
    };
    await DBmethods().createChat(roomId, chatRoomMap);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Room(
          chatroomId: roomId,
          reciever: userName,
          reciverEmail: userEmail,
        ),
      ),
    );
  }

  Widget SearchTile({
    String userName,
    String userEmail,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: SizedBox(
        height: 100,
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: GoogleFonts.getFont('Chelsea Market',
                      color: Colors.white),
                ),
                Text(
                  userEmail,
                  style: GoogleFonts.getFont('Chelsea Market',
                      color: Colors.white),
                ),
              ],
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 0,
              ),
              child: ClipRRect(
                child: RaisedButton(
                  padding: EdgeInsets.all(10),
                  onPressed: () => createChatRoom(userName),
                  color: Colors.blue,
                  child: Text(
                    'Message',
                    style: GoogleFonts.getFont(
                      'Chelsea Market',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
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
        child: Column(
          children: [
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: userName,
                      decoration: InputDecoration(
                        hintText: 'Search UserName',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                      style: GoogleFonts.getFont('Chelsea Market',
                          color: Colors.white),
                    ),
                  ),
                  Container(
                    child: FloatingActionButton(
                      tooltip: 'Search',
                      backgroundColor: Colors.grey,
                      onPressed: () {
                        initSearch();
                      },
                      child: Icon(Icons.search),
                    ),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}
