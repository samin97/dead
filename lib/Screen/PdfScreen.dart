// import 'dart:convert';

// import 'package:bookapp/Models/Document.dart';
// import 'package:bookapp/Screen/loadingScreen.dart';
// import 'package:bookapp/Service/BookServices.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// /// Represents Homepage for Navigation
// class PDFScreen extends StatefulWidget {
//   @override
//   _PdfScreen createState() => _PdfScreen();
//     String pathPDF = "";
//   String title = "";
// String id="";

//   PDFScreen(this.id);
// }
// bool isLoading=true;
// class _PdfScreen extends State<PDFScreen> {
  
//   final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
// PdfViewerController _pdfViewerController;
// double a=1.0;

//  BookService c=BookService();
//  Document book = new Document();
// _getBooks() async{
    
//  // var a= await http.get("http://202.45.146.174/lumbini/api/inventory"); 
//    var a=await c.getDocumentByProductId(widget.id);
   
 
//     if (a != null) {
//       var data = json.decode(a.body);
//       print(data);
//         data.forEach((blogPost) async {
//         var model = Document();

//         model=Document.fromjson(blogPost);
// if(model.link==".pdf")
// {
       
//         setState(() {
//           book=model;
         
//           isLoading=false;
//       });
// }

//     });
                

    
 
//   }
// }


//   @override
//   void initState() {
    
// if (_pdfViewerController == null) {
//         _pdfViewerController = PdfViewerController(); // Instantiate the object if its null.
//     }
//      _getBooks();
//     super.initState();

//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('my PDF Viewer'),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(
//               Icons.bookmark,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               _pdfViewerKey.currentState?.openBookmarkView();
//             },
//           ),
//            IconButton(
//             icon: Icon(
//               Icons.zoom_in,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               a=a+0.25;
//             _pdfViewerController.zoomLevel = a;

//             },
//           ),
//                   IconButton(
//             icon: Icon(
//               Icons.zoom_out,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               a=a-0.25;
//             _pdfViewerController.zoomLevel = a;

//             },
//           ),

//       ],
       
       
//       ),
//       body:(isLoading)?LoadingWidget(): SfPdfViewer.network(
//         "http://103.69.126.198:8080/"+book.downloadId,
//         key: _pdfViewerKey,
//      controller: _pdfViewerController,
//      enableDoubleTapZooming: true

//       ),
//     );
//   }
// }

