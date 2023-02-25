import 'package:bookapp/Enums/Constants.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';



class CartItemCounter extends ChangeNotifier
{

  static final CartItemCounter _instance = CartItemCounter._privateConstructor();
  factory CartItemCounter() {
    return _instance;
  }
  SharedPreferences _prefs;

  CartItemCounter._privateConstructor() {
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
      try{
      _counter = _prefs.getStringList(Constants.userCartList).length;
      }catch(e)
      {
        _counter=0;
      }

    });

 
  }
  int _counter=0;



  int get count => _counter;

  Future<void> displayResult() async
  {
    try{
    _counter = _prefs.getStringList(Constants.userCartList).length;
    }
    catch(e){
      _counter=0;
    }
    await Future.delayed(const Duration(milliseconds: 10), (){
      notifyListeners();
    });
  }
}


 
   

