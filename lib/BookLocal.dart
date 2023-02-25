class BookLocal {
  String id;
  String name;
  String filePath;
  String price;
  String size;
  String link;

  BookLocal({this.id, this.name, this.price, String link, this.size});

  BookLocal.fromjson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? ' ';
    filePath = json['filePath'];
    size = json['size'];
  }
}
