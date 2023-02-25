import 'dart:convert';
import 'package:bookapp/Enums/Constants.dart';
import 'package:bookapp/Models/Book.dart';
import 'package:bookapp/Models/author.dart';
import 'package:bookapp/Notifier/CartItemCounter.dart';
import 'package:bookapp/Provider/detailsProvider.dart';
import 'package:bookapp/Screen/EpubScreen.dart';
import 'package:bookapp/Screen/PdfScreen.dart';
import 'package:bookapp/Service/BookServices.dart';
import 'package:bookapp/Widgets/appbar.dart';
import 'package:bookapp/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'loadingScreen.dart';

double width;

 SharedPreferences sharedPreferences  ;
   String userCartList = 'userCart';



class DetailsScreen extends StatefulWidget {
final String id;
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
  DetailsScreen(this.id);
}

class _DetailsScreenState extends State<DetailsScreen> {
     bool isLoading=true;
  

  Future<void> initializePreference() async{
    sharedPreferences= await SharedPreferences.getInstance();
  }
  BookService c=BookService();
 Book book = new Book();
 Future similarBooks;

 Future<List<Book>>  _getBooks() async{
    
 // var a= await http.get("http://202.45.146.174/lumbini/api/inventory"); 
   var a=await c.getBookById(widget.id);
   
 
    if (a != null) {
      var data = json.decode(a.body);
     
      print(data);
        var model = Book();
        model=Book.fromjson(data);
      
var imagepath=await c.getimagepath(model.id);
         var b= json.decode(imagepath.body);
        model.imagePath=b["value"];
             
var writer=await c.getWriterName(model.author.id);
         var z= json.decode(writer.body);
        // var n=Author.fromjson(z);
        var s=z["value"];
        model.writerName=s[0]["Name"];
       var similarBook=await c.getBookByWriterName(model.author.id);
       List<Book> zzz=[];
         if (similarBook!= null) {
      var blogPosts = json.decode(similarBook.body);
        
      blogPosts["value"].forEach((blogPost) async {
        var model = Book();
        model=Book.fromjson(blogPost);
         if(imagepath==null){
         imagepath=await c.getimagepath(model.id);
        }
         var a= json.decode(imagepath.body);
        model.imagePath=a["value"];
        
                if(this.mounted)
       {
        setState(() {
          zzz.add(model);
        });
       }
      });
    }
        setState(() {
          book=model;
          isLoading=false;
      });
return zzz;
    }
      
return null;
    
 
  }

@override
   void initState() { 
     super.initState();
     _getBooks();
  similarBooks=   _getBooks();
  
        SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        Provider.of<DetailsProvider>(context, listen: false)
            .setEntry(widget.id);
      
      },
    );
             
     initializePreference().whenComplete((){
       setState(() {});
     });
   }

  @override
  Widget build(BuildContext context) {
   

       width= MediaQuery.of(context).size.width;

 return ChangeNotifierProvider(
    create: (context) => DetailsProvider(),
child:Consumer<DetailsProvider>(
   
    builder: ( context, DetailsProvider detailsProvider,
          Widget child) {
    return new  Scaffold(
      
      appBar:MyAppBar(),
      body:(isLoading)?LoadingWidget():SingleChildScrollView(
child: 
      Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: <Widget>[
    //                 Padding(
    //                   padding: const EdgeInsets.only(top: 18.0, left: 18.0),
    //                   child: Text(book.name,
    //                       style: TextStyle(
    //                           color: Colors.blue,
    //                           fontSize: 20.0,
    //                           fontWeight: FontWeight.bold)),
    //                 ),
    //    ],
    //  ),
       Row(
        
                  children: <Widget>[
                    Container(
                      width:100,
                       height: 100,
                        child: card(
                            primaryColor: Colors.red,
                            imgPath: "http://103.69.126.198:8080"+book.imagePath)),
Column(
children: <Widget>[
                            RichText(
                                 
                                  maxLines: 3,
                                                    softWrap: false,
                  overflow: TextOverflow.fade,

  text: TextSpan(
    children: <TextSpan>[
      TextSpan(text: book.name+"\n", style: TextStyle(color: Colors.red)),
      TextSpan(text:"by "+ book.writerName+"\n", style: TextStyle(color: Colors.blue,fontStyle: FontStyle.italic,fontSize: 12)),
    ],
  ),
),

_buildDownloadReadButton(detailsProvider,book, context),
        ]),
            
                  ],
       ),
                 
               Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, top: 20.0, bottom: 10.0),
                  child: Text(
                    "About this Item",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40.0,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black87,
                            width: 1.0,
                            style: BorderStyle.none)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                     
                        Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: Text(
                             (book.shortDescription!=null)?book.shortDescription:"When the earth was flat andeveryone wanted to win the gameof the best and people and winning with an A game with all the things you have.",

                            //"There are several things to consider in order to help your book achieve its greatest potential discoverability. Readers, librarians, and retailers can't purchase a book they can't find, and your book metadata is responsible for whether or not your book pops up when they type in search terms relevant to your book. Book metadata may sound complicated, but it consists of all the information that describes your book, including: your title, subtitle, series name, price, trim size, author name, book description, and more. There are two metadata fields for your book description: the long book description and the short book description. Although both play a role in driving traffic to your book, they have distinct differences.",
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                                color: Colors.blueGrey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              
                 GestureDetector(
                child: Container(
                  padding: EdgeInsets.only(top: 5,left: 16,right: 8,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 40,
                        child: Center(
                          child: Text(
                             "Books by auther",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.blue),
                          ),
                        ),
                      ),
                    ]
                  )
                ),
          ),
                      
       SizedBox(  
          height: 100,        
      child: FutureBuilder(
        future:similarBooks,            
        builder: (context, snapshot) {
        if(snapshot.connectionState!=ConnectionState.done){
             InkWell(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 32,right: 32),
                        child: Text("ERROR OCCURRED, Tap to retry !"),
                      ),
                      onTap: () => setState(() {}));
        }
        if(!snapshot.hasData) 
       {
         return LoadingWidget();
         
         
         
       }
        else{    
       return RefreshIndicator(
      onRefresh: () => similarBooks,
    child:  ListView(
        scrollDirection: Axis.horizontal,
        children:List.generate(snapshot.data.length, (index){
            return Container(
      margin: EdgeInsets.only(left: 8),
  
      child: Column(
        children: <Widget>[
          Container(
            width: 80,
            height: 100,
            child: 
              InkWell(
           child:Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.network("http://103.69.126.198:8080/"+snapshot.data[index].imagePath,height:80,width: 100,),              
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: EdgeInsets.all(8),
            ),
           
         onTap: (){
                                        Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>new DetailsScreen(snapshot.data[index].id)));


     },
              ),
          ),
         
        ],
      ),
    );

   
        }) 
      )
       );
       }
       
        })
        
     ),
     
             
              
                // Padding(
                //   padding: const EdgeInsets.only(top: 10.0),
                // //   child: Center(
                // //     child: Container(
                // //       width: MediaQuery.of(context).size.width - 40.0,
                // //       decoration: BoxDecoration(
                // //           border: Border.all(
                // //               color: Colors.black87,
                // //               width: 1.0,
                // //               style: BorderStyle.solid)),
                // //     //   child: Column(
                // //     //     crossAxisAlignment: CrossAxisAlignment.start,
                // //     //     children: <Widget>[
                // //     //       Padding(
                // //     //         padding: const EdgeInsets.only(left: 10.0),
                // //     //         child: Text(
                // //     //           "Features",
                // //     //           style: TextStyle(
                // //     //               fontWeight: FontWeight.bold, fontSize: 15.0),
                // //     //         ),
                // //     //       ),
                // //     //       // Padding(
                // //     //       //     padding: const EdgeInsets.only(
                // //     //       //         left: 30.0,
                // //     //       //         right: 30.0,
                // //     //       //         top: 20.0,
                // //     //       //         bottom: 20.0),
                // //     //       //     child: Table(
                // //     //       //       border: TableBorder.all(
                // //     //       //           width: 1.0, color: Colors.black87),
                // //     //       //       children: [
                // //     //       //         TableRow(
                // //     //       //           children: [
                // //     //       //             Container(
                // //     //       //               padding: const EdgeInsets.only(
                // //     //       //                   left: 10.0, right: 10.0),
                // //     //       //               height: 70.0,
                // //     //       //               color: Colors.grey.withOpacity(0.7),
                // //     //       //               child: Center(
                // //     //       //                 child: Text("Publisher "),
                // //     //       //               ),
                // //     //       //             ),
                // //     //       //             Container(
                // //     //       //               padding: const EdgeInsets.only(
                // //     //       //                   left: 10.0, right: 10.0),
                // //     //       //               height: 70.0,
                // //     //       //               color: Colors.grey.withOpacity(0.2),
                // //     //       //               child: Center(
                // //     //       //                 child: Text("Publisher Name"),
                // //     //       //               ),
                // //     //       //             )
                // //     //       //           ],
                // //     //       //         ),
                // //     //       //         TableRow(
                // //     //       //           children: [
                // //     //       //             Container(
                // //     //       //               padding: const EdgeInsets.only(
                // //     //       //                   left: 10.0, right: 10.0),
                // //     //       //               height: 70.0,
                // //     //       //               color: Colors.grey.withOpacity(0.7),
                // //     //       //               child: Center(
                // //     //       //                 child: Text("Publication Date"),
                // //     //       //               ),
                // //     //       //             ),
                // //     //       //             Container(
                // //     //       //               padding: const EdgeInsets.only(
                // //     //       //                   left: 10.0, right: 10.0),
                // //     //       //               height: 70.0,
                // //     //       //               color: Colors.grey.withOpacity(0.2),
                // //     //       //               child: Center(
                // //     //       //                 child: Text("Publisher Name"),
                // //     //       //               ),
                // //     //       //             )
                // //     //       //           ],
                // //     //       //         ),
                // //     //       //         TableRow(children: [
                // //     //       //           Container(
                // //     //       //             padding: const EdgeInsets.only(
                // //     //       //                 left: 10.0, right: 10.0),
                // //     //       //             height: 70.0,
                // //     //       //             color: Colors.grey.withOpacity(0.7),
                // //     //       //             child: Center(
                // //     //       //               child: Text("Language"),
                // //     //       //             ),
                // //     //       //           ),
                // //     //       //           Container(
                // //     //       //             padding: const EdgeInsets.only(
                // //     //       //                 left: 10.0, right: 10.0),
                // //     //       //             height: 70.0,
                // //     //       //             color: Colors.grey.withOpacity(0.2),
                // //     //       //             child: Center(
                // //     //       //               child: Text("English"),
                // //     //       //             ),
                // //     //       //           )
                // //     //       //         ])
                // //     //       //       ],
                // //     //       //     )),
                // //     //     ],
                // //     //   ),
                // //     // ),
                 
                // //    ),
                // //     ),
                // ),
           
              ]
     
        
        ),
        )
      )
    );
          })
          );
    //   );
    //       },
    // ), );
  }
    
}


