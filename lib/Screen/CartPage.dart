import 'dart:convert';
import 'package:bookapp/Models/Book.dart';
import 'package:bookapp/Notifier/CartItemCounter.dart';
import 'package:bookapp/Notifier/TotalAmount.dart';
import 'package:bookapp/Screen/DetailsScreen.dart';
import 'package:bookapp/Screen/LoginScreen.dart';
import 'package:bookapp/Service/BookServices.dart';
import 'package:bookapp/Widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loadingScreen.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double totalAmount;
  SharedPreferences sharedPreferences;
  String userCartList = 'userCart';
  Future<List<Book>> list;

  Future<void> initializePreference() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  BookService c = BookService();
  List<Book> book;

  var ids = [];

  Future<List<Book>> _getBooks() async {
    book = new List<Book>();
    if (ids != null || ids.isNotEmpty) {
      for (String id in ids) {
        var a = await c.getBookById(id);

        if (a != null) {
          var data = json.decode(a.body);
          var datas = data["book"];
          var model = new Book();
          model.id = datas['id'];
          model.name = datas['name'] ?? ' ';
          model.imagePath = datas['imagePath'] ?? '';
          model.filePath = datas['bookPath'] ?? '';
          model.shortDescription = datas['shortDescription'];
          model.price = datas['eBookPrice'].toString();

          book.add(model);
        }
      }
    }

    return book;
  }

  @override
  void initState() {
    super.initState();
    initializePreference().whenComplete(() {
      setState(() {
        ids = sharedPreferences.getStringList(userCartList) ?? [];
      });
      list = _getBooks();
    });

    totalAmount = 0;
    // Provider.of<TotalAmount>(context, listen: false).display(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (sharedPreferences.getStringList(userCartList).length == 0) {
              Fluttertoast.showToast(msg: 'No item in cart');
            } else {
              Route route = MaterialPageRoute(builder: (_) => LoginScreen());
              Navigator.of(context).push(route);

              Fluttertoast.showToast(msg: 'Checkout in process');
            }
          },
          label: Text('Check Out'),
          backgroundColor: Colors.deepPurple,
          icon: Icon(Icons.navigate_next),
        ),
        body: Container(
            child: FutureBuilder(
                future: list,
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? Container(
                          child: Center(child: LoadingWidget()),
                        )
                      : snapshot.data.length == 0
                          ? startBuildingCart()
                          : Column(children: <Widget>[
                              Expanded(
                                  child: ListView(
                                      children: List.generate(
                                          snapshot.data.length, (index) {
                                return sourceInfo(snapshot.data[index], context,
                                    removeCartFunction: () => removeItemInCart(
                                        snapshot.data[index].id.toString()));
                              })))
                            ]);
                }))
        //SliverToBoxAdapter(
        //   child: Consumer2<TotalAmount,CartItemCounter>(builder: (context, amountProvider,cartProvider, _) {
        //     return Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Center(
        //         child: cartProvider.count==0?Container():Text(
        //           'Total price: ${amountProvider.totalAmount.toString()}',
        //           style: TextStyle(
        //               color: Colors.black,
        //               fontSize: 20.0,
        //               fontWeight: FontWeight.w500),
        //         ),
        //       ),
        //     );
        //   }),
        //),

        );
  }

  Widget sourceInfo(Book model, BuildContext context,
      {Color background, removeCartFunction}) {
    return InkWell(
      onTap: () {
        Route route =
            MaterialPageRoute(builder: (_) => DetailsScreen(model.id));
        Navigator.push(context, route);
      },
      splashColor: Colors.purple,
      child: Container(
          height: 170,
          width: MediaQuery.of(context).size.width - 20,
          child: Row(
            children: <Widget>[
              AspectRatio(
                aspectRatio: .7,
                child: card(primaryColor: background, imgPath: model.imagePath),
              ),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    SizedBox(height: 15),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: Text(model.name,
                                style: TextStyle(
                                    color: Colors.purple,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ),
                          CircleAvatar(
                            radius: 3,
                            backgroundColor: background,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(width: 10)
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          alignment: Alignment.topLeft,
                          width: 40.0,
                          height: 40.0,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "50%",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                                Text(
                                  "OFF",
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 5.0,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Text("M.R.P.: ₹",
                                      style: TextStyle(fontSize: 14).copyWith(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      )),
                                  Text("1500.0",
                                      style: TextStyle(fontSize: 14).copyWith(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          decoration:
                                              TextDecoration.lineThrough)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 0.0,
                              ),
                              child: Row(
                                // mainAxisSize: MainAxisSize.min,
                                //mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text("Price: ",
                                      style: TextStyle(fontSize: 14).copyWith(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      )),
                                  Text(
                                    "₹",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 14.0),
                                  ),
                                  Text(model.price.toString(),
                                      style: TextStyle(fontSize: 14).copyWith(
                                        fontSize: 14,
                                        color: Colors.red,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Flexible(
                      child: Container(),
                    ),
                    Row(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerRight,
                          child: removeCartFunction == null
                              ? IconButton(
                                  icon: Icon(
                                    Icons.add_shopping_cart,
                                    color: Colors.purple,
                                  ),
                                  onPressed: () {
                                    // checkItemInCart(model.id, context);
                                  })
                              : IconButton(
                                  icon: Icon(
                                    Icons.remove_shopping_cart,
                                    color: Colors.purple,
                                  ),
                                  onPressed: () {
                                    print('StoreHome.dart');
                                    removeCartFunction();
                                    //checkItemInCart(model.isbn, context);
                                  }),
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                                icon: Icon(
                                  Icons.book_online_sharp,
                                  color: Colors.purple,
                                ),
                                onPressed: () {
                                  // Route route =   MaterialPageRoute(builder: (_) => PDFScreen(model.id));
                                  //Navigator.push(context, route);
                                })),
                        Divider(
                          height: 4,
                        )
                      ],
                    )
                  ]))
            ],
          )),
    );
  }

  Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
    return Container(
        height: 150,
        // width: MediaQuery.of(context).size.width * .34,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  offset: Offset(0, 5),
                  blurRadius: 10,
                  color: Color(0x12000000))
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Image.network(
            "http://103.69.126.198:8080" + imgPath,
            height: 150,
            // width: width * .34,
            fit: BoxFit.fill,
          ),
        ));
  }

  startBuildingCart() {
    return Container(
      child: Card(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        child: Container(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.insert_emoticon, color: Colors.white),
                Text('You dont have any product in cart'),
                Text('Start building your cart now!!'),
              ],
            )),
      ),
    );
  }

  removeItemInCart(String productID) {
    print('Someone called me');
    List<String> temp = sharedPreferences.getStringList(
      userCartList,
    );
    temp.remove(productID);

    sharedPreferences.setStringList(userCartList, temp);
    initializePreference().whenComplete(() {
      setState(() {
        ids = sharedPreferences.getStringList(userCartList) ?? [];
        list = _getBooks();
      });

      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });

//  setState(){
//
//                 }

    totalAmount = 0;

    //

    Fluttertoast.showToast(msg: 'Item Removed Succesfully');
  }
}

