// ignore: unused_import
import 'package:discord/helper/authenticate.dart';
import 'package:discord/helper/constants.dart';
import 'package:discord/helper/helper.dart';
import 'package:discord/services/db.dart';
import 'package:discord/views/chat.dart';
import 'package:discord/widget/widget.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:google_fonts/google_fonts.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  String _loggedInUser;
  String _loggedInUserMail;
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    _loggedInUser = await HelperFunc.getUserName();
    _loggedInUserMail = await HelperFunc.getUserEmail();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Center(
          child: _loggedInUser != null
              ? Container(
                  alignment: Alignment.center,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/welcome2.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Hey $_loggedInUser, ',
                            style: GoogleFonts.getFont(
                              'Chelsea Market',
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            width: 250,
                            child: Text(
                              'By proceeding to the app, you will accept to the Terms, Conditions and Rules of the app.....🚀',
                              style: GoogleFonts.getFont(
                                'Chelsea Market',
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          RaisedButton(
                            color: Colors.redAccent,
                            padding: EdgeInsets.only(
                                top: 10, bottom: 10, left: 25, right: 25),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Chat(),
                                ),
                              );
                            },
                            child: Text(
                              'Proceed',
                              style: GoogleFonts.getFont(
                                'Chelsea Market',
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/welcome2.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )),
    );
  }
}
