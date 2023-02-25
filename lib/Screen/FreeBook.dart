
import 'dart:convert';
import 'package:bookapp/Models/Book.dart';
import 'package:bookapp/Screen/CartPage.dart';
import 'package:bookapp/Screen/DetailsScreen.dart';
import 'package:bookapp/Service/BookServices.dart';
import 'package:flutter/material.dart';

import 'loadingScreen.dart';


class FreeBook  extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<FreeBook> {
BookService c=BookService();
Future list;
Future featuredlist;

  var currentPage = 0;

    //await  auth.getToken();
  
  
  Future<List<Book>> _getBooks() async{
 // var a= await http.get("http://202.45.146.174/lumbini/api/inventory"); 
   var a=await c.getFreeBook();
    List<Book> _list = List<Book>();

 
    if (a != null) {
      var blogPosts = json.decode(a.body);
        
      blogPosts.forEach((blogPost) {
        var model = Book();
        model=Book.fromjson(blogPost);

       
        setState(() {
          _list.add(model);
        });
      });
    }
                

    return _list;
 
  }



  @override
void initState(){
  list = _getBooks();
  super.initState();
}
  @override
  Widget build(BuildContext context) {
    
    return
     Column(
        children: <Widget>[
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
                             "Free Books",
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
                      
       Expanded(  
      child: FutureBuilder(
        future:list  ,            
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
      onRefresh: () =>  _getBooks(),
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
              child: Image.network("http://103.69.126.198:8080"+snapshot.data[index].imagePath,height:80,width: 100,),              
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
     
     
     
     ]);
      
      
        // ,drawer: DrawerHelper(),
      
       
     
   
    

  }

}





















 