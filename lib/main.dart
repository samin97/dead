import 'package:bookapp/Notifier/downloadChecker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Notifier/CartItemCounter.dart';
import 'Notifier/TotalAmount.dart';
import 'Screen/HomeScreen.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CartItemCounter()),
          ChangeNotifierProvider(create: (_) => TotalAmount()),
          ChangeNotifierProvider(create: (_) => DetailsProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Home(),
        ));
  }
}
