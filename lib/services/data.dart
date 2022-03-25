import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/playlist.dart';

int uid = 0;
late String verbylUserName, verbylUserEmail;
String verbylUserLocation = "";
bool isLocationPermissionDenied = true;
List<Playlist> playlist = [];


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

Future<void> getUserPlaylists(String uid) async {
  playlist = [];
  final response = await http.post(Uri.parse("https://verbyl24.000webhostapp.com/getUserPlaylists.php"),body: {
    "uid":uid
  });
  debugPrint(response.body);
  debugPrint("hi 1");
  var v = jsonDecode(response.body);
  debugPrint("hi 2");
  print(v.length.toString());
  print(playlist.length.toString());
  for(int i=0;i<v.length;++i){
    print("added" + i.toString());
    var t = Playlist.fromJson(v[i]);
    print("t="+t.toString());
    playlist.add(t);
    print("added here" + i.toString());
  }
  print(playlist.length.toString());
  print("hi 3");
  for(int i=0;i<playlist.length;++i){
    print(playlist[i].pid.toString());
  }
  debugPrint("hi 4");
  return;
}

Future<bool> addUserPlaylists(String uid, String playlistName, DateTime creationDate) async {
  String dateTime = (creationDate.day.toString() + "-" + creationDate.month.toString() + "-" +
      creationDate.year.toString() + " " + creationDate.hour.toString() + "h " + creationDate.minute.toString() + "m");
  final response = await http.post(Uri.parse("https://verbyl24.000webhostapp.com/uploadUserPlaylist.php"),body: {
    "uid": uid,
    "name": playlistName,
    "creationdate": dateTime,
  });
  if(response.body == "error") return false;
  return true;
}



