import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/artist.dart';
import '../models/playlist.dart';
import '../models/song.dart';
import 'helpers.dart';

int uid = 0;
String cityId = "0";
late String verbylUserName, verbylUserEmail;
String verbylUserLocation = "";
bool isLocationPermissionDenied = true;
List<Playlist> playlist = [];
bool topHits = false, followArtists = false;

List<Datum> topSongsList = [];
List<ArtistData> artistList = [];

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

Future<List<Datum>> getPlaylistSongs(String pid) async {
  List<Datum> songs = [];
  final response = await http.post(Uri.parse("https://verbyl24.000webhostapp.com/getPlaylistSongs.php"), body: {
    "uid": uid.toString(),
    "pid": pid.toString(),
  });
  var t = jsonDecode(response.body);
  for(var x in t){
    await Helpers().getData(x["Name"].toString()).then((value){
      songs.add(value.data![0]);
    });
  }
  return songs;
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

Future<void> uploadCity(String? city) async {
  print(city);
  final resp1 = await http.post(Uri.parse("https://verbyl24.000webhostapp.com/uploadCity.php"), body: {
    "name": city,
  });
  cityId = resp1.body.toString();
  print(resp1.body);
  return;
}

Future<void> addSongToDB(Datum song, String? cityId, String mood) async {
  String artistID, deezerID, songName;
  artistID = song.artist!.id.toString();
  deezerID = song.id.toString();
  songName = song.title.toString();
  final resp1 = await http.post(Uri.parse("https://verbyl24.000webhostapp.com/uploadSong.php"), body: {
    "artistid": artistID,
    "deezerid": deezerID,
    "name": songName,
    "mood": mood,
  });
  print(resp1.body);
  final resp2 = await http.post(Uri.parse("https://verbyl24.000webhostapp.com/updateCounter.php"), body: {
    "deezerid": deezerID,
    "cid": cityId,
  });
  print("done");
}

Future<void> addSongToRecentlyPlayed(Datum song, String? cityId, String mood, DateTime creationDate) async {
  String dateTime = (creationDate.day.toString() + "-" + creationDate.month.toString() + "-" +
      creationDate.year.toString() + " " + creationDate.hour.toString() + "h " + creationDate.minute.toString() + "m");
  String deezerID = song.id.toString();
  final resp1 = await http.post(Uri.parse("https://verbyl24.000webhostapp.com/addSongToRecentlyPlayed.php"), body: {
    "uid": uid.toString(),
    "cid": cityId.toString(),
    "deezerid": deezerID,
    "date": dateTime.toString(),
  });
  await addSongToDB(song, cityId, mood);
}

Future<List<Datum>> getRecentlyPlayed() async {
  final resp1 = await http.post(Uri.parse("https://verbyl24.000webhostapp.com/getUserRecentlyPlayed.php"), body: {
    "uid": uid.toString(),
  });
  print(resp1.body);
  var s = jsonDecode(resp1.body);
  List<Datum> songs = [];
  for(int i = 1; i<songs.length; i++){
    await Helpers().getData(s["DeezerId"].toString()).then((value){
      songs.add(value.data![0]);
    });
  }
  print("returned songs");
  return songs;
}

Future<void> addSongToPlaylists(Datum song, List<Playlist> playlists) async {
  for(var x in playlists){
    final resp = await http.post(Uri.parse("https://verbyl24.000webhostapp.com/addSongToPlaylist.php"), body: {
      "pid": x.pid.toString(),
      "deezerid": song.id.toString(),
    });
    print(resp.body);
  }
}

Future<List<Datum>> getSongsByMood(String mood) async {
  List<Datum> songList = [];
  final resp = await http.post(Uri.parse("https://verbyl24.000webhostapp.com/getSongsByMood.php"), body: {
    "mood": mood,
  });
  var x = jsonDecode(resp.body);
  for(var s in x){
    await Helpers().getData(s["Name"].toString()).then((value){
      songList.add(value.data![0]);
    });
  }
  return songList;
}

Future<List<ArtistData>> getUserFollowingArtists() async {
  List<ArtistData> artistList = [];
  final resp1 = await http.post(Uri.parse("https://verbyl24.000webhostapp.com/getUserFollowingArtists.php"), body: {
    "uid": uid.toString(),
  });
  print(resp1.body);
  var list = jsonDecode(resp1.body);
  for(var x in list){
    await Helpers().getArtistData(x["Name"].toString()).then((value){
      artistList.add(value);
    });
  }
  followArtists = true;
  return artistList;
}

Future<void> followArtist(String artistId, String artistName) async {
  print(artistId);
  final resp1 = await http.post(Uri.parse("https://verbyl24.000webhostapp.com/uploadUserFollowedArtist.php"), body: {
    "uid": uid.toString(),
    "artistid": artistId,
  });
  print(resp1.body);
  final resp2 = await http.post(Uri.parse("https://verbyl24.000webhostapp.com/uploadArtist.php"), body: {
    "artistdeezerid": artistId,
    "name": artistName,
  });
  return;
}

Future<void> unfollowArtist(String artistId) async {
  print(artistId);
  final resp1 = await http.post(Uri.parse("https://verbyl24.000webhostapp.com/removeUserFollowedArtist.php"), body: {
    "uid": uid.toString(),
    "artistid": artistId,
  });
  print(resp1.body);
  return;
}

Future<void> likeSong(String deezerId) async {
  print(deezerId);
  final resp1 = await http.post(Uri.parse("https://verbyl24.000webhostapp.com/uploadUserLikedSong.php"), body: {
    "uid": uid.toString(),
    "deezerid": deezerId,
  });
  print(resp1.body);
  return;
}

Future<void> unlikeSong(String deezerId) async {
  print(deezerId);
  final resp1 = await http.post(Uri.parse("https://verbyl24.000webhostapp.com/removeUserLikedSong.php"), body: {
    "uid": uid.toString(),
    "deezerid": deezerId,
  });
  print('unliked songs');
  return;
}

Future<List<Datum>> getLikedSongs() async {
  final resp1 = await http.post(Uri.parse("https://verbyl24.000webhostapp.com/getUserLikedSongs.php"), body: {
    "uid": uid.toString(),
  });
  print(resp1.body);
  var s = jsonDecode(resp1.body);
  List<Datum> songs = [];
  for(var x in s){
    await Helpers().getData(x["Name"].toString()).then((value){
      songs.add(value.data![0]);
    });
  }
  print("returned songs");
  return songs;
}

Future<List<Datum>> getTopSongsByLocation(String cid) async {
  List<Datum> songList = [];
  if(cid == "0") return songList;
  final resp1 = await http.post(Uri.parse("https://verbyl24.000webhostapp.com/getTop5City.php"), body: {
    "cityid": cid,
  });
  var list = jsonDecode(resp1.body);
  for(var x in list){
    await Helpers().getData(x["Name"].toString()).then((value){
      songList.add(value.data![0]);
    });
  }
  topHits = true;
  print(resp1.body);
  return songList;
}

Future<List<int>> getMoodStats() async {
  final response = await http.post(Uri.parse("https://verbyl24.000webhostapp.com/getMoodStats.php"),body: {
    "uid": uid.toString(),
  });
  var t = jsonDecode(response.body);
  List<int> list = [];
  list.add(int.parse(t[0]["Happy"]));
  list.add(int.parse(t[1]["Energetic"]));
  list.add(int.parse(t[2]["Calm"]));
  list.add(int.parse(t[3]["Sad"]));
  print(list);
  return list;
}

var test;
Future<bool> testFunction() async {
  final response = await http.post(Uri.parse("https://verbyl24.000webhostapp.com/getCities.php"));
  test = jsonDecode(response.body);
  return true;
}



