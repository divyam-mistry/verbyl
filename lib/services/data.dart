import 'dart:convert';
import 'package:http/http.dart' as http;

int uid = 0;
late String verbylUserName, verbylUserEmail;

Future<void> sendUserData(String name,String email) async {
  final response = await http.post(Uri.parse("https://verbyl24.000webhostapp.com/createUser.php"),body: {
    "name" : name,
    "email" : email
  });
  uid = int.parse(response.body);
}

Future<void> getUserData(String email) async {
  print("getUserData");
  final response = await http.post(Uri.parse("https://verbyl24.000webhostapp.com/getUser.php"),body: {
    "email" : email
  });
  var user = jsonDecode(response.body);
  uid = int.parse(user[0]["UId"]);
  verbylUserName = user[0]["Name"];
  verbylUserEmail = user[0]["Email"];
  print(verbylUserName + " " + verbylUserEmail + " " + uid.toString());
}