_buildDownloadReadButton(DetailsProvider provider,Book book, BuildContext context) {
  provider.setEntry(book);
  provider.checkDownload();
  var download=provider.downloaded;
  print("download is"+download.toString());
    if (provider.downloaded) {
       return  ElevatedButton(
        onPressed: () =>
          Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>new EpubScreen(book.id))),
                       
        
        // padding: const EdgeInsets.all(0.0),
        child: Container(
          padding: const EdgeInsets.only(top: 1.0, bottom: 1,right: 5 ),
          child:Row(
            children: [
              Align(
                  alignment: Alignment.bottomLeft,
                  child: Icon(Icons.read_more_outlined)
              ),
              Container(
                  margin: const EdgeInsets.only( left: 1.0 ),
                  child: Text(
                    "Read book",
                    style: TextStyle( fontSize: 10.0),
                  )
              )
            ],
          ),
        ),
   
    );
  
      return      Padding(
                 padding: const EdgeInsets.only(top: 2.0),
                  child: Container(
                    child: InkWell(
                      onTap: () =>
                        Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>new EpubScreen(book.id))),
                         // checkItemInCart(book.id, context),
                      child: Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.orange, width: 1.0),
                            gradient: LinearGradient(
                                colors: [
                                  Colors.orangeAccent.withOpacity(0.4),
                                  Colors.orange.withGreen(56)
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter)),
                        width: 120,
                        height: 30.0,
                        
                        child: Text("Read book",textAlign: TextAlign.center,style:TextStyle(color: Colors.white)),
                         
                        
                        
                        //
                        
                        
                        ),
                      ),
                    ),
                  );
                

    } else { 
    return  ElevatedButton(
        onPressed: () => 
          provider.downloadFile(
          context,
         book.filePath,
          book.id,
        ),
        
        // padding: const EdgeInsets.all(0.0),
        child: Container(
          padding: const EdgeInsets.only(top: 1.0, bottom: 3,right: 5 ),
          child:Row(
            children: [
              Align(
                  alignment: Alignment.bottomLeft,
                  child: Icon(Icons.download)
              ),
              Container(
                  margin: const EdgeInsets.only( left: 1.0 ),
                  child: Text(
                    "Download book",
                    style: TextStyle( fontSize: 10.0),
                  )
              )
            ],
          ),
        ),
   
    );
    //  OutlinedButton(
    //     onPressed: () =>  provider.downloadFile(
    //       context,
    //      book.filePath,
    //       book.id,
    //     ),
    //     child: Stack(
          
    //       alignment: Alignment.centerLeft,
    //       children: <Widget>[
    //         Icon(Icons.save_alt_rounded),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: <Widget>[
    //             Text('Download book'),
    //           ],
    //         ),
    //       ],
    //     ),
       
    // );
    return      Padding(
                 padding: const EdgeInsets.only(top: 2.0),
                 
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () =>
                      provider.downloadFile(
          context,
         book.filePath,
          book.id,
        ),
                         // checkItemInCart(book.id, context),
                      child: Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.orange, width: 1.0),
                            gradient: LinearGradient(
                                colors: [
                                  Colors.orangeAccent.withOpacity(0.4),
                                  Colors.orange.withGreen(56)
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter)),
                        width: 120,
                        height: 30.0,
                        child: Text("Download book",textAlign: TextAlign.center,style:TextStyle(color: Colors.white)),
                         
                        
                        
                        //
                        
                        
                        ),
                      ),
                    ),
                  );
      
    }
  }
Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container(
      height: 150,
      width:width,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                offset: Offset(0, 5), blurRadius: 10, color: Color(0x12000000))
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Image.network(
          imgPath,
          height: 150,
          width: width * .34,
          fit: BoxFit.fill,
        ),
      ));
}


void checkItemInCart(String productID, BuildContext context) {
  print(productID);
  List<String> shared=[];
  try{
 shared= sharedPreferences.getStringList(Constants.userCartList) ?? [];
  }
  catch(e){
  }
if(shared.isNotEmpty)
          {
  ///print(cartItems);
  sharedPreferences
          .getStringList(
            userCartList,
          )
          .contains(productID.toString())
      ? Fluttertoast.showToast(msg: 'Product is already in cart')
      : addToCart(productID, context);
          }
          else{
            addToCart(productID, context);
          }
}

void addToCart(String productID, BuildContext context) {
  List<String> temp= [];
  try{
 temp = sharedPreferences.getStringList(
    Constants.userCartList
  );
  }
  catch(e){
   temp= [];
  }
  if(temp==null)
  {
    temp=[];
      temp.add(productID.toString());

  }
  else{
          temp.add(productID.toString());

  }

    Fluttertoast.showToast(msg: 'Item Added Succesfully');
    sharedPreferences
        .setStringList(userCartList, temp);
    Provider.of<CartItemCounter>(context, listen: false).displayResult();
  
}


