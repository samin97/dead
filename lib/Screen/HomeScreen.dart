
import 'dart:convert';
import 'package:bookapp/Models/Book.dart';

import 'package:bookapp/Screen/FreeBook.dart';
import 'package:bookapp/Screen/download.dart';
import 'package:bookapp/Service/BookServices.dart';
import 'package:bookapp/Widgets/appbar.dart';
import 'package:fancy_bottom_navigation_image/fancy_bottom_navigation_image.dart';
import 'package:flutter/material.dart';

import 'NewHomeScreen.dart';


class Home  extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Home> {
BookService c=BookService();
Future list;
  var currentPage = 0;

    //await  auth.getToken();
  
  
  @override
void initState(){
  super.initState();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:MyAppBar(),
      body:  getView(currentPage),
   
              bottomNavigationBar: 
              FancyBottomNavigationImage(
        circleColor: Colors.orange,
        activeIconColor: Colors.white,
        textColor: Colors.white,
        inactiveIconColor: Colors.white,
        barBackgroundColor:Colors.blueGrey,
        
        //barBackgroundColor: ,
        tabs: [
          TabData(
              imageData: "home-run.png",
              title: "home"),
          TabData(
              imageData: "downloads.png",
              title:"download" ),
    ],
        onTabChangedListener: (position) {
          setState(() {
            currentPage = position;
          });
        },
      ),

         
        // ,drawer: DrawerHelper(),
      
       
      );

   
    

  }
   getView(int page) {
    switch (page) {
      case 0:
        return NewHome();
    
      case 1:
        return Downloads();
   
      default:
        return NewHome();
    }
  }

}





















 