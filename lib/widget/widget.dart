import 'package:discord/helper/authenticate.dart';
import 'package:discord/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.orangeAccent.shade400,
    title: Container(
        width: double.infinity,
        child: Container(
          width: double.infinity,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
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
              ]),
        )),
  );
}

Widget mainAppBar(BuildContext context) {
  return AppBar(
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
    actions: [
      GestureDetector(
        child: Container(
          padding: EdgeInsets.only(right: 15),
          child: FloatingActionButton(
            heroTag: 'Logout_btn',
            backgroundColor: Colors.deepOrange,
            tooltip: 'Logout',
            child: Icon(Icons.exit_to_app),
            onPressed: () {
              AuthServices authServices = new AuthServices();
              authServices.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
          ),
        ),
      )
    ],
  );
}

InputDecoration textfldDeco(hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.white60,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white10,
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  );
}
