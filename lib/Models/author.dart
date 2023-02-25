
import 'package:bookapp/Models/Category.dart';
class Author{
String id;
String name;


// Map<String, dynamic> toJson()=>{
//   'Id':id,
//   'Name':name,
//   'Category':Category
//   //'AudioPath':audioPath
  
// };
Author({this.id,this.name});
Author.fromjson(Map<String,dynamic> json)
{

  id=json["ManufacturerId"];
  name=json['Name']??' ';


 
}
}