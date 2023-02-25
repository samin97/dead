import 'dart:convert';
import 'package:bookapp/Models/Book.dart';
import 'package:bookapp/Screen/CartPage.dart';
import 'package:bookapp/Screen/DetailsScreen.dart';
import 'package:bookapp/Service/BookServices.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'loadingScreen.dart';


class NewHome  extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<NewHome> {
BookService c=BookService();
Future recentlist;
Future featuredlist;
Future booklist;
var imagepath;
  var currentPage = 0;

    //await  auth.getToken();
  
  
  Future<List<Book>> _getBooks() async{
 // var a= await http.get("http://202.45.146.174/lumbini/api/inventory"); 
   var a=  await c.getrecentbook();
    List<Book> _list = [];

 
    if (a != null) {
      var blogPosts = json.decode(a.body);
        
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
          _list.add(model);
        });
       }
      });
    }
                

    return _list;
 
  }

 Future<List<Book>> _getFeaturedBooks() async{
 // var a= await http.get("http://202.45.146.174/lumbini/api/inventory"); 
   var a=await c.getFeaturedBook();
    List<Book> _lists = [];

 
    if (a != null) {
      var blogPosts = json.decode(a.body);
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
          _lists.add(model);
        });
       }
      });
      
    }
                

    return _lists;
 
  }
Future<List<Book>> _getAllBooks() async{
 // var a= await http.get("http://202.45.146.174/lumbini/api/inventory"); 
   var a=await c.getallbook();
    List<Book> _lists = [];

 
    if (a != null) {
      var blogPosts = json.decode(a.body);
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
          _lists.add(model);
        });
       }
      });
      
    }
                

    return _lists;
 
  }


List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
void initState(){
 recentlist= _getBooks();
  featuredlist=_getFeaturedBooks();
 booklist=_getAllBooks();
 
  super.initState();
}
  @override
  Widget build(BuildContext context) {
    
    return
    SingleChildScrollView(
     child:Column(
        children: <Widget>[
         


          CarouselSlider(
              items: [
                  
                //1st Image of Slider
                Container(
                  margin: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage("https://images.unsplash.com/photo-1589998059171-988d887df646?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8OXx8fGVufDB8fHx8&w=1000&q=80"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                  
                // //2nd Image of Slider
                // Container(
                //   margin: EdgeInsets.all(6.0),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(8.0),
                //     image: DecorationImage(
                //       image: NetworkImage("http://www.gundrukpost.com/wp-content/uploads/2015/03/3Karnali-Blues.jpg"),
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
                  
                // //3rd Image of Slider
                // Container(
                //   margin: EdgeInsets.all(6.0),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(8.0),
                //     image: DecorationImage(
                //       image: NetworkImage("http://www.gundrukpost.com/wp-content/uploads/2015/03/3Karnali-Blues.jpg"),
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
                  
               
            
  
          ],
              
            //Slider Container properties
              options: CarouselOptions(
                height: 180.0,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 0.8,
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
                             "Featured Books",
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
         height: 200,             
      child: FutureBuilder(
        future:featuredlist,            
        builder: (context, snapshot) {
        if(snapshot.connectionState!=ConnectionState.done){
             InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
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
      onRefresh: () =>  _getFeaturedBooks(),
    child:  ListView(
        scrollDirection: Axis.horizontal,
        children:List.generate(snapshot.data.length, (index){
            return Container(
      margin: EdgeInsets.only(left: 8),
  
      child: Column(
        children: <Widget>[
          Container(
            height: 200,
            width: MediaQuery.of(context).size.width*0.30,
            child: 
              InkWell(
           child:Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child:
            Image.network("http://103.69.126.198:8080"+snapshot.data[index].imagePath,height:80,fit: BoxFit.fill),              
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: EdgeInsets.all(8),
            ),
           
         onTap: (){
            
    
                             Navigator.push(context,new MaterialPageRoute(builder: (context)=>new DetailsScreen(snapshot.data[index].id)));

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
                             "Recent Books",
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
          height: 130,        
      child: FutureBuilder(
        future:recentlist,            
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
      onRefresh: () =>_getBooks(),
    child:  ListView(
        scrollDirection: Axis.horizontal,
        children:List.generate(snapshot.data.length, (index){
            return Container(
      margin: EdgeInsets.only(left: 8),
  
      child: Column(
        children: <Widget>[
          Container(
            width: 120,
            height: 120,
            child: 
              InkWell(
           child:Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.network("http://103.69.126.198:8080/"+snapshot.data[index].imagePath,height:120,fit: BoxFit.fill),              
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
                             "All Books",
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
          height: 120,        
      child: FutureBuilder(
        future:booklist,            
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
      onRefresh: () => booklist,
    child:  ListView(
        scrollDirection: Axis.horizontal,
        children:List.generate(snapshot.data.length, (index){
            return Container(
      margin: EdgeInsets.only(left: 8),
  
      child: Column(
        children: <Widget>[
          Container(
            width: 100,
            height: 100,
            child: 
              InkWell(
           child:Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.network("http://103.69.126.198:8080/"+snapshot.data[index].imagePath,height:100,fit: BoxFit.fill),              
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
     
             
    //       GestureDetector(
    //             child: Container(
    //               padding: EdgeInsets.only(top: 5,left: 16,right: 8,),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: <Widget>[
    //                   Container(
    //                     height: 40,
    //                     child: Center(
    //                       child: Text(
    //                          "All Books",
    //                         overflow: TextOverflow.ellipsis,
    //                         maxLines: 2,
    //                         style: TextStyle(
    //                             fontWeight: FontWeight.bold,
    //                             fontSize: 15,
    //                             color: Colors.blue),
    //                       ),
    //                     ),
    //                   ),
    //                 ]
    //               )
    //             ),
    //       ),
                      
    //    SizedBox( 
    //      height: 200,             
    //   child: FutureBuilder(
    //     future:booklist ,            
    //     builder: (context, snapshot) {
    //     if(snapshot.connectionState!=ConnectionState.done){
    //          InkWell(
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(32.0),
    //                     child: Text("ERROR OCCURRED, Tap to retry !"),
    //                   ),
    //                   onTap: () => setState(() {}));
    //     }
    //     if(!snapshot.hasData) 
    //    {
    //      return LoadingWidget();
         
         
         
    //    }
    //     else{    
    //    return RefreshIndicator(
    //   onRefresh: () =>  _getAllBooks(),
    // child:  ListView(
    //     scrollDirection: Axis.horizontal,
    //     children:List.generate(snapshot.data.length, (index){
    //         return Container(
    //   margin: EdgeInsets.only(left: 8),
  
    //   child: Column(
    //     children: <Widget>[
    //       Container(
    //         height: 200,
    //         width: MediaQuery.of(context).size.width*0.65,
    //         child: 
    //           InkWell(
    //        child:Card(
    //           semanticContainer: true,
    //           clipBehavior: Clip.antiAliasWithSaveLayer,
    //           child:
    //        Image.network("http://103.69.126.198:8080/"+snapshot.data[index].imagePath,height:80,width: 100,),              
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(10.0),
    //           ),
    //           elevation: 5,
    //           margin: EdgeInsets.all(8),
    //         ),
           
    //      onTap: (){
    //                          Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>new DetailsScreen(snapshot.data[index].id)));

    //  },
    //           ),
    //       ),
         
    //     ],
    //   ),
    // );

   
    //     }) 
    //   )
    //    );
    //    }
       
    //     })
        
    //  ),
     
     
     
     ])
      
    );
        // ,drawer: DrawerHelper(),
      
       
     
   
    

  }
   getView(int page) {
    switch (page) {
      case 0:
        return NewHome();
      // case 1:
      //   // if (isWasConnectionLoss) {
      //   //   return OfflineScreen();
      //   // } else {
      //   //   return MyLibraryView();
      //   // }
      //   break;
      case 1:
        return CartPage();
      // case 3:
      //   return ProfileView();
      default:
        return NewHome();
    }
  }

}





















 