import 'dart:convert';
import 'dart:io';

import 'package:bookapp/Models/Document.dart';
import 'package:bookapp/Service/BookServices.dart';
import 'package:dio/dio.dart';
import 'package:epub_viewer/epub_viewer.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';



class EpubScreen extends StatefulWidget {
final String id;
   EpubScreen(this.id);
  @override
  _MyAppState createState() => _MyAppState();
}
bool isLoading=true;
class _MyAppState extends State<EpubScreen> {
  bool loading = true;
  Dio dio = new Dio();
  
BookService c=BookService();
 Document book = new Document();
 
_getBooks() async{
    
 // var a= await http.get("http://202.45.146.174/lumbini/api/inventory"); 
   var a=await c.getDocumentByProductId(widget.id);
   
 
    if (a != null) {
      var data = json.decode(a.body);
      print(data);
        data.forEach((blogPost) async {
        var model = Document();

        model=Document.fromjson(blogPost);
if(model.link==".epub")
{
       
        setState(() {
          book=model;
         
          isLoading=false;
      });
       _openebook();
}

    });
                

    
 
  }
}
 _openebook () async {
                    Directory appDocDir =
                        await getApplicationDocumentsDirectory();
                        Directory d=await getExternalStorageDirectory();
                    print('$appDocDir');

                    String iosBookPath = '${appDocDir.path}/' +widget.id+ '.epub';
                    print(iosBookPath);
                                        String androidBookPath =  d.path + '/' +widget.id+ '.epub';
 print(androidBookPath);
                    //String androidBookPath = 'file:///android_asset/3.epub';
                    EpubViewer.setConfig(
                        themeColor: Theme.of(context).primaryColor,
                        identifier: "iosBook",
                        scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
                        allowSharing: true,
                        enableTts: true,
                        nightMode: true);
                   EpubViewer.open(
                     Platform.isAndroid ? androidBookPath : iosBookPath,
                     lastLocation: EpubLocator.fromJson({
                       "bookId": "2239",
                       "href": "/OEBPS/ch06.xhtml",
                       "created": 1539934158390,
                       "locations": {
                         "cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"
                       }
                     }),
                   );

                    // await EpubViewer.openAsset(
                    //   'assets/4.epub',
                    //   lastLocation: EpubLocator.fromJson({
                    //     "bookId": "2239",
                    //     "href": "/OEBPS/ch06.xhtml",
                    //     "created": 1539934158390,
                    //     "locations": {
                    //       "cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"
                    //     }
                    //   }),
                    // );
                    // get current locator
                    EpubViewer.locatorStream.listen((locator) {
                      print(
                          'LOCATOR: ${EpubLocator.fromJson(jsonDecode(locator))}');
                    });
                  }
                
  @override
  void initState() {
    super.initState();
    _getBooks();
   
   
   // loading=false;
    
//    download();
  }

  download() async {
    await startDownload();

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: loading
              ? CircularProgressIndicator()
              :_openebook()
        ),
//                FlatButton(
//                   onPressed: () async {
//                     Directory appDocDir =
//                         await getApplicationDocumentsDirectory();
//                         Directory d=await getExternalStorageDirectory();
//                     print('$appDocDir');

//                     String iosBookPath = '${appDocDir.path}/' +widget.id+ '.epub';
//                     print(iosBookPath);
//                                         String androidBookPath =  d.path + '/' +widget.id+ '.epub';
//  print(androidBookPath);
//                     //String androidBookPath = 'file:///android_asset/3.epub';
//                     EpubViewer.setConfig(
//                         themeColor: Theme.of(context).primaryColor,
//                         identifier: "iosBook",
//                         scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
//                         allowSharing: true,
//                         enableTts: true,
//                         nightMode: true);
//                    EpubViewer.open(
//                      Platform.isAndroid ? androidBookPath : iosBookPath,
//                      lastLocation: EpubLocator.fromJson({
//                        "bookId": "2239",
//                        "href": "/OEBPS/ch06.xhtml",
//                        "created": 1539934158390,
//                        "locations": {
//                          "cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"
//                        }
//                      }),
//                    );

//                     // await EpubViewer.openAsset(
//                     //   'assets/4.epub',
//                     //   lastLocation: EpubLocator.fromJson({
//                     //     "bookId": "2239",
//                     //     "href": "/OEBPS/ch06.xhtml",
//                     //     "created": 1539934158390,
//                     //     "locations": {
//                     //       "cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"
//                     //     }
//                     //   }),
//                     // );
//                     // get current locator
//                     EpubViewer.locatorStream.listen((locator) {
//                       print(
//                           'LOCATOR: ${EpubLocator.fromJson(jsonDecode(locator))}');
//                     });
//                   },
//                   child: Container(
//                     child: Text('open epub'),
//                   ),
//                 ),
//         ),
      ),
    );
  }

  Future downloadFile() async {
    print('download1');

   
      await startDownload();
    
  }

  startDownload() async {
    Directory appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    String path = appDocDir.path+'/' +widget.id+ '.epub';
    File file = File(path);
//    await file.delete();

    if (!File(path).existsSync()) {
      await file.create();
      await dio.download(
        "http://103.69.126.198:8080/odata/Product/GetDocumentByAuther/"+widget.id+"?filetype=epub",
        path,
        deleteOnError: true,
        onReceiveProgress: (receivedBytes, totalBytes) {
          print((receivedBytes / totalBytes * 100).toStringAsFixed(0));
          //Check if download is complete and close the alert dialog
          if (receivedBytes == totalBytes) {
            loading = false;
            setState(() {});
          }
        },
      );
    } else {
          //Check if download is complete and close the alert dialog
         
            loading = false;
            setState(() {});
          
    }
      
  
     // setState(() {});
    
  }


}