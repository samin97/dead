import 'dart:convert';

import 'package:bookapp/Models/LoginModel.dart';
import 'package:bookapp/repository/projectrepo.dart';

class BookService{

Repository _repository;
BookService(){
  _repository=Repository();
}
getallbook() async{
  return  await _repository.getAllBooks();
}
getrecentbook() {
  return  _repository.getRecentBook();
}
getBookById(String id)  async{
  return await _repository.getBookById(id);
}
getimagepath(String id) async
{
return await _repository.getImageByProductId(id);
}
getWriterName(String id) async
{
return await _repository.getWriterName(id);
}
getBookByWriterName(String id) async
{
return await _repository.getBookByWriterName(id);
}
getBookByCategory(String id) async{
  return await _repository.getBookByCategory(id);
}
getFeaturedBook() async{
  return await _repository.getAllBooks();
}
getFreeBook() async{
  return await _repository.getFreeBook();
}

getDocumentByProductId(String productId) async{
  return await _repository.getDocumentByProductId(productId);
}
login(LoginModel data) async{
  return await _repository.login(json.encode(data.toJson()));
}
}