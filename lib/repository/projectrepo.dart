import 'package:http/http.dart' as http;

class Repository{

final String baseurl="http://103.69.126.198:8080/odata/";
final String baseLoginurl="http://202.45.146.174/book/api/";

getAllBooks() async {
return  await http.get(Uri.parse(baseurl+"product"));
}
getImageByProductId(String productId) async{
return  await http.get(Uri.parse(baseurl+"Product/GetImagePath/"+productId));
}
getDocumentByProductId(String productId) async{
return  await http.get(Uri.parse(baseurl+"Product/GetDocumentByAuther/"+productId));
}
getBookById(String id) async{
return await http.get(Uri.parse(baseurl+"product/" +id.toString()));
}
getBookByCategory(String id) async{
  return await http.get(Uri.parse(baseurl +"category/"+id));

}
getFeaturedBook() async{
return await http.get(Uri.parse(baseurl+"Product/GetFeaturedProduct/FeaturedBooks"));

}
getWriterName(String id) async{
return  await http.get(Uri.parse(baseurl+"Manufacturer/"+id));

}
getBookByWriterName(String id) async{
return  await http.get(Uri.parse(baseurl+"Product/GetProductByAuther/"+id));
}

getFreeBook() async{
return  await http.get(Uri.parse(baseurl+"product"));

}
getRecentBook() {
return   http.get(Uri.parse(baseurl+"Product/GetProductByCategory/RecentBooks"));

}

login(data) async{
return await http.post(Uri.parse(baseLoginurl +"Account/Login"), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: data
    
    );
}
}