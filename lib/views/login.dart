import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discord/helper/authenticate.dart';
import 'package:discord/helper/helper.dart';
import 'package:discord/services/auth.dart';
import 'package:discord/services/db.dart';
import 'package:discord/views/welcome.dart';
import 'package:discord/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  final Function toggleScreen;
  Login(this.toggleScreen);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  bool isErr = false;
  AuthServices authServices = new AuthServices();
  final formKey = GlobalKey<FormState>();
  DBmethods dBmethods = new DBmethods();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  QuerySnapshot snapshot;

  signMeIn() async {
    if (formKey.currentState.validate()) {
      await HelperFunc.saveUserMail(email.text);
      await dBmethods.getUserwithEmail(email.text).then((val) async {
        snapshot = val;
        await HelperFunc.saveUserName(snapshot.docs[0].data()['email']);
        await HelperFunc.saveUserName(snapshot.docs[0].data()['userName']);
      });
      setState(() {
        isLoading = true;
      });
      await authServices.signInEP(email.text, password.text).then(
        (value) async {
          if (value != null) {
            setState(() {
              isLoading = false;
            });
            await HelperFunc.saveUserState(true);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Welcome()));
          } else if (value == null) {
            setState(() {
              isLoading = false;
              isErr = true;
            });
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : isErr
              ? Container(
                  padding: EdgeInsets.all(60),
                  margin: EdgeInsets.only(bottom: 30),
                  alignment: Alignment.center,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'The provided credentials....... didnot match with the user\'s credentials.......Or the user doesnot exist!',
                          style: GoogleFonts.getFont(
                            'Chelsea Market',
                            color: Colors.white,
                            fontSize: 16.599999999,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: RaisedButton(
                            color: Colors.redAccent,
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Authenticate()));
                            },
                            child: Text(
                              'Back',
                              style: GoogleFonts.getFont(
                                'Chelsea Market',
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/login.jpeg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  validator: (value) {
                                    return value.isEmpty
                                        ? 'Please fill in the detals'
                                        : RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                .hasMatch(value)
                                            ? null
                                            : 'Please provide a valid email adress';
                                  },
                                  controller: email,
                                  decoration: textfldDeco('Email'),
                                  style: TextStyle(color: Colors.white),
                                ),
                                TextFormField(
                                  obscureText: true,
                                  validator: (value) {
                                    return value.length < 6
                                        ? 'Please enter a valid password'
                                        : null;
                                  },
                                  controller: password,
                                  decoration: textfldDeco('Password'),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                color: Colors.redAccent,
                                child: Text(
                                  'Sign In',
                                  style: GoogleFonts.getFont(
                                    'Chelsea Market',
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                onPressed: signMeIn,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                color: Colors.blue,
                                child: Text(
                                  'Sign In with Google',
                                  style: GoogleFonts.getFont(
                                    'Chelsea Market',
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                onPressed: () => print(''),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Dont have an account? ',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              GestureDetector(
                                onTap: () {
                                  widget.toggleScreen();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    'Register Now!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 2,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
