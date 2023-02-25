class Category{
int id;
String categoryName;
String description;
 Category({this.id,this.categoryName,this.description});
Category.fromjson(Map<String,dynamic> json)
{
   

  id=json["value"]['id'];
  categoryName=json["value"]['name'];
  description=json["value"]['description']??' ';



 // audioPath=json['AudioPath']??' ';
 
}


}