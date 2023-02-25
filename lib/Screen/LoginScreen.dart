import 'dart:convert';

import 'package:bookapp/Components/LoginBody.dart';
import 'package:bookapp/Components/Loginackground.dart';
import 'package:bookapp/Components/RoundedButton.dart';
import 'package:bookapp/Components/alreadyAccount.dart';
import 'package:bookapp/Components/password.dart';
import 'package:bookapp/Components/roundedInputField.dart';
import 'package:bookapp/Models/LoginModel.dart';
import 'package:bookapp/Screen/NewHomeScreen.dart';
import 'package:bookapp/Service/BookServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SignInScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<LoginScreen> {
  BookService bookService=new BookService();
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _form = GlobalKey<FormState>();
         var username=TextEditingController();
         var password=TextEditingController(); 


           
    SharedPreferences sharedPreferences  ;

  Future<void> initializePreference() async{
    sharedPreferences= await SharedPreferences.getInstance();
  }
    showAlertDialog(BuildContext context){
      AlertDialog alert=AlertDialog(
        content: new Row(
            children: [
               CircularProgressIndicator(),
               Container(margin: EdgeInsets.only(left: 5),child:Text("Loading" )),
            ],),
      );
      showDialog(barrierDismissible: false,
        context:context,
        builder:(BuildContext context){
          return alert;
        },
      );
    }

_submitForm() async{

// final isValid = _form.currentState.validate();
//         if (!isValid) {
//            return;
//              }
             LoginModel user=LoginModel();
            setState(() {
              user.email=username.text;
              user.password=password.text;
               
            });
               Fluttertoast.showToast(msg: 'Logging in');

      var a=await bookService.login(user);
 if (a.statusCode == 200) {
       var s= json.decode(a.body);
await sharedPreferences.setString("token", s);
 Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewHome()
      )
    );
  } else {
    Fluttertoast.showToast(msg: "Error logging in");
  }
  }
 
  @override
  Widget build(BuildContext context) {
     Size size = MediaQuery.of(context).size;

    return Scaffold(
      body:  Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Email",
              message: "Username is required",
              onChanged: (value) {
                setState(() {
                  username.text=value;
                });
                 


              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
  setState(() {
                  password.text=value;
                });

              },
            ),
            RoundedButton(
              text: "LOGIN",
              press: () {
                _submitForm();

              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ),
 
    );
  }
}