
import 'package:bookapp/Models/Category.dart';
class Document{
String id;
String downloadId;
String link;


// Map<String, dynamic> toJson()=>{
//   'Id':id,
//   'Name':name,
//   'Category':Category
//   //'AudioPath':audioPath
  
// };
Document({this.id,this.downloadId,this.link});
Document.fromjson(Map<String,dynamic> json)
{

  id=json["Id"];
  downloadId=json['DownloadId']??' ';
link=json['Link'];

 // audioPath=json['AudioPath']??' ';
 
}
}