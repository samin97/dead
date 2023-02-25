class LoginModel{
        String email;
        String password;

Map<String, dynamic> toJson()=>{
  'Email':email,
  'Password':password,

 
  
};
LoginModel({this.email,this.password});

LoginModel.fromjson(Map<String,dynamic> json)
{
  email=json['Email'];

  password=json['Password']??'';


}

}