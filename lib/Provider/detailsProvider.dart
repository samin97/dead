import 'dart:io';

import 'package:bookapp/Components/downloadalert.dart';
import 'package:bookapp/Database/downloaddb.dart';
import 'package:bookapp/Enums/Constants.dart';
import 'package:bookapp/Models/Book.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/category.dart';

class DetailsProvider extends ChangeNotifier {
  bool loading = true;
  Book entry;
  var dlDB = DownloadsDB();

  bool faved = false;
  bool downloaded = false;

  // getFeed(String url) async {
  //   setLoading(true);
  //   checkFav();
  //   checkDownload();
  //   try {
  //     CategoryFeed feed = await api.getCategory(url);
  //     setRelated(feed);
  //     setLoading(false);
  //   } catch (e) {
  //     throw (e);
  //   }
  // }

  // check if book is favorited
  // checkFav() async {
  //   List c = await favDB.check({'id': entry.id.t.toString()});
  //   if (c.isNotEmpty) {
  //     setFaved(true);
  //   } else {
  //     setFaved(false);
  //   }
  // }

  // addFav() async {
  //   await favDB.add({'id': entry.id.t.toString(), 'item': entry.toJson()});
  //   checkFav();
  // }

  // removeFav() async {
  //   favDB.remove({'id': entry.id.t.toString()}).then((v) {
  //     print(v);
  //     checkFav();
  //   });
  // }

  // check if book has been downloaded before
  checkDownload() async {
    List downloads = await dlDB.check({'id': entry.id.toString()});
    if (downloads.isNotEmpty) {
      //print("download ma xir xa");
      // check if book has been deleted
      String path = downloads[0]['path'];
      print(path);
      if(await File(path).exists()){
        downloaded=true;
                print("download true");

        setDownloaded(true);
      }else{
        print("exist xaina ayo");
        setDownloaded(false);
      }
    } else {
            print("download ma kai xaina");

      setDownloaded(false);
    }
  }

  Future<List> getDownload() async {
    List c = await dlDB.check({'id': entry.id.toString()});
    return c;
  }

  addDownload(Map body) async {
    //await dlDB.removeAllWithId({'id': entry.id.toString()});
    await dlDB.add(body);
    checkDownload();
  }

  removeDownload() async {
    dlDB.remove(entry.id.toString()).then((v) {
      print(v);
      checkDownload();
    });
  }

  Future downloadFile(BuildContext context, String url, String filename) async {
    PermissionStatus permission = await Permission.storage.status;

    if (permission != PermissionStatus.granted) {
      await Permission.storage.request();
      startDownload(context, url, filename);
    } else {
      startDownload(context, url, filename);
    }
  }

  startDownload(BuildContext context, String url, String filename) async {
    Directory appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

   
  PermissionStatus permission = await  Permission.storage.status;

    if (permission == PermissionStatus.granted) {
    String path = appDocDir.path + '/$filename.epub';
        final paths= Directory(appDocDir.path);
if ((await paths.exists())) {
  } else {
    paths.create();
  }
    print(path);
    File file = File(path);
    if (!await file.exists()) {
      await file.create();
    } else {
      await file.delete();
      await file.create();
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => DownloadAlert(
        url: "http://103.69.126.198:8080/odata/Product/GetDocumentByAuther/"+filename+"?filetype=epub",
        path: path,
      ),
    ).then((v) {
      // When the download finishes, we then add the book
      // to our local database
      if (v != null) {
        print(entry);
        addDownload(
          {
            'id': entry.id.toString(),
            'path': path,
            'image': "http://103.69.126.198:8080"+'${entry.imagePath}',
            'size': v,
            'name': entry.name,
          },
        );
      }
    });
 checkDownload();
  }
  }

  void setLoading(value) {
    loading = value;
    notifyListeners();
  }

  // void setRelated(value) {
  //   related = value;
  //   notifyListeners();
  // }

  // CategoryFeed getRelated() {
  //   return related;
  // }

  void setEntry(value) {
    entry = value;
    notifyListeners();
  }

  void setFaved(value) {
    faved = value;
    notifyListeners();
  }

  void setDownloaded(value) {
    downloaded = value;
    print(value);
    notifyListeners();
  }
}