// Widget sourceInfo(BookModel model, BuildContext context,
//     {Color background, removeCartFunction}) {
//   return InkWell(
//     onTap: () {
//       // Route route =
//       //     MaterialPageRoute(builder: (_) => ProductPage(bookModel: model));
//       // Navigator.push(context, route);
//     },
//     splashColor: LightColor.purple,
//     child: Container(
//         height: 170,
//         width: width - 20,
//         child: Row(
//           children: <Widget>[
//             AspectRatio(
//               aspectRatio: .7,
//               child:
//                   card(primaryColor: background, imgPath: model.thumbnailUrl),
//             ),
//             Expanded(
//                 child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 SizedBox(height: 15),
//                 Container(
//                   child: Row(
//                     mainAxisSize: MainAxisSize.max,
//                     children: <Widget>[
//                       Expanded(
//                         child: Text(model.title,
//                             style: TextStyle(
//                                 color: LightColor.purple,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold)),
//                       ),
//                       CircleAvatar(
//                         radius: 3,
//                         backgroundColor: background,
//                       ),
//                       SizedBox(
//                         width: 5,
//                       ),
//                       Text(model.pageCount.toString(),
//                           style: TextStyle(
//                             color: LightColor.grey,
//                             fontSize: 14,
//                           )),
//                       SizedBox(width: 10)
//                     ],
//                   ),
//                 ),
//                 Row(
//                   children: <Widget>[
//                     Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.red,
//                       ),
//                       alignment: Alignment.topLeft,
//                       width: 40.0,
//                       height: 40.0,
//                       child: Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             Text(
//                               "50%",
//                               style: TextStyle(
//                                   fontSize: 15.0,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.normal),
//                             ),
//                             Text(
//                               "OFF",
//                               style: TextStyle(
//                                   fontSize: 10.0,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.normal),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Padding(
//                           padding: const EdgeInsets.only(
//                             top: 5.0,
//                           ),
//                           child: Row(
//                             children: <Widget>[
//                               Text("M.R.P.: ₹",
//                                   style: AppTheme.h6Style.copyWith(
//                                     fontSize: 14,
//                                     color: LightColor.grey,
//                                   )),
//                               Text("1500.0",
//                                   style: AppTheme.h6Style.copyWith(
//                                       fontSize: 14,
//                                       color: LightColor.grey,
//                                       decoration: TextDecoration.lineThrough)),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(
//                             top: 0.0,
//                           ),
//                           child: Row(
//                             // mainAxisSize: MainAxisSize.min,
//                             //mainAxisAlignment: MainAxisAlignment.start,
//                             children: <Widget>[
//                               Text("Price: ",
//                                   style: AppTheme.h6Style.copyWith(
//                                     fontSize: 14,
//                                     color: LightColor.grey,
//                                   )),
//                               Text(
//                                 "₹",
//                                 style: TextStyle(
//                                     color: Colors.red, fontSize: 14.0),
//                               ),
//                               Text(model.price.toString(),
//                                   style: AppTheme.h6Style.copyWith(
//                                     fontSize: 14,
//                                     color: Colors.red,
//                                   )),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Flexible(
//                   child: Container(),
//                 ),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: removeCartFunction == null
//                       ? IconButton(
//                           icon: Icon(
//                             Icons.add_shopping_cart,
//                             color: LightColor.purple,
//                           ),
//                           onPressed: () {
//                             checkItemInCart(model.isbn, context);
//                           })
//                       : IconButton(
//                           icon: Icon(
//                             Icons.remove_shopping_cart,
//                             color: LightColor.purple,
//                           ),
//                           onPressed: () {
//                             print('StoreHome.dart');
//                             removeCartFunction();
//                             //checkItemInCart(model.isbn, context);
//                           }),
//                 ),
//                 Divider(
//                   height: 4,
//                 )
//               ],
//             ))
//           ],
//         )),
//   );
// }
// }
