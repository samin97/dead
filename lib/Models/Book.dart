import 'package:bookapp/Models/Category.dart';
import 'package:bookapp/Models/author.dart';

class Book {
  String id;
  String name;
  Category category;
  String imagePath;
  String filePath;
  String writerName;
  String shortDescription;
  String price;
  Author author;

// Map<String, dynamic> toJson()=>{
//   'Id':id,
//   'Name':name,
//   'Category':Category
//   //'AudioPath':audioPath

// };
  Book(
      {this.id,
      this.name,
      this.category,
      this.imagePath,
      this.filePath,
      this.shortDescription,
      this.price,
      this.author,
      this.writerName});

  Book.fromjson(Map<String, dynamic> json) {
    id = json["Id"];
    name = json['Name'] ?? ' ';
    shortDescription = json['ShortDescription'];
    if (json['Manufacturers'].length > 0)
      author = Author.fromjson(json['Manufacturers'][0]);
    // audioPath=json['AudioPath']??' ';
  }
}
