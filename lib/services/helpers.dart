import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:verbyl_project/pages/music_player.dart';
import '../models/artist.dart';
import '../models/charts.dart';
import '../models/music_player.dart';
import '../models/song.dart';

MusicPlayerModel player = MusicPlayerModel();


//API calls made here
class Helpers{

  Future<String> getResponse(String query) async {
    query = query.trim().toLowerCase();
    var uri = Uri.parse("https://deezerdevs-deezer.p.rapidapi.com/search?q=$query");
    final response = await http.get( uri,
      headers: {
        "x-rapidapi-host" : "deezerdevs-deezer.p.rapidapi.com",
        "x-rapidapi-key" : "44ddcae731mshd3bec744261612cp10453fjsn107100f92202",
      },
    );
    print(response.body.runtimeType);
    return response.body;
  }

  Future<Songs> getData(String query) async {
    Songs? songs;
    final responseBody = await getResponse(query);
    songs = songFromJson(responseBody);
    print("getData:");
    print(responseBody);
    //debugPrint(songs.data![0].title.toString());
    //debugPrint(songs.data![0].artist?.name.toString());
    // var test = jsonDecode(response.body);
    // debugPrint(test["data"][0]["title"].toString());
    return songs;
  }

  Future<ArtistData> getArtistData(String query) async {
    ArtistData? artist;
    final responseBody = await getResponse(query);
    artist = artistFromJson(responseBody);
    debugPrint(artist.artistName.toString());
    debugPrint(artist.artistId.toString());
    debugPrint(artist.imageUrl.toString());
    return artist;
  }

  Future<List<ChartsDataShazam?>> getCharts(String countryCode,int limit) async {
    Charts? charts;
    ChartsDataShazam? temp;
    List<ChartsDataShazam?> chartsDataShazamList = [];
    final responseBody;

    countryCode = countryCode.trim().toUpperCase();

    var query = "https://shazam-core.p.rapidapi.com/v1/charts/country?country_code=$countryCode&limit=$limit";
    print("Query="+query);
    var uri = Uri.parse(query);
    final response = await http.get( uri,
      headers: {
        "x-rapidapi-host": "shazam-core.p.rapidapi.com",
        "x-rapidapi-key": "44ddcae731mshd3bec744261612cp10453fjsn107100f92202",
      },
    );

    print("After api call!!");
    responseBody = jsonDecode(response.body);
    print("respnseBody = "+responseBody.toString());

    print("Titles from getCharts: ");
    for(int i=0;i<20;++i){
      // titles.add(responseBody[i]["title"]);
      temp = ChartsDataShazam.fromJson(responseBody[i]);
      chartsDataShazamList.add(temp);
      print("temp: " + temp.title.toString());
    }

    return chartsDataShazamList;
  }

  Future<String> getSpotifyURL(String songName) async {
    String url;
    songName = songName.trim().toLowerCase();
    print("SONG : " + songName);
    // if(songName.length >= 20) songName = songName.substring(0,20);
    var uri = Uri.parse("https://spotify23.p.rapidapi.com/search/?q=$songName&type=tracks&offset=0&limit=10&numberOfTopResults=5");
    final response = await http.get( uri,
      headers: {
        "x-rapidapi-host" : "spotify23.p.rapidapi.com",
        "x-rapidapi-key" : "44ddcae731mshd3bec744261612cp10453fjsn107100f92202",
      },
    );
    final responseBody = jsonDecode(response.body);
    print(responseBody);
    url = responseBody["tracks"]["items"][0]["data"]["id"].toString();
    debugPrint("Spotify URL of " + songName + " : " + url);
    return url;
  }

  Future<String> predictMood(String songName, String deezerId) async {
    final resp = await http.post(Uri.parse("https://verbyl24.000webhostapp.com/getSong.php"),body: {
      "deezerid": deezerId,
    });
    var x = jsonDecode(resp.body);
    if(x.length != 0){
      print("From DB Mood");
      return x[0]['Mood'].toString().toUpperCase();
    }
    else{
      String spotifyURL = await getSpotifyURL(songName);
      final params = {"song": spotifyURL};
      var uri = Uri.parse("https://verbyl-heroku.herokuapp.com/predict");
      final response = await http.post(uri,body: params);
      final responseBody = jsonDecode(response.body);
      String mood = responseBody["mood"].toString();
      debugPrint("Mood of $songName : $mood");
      return mood;
    }
  }

  Future<ArtistAndSearchQueryResults> getSearchResults(String query) async {
    Songs songs = await getData(query);
    List<String> artistID = [];
    List<String> songUrl = [];
    List<Artist?> artist = [];
    for(int i=0;i<songs.data!.length;++i){
      if(songs.data![i].artist!.name.toString().toLowerCase().contains(query.toString().toLowerCase())){
        if(!artistID.contains(songs.data![i].artist!.id.toString()) && !songUrl.contains(songs.data![i].preview.toString())){
          artistID.add(songs.data![i].artist!.id.toString());
          songUrl.add(songs.data![i].preview.toString());
          artist.add(songs.data![i].artist);
        }
      }
    }
    bool flag = true;
    late List<Datum>? finalSongs = [];
    for(int i=0;i<songs.data!.length;++i){
      flag = true;
      for(int j=0;j<finalSongs.length;++j){
        if(songs.data![i].title.toString().toLowerCase() == finalSongs[j].title.toString().toLowerCase()){
          flag = false;
          break;
        }
      }
      if(flag) finalSongs.add(songs.data![i]);
    }
    return ArtistAndSearchQueryResults(artist,finalSongs);
  }

  // Future<ArtistData> getArtistData(String query) async {
  //   ArtistData? artist;
  //   Songs? songs;
  //   int? artistId;
  //   songs = await getData(query);
  //   artistId = songs.data![0].artist?.id;
  //   debugPrint("Artist Id : " + artistId.toString());
  //   var uri = Uri.parse("https://deezerdevs-deezer.p.rapidapi.com/artist/$artistId");
  //   final response = await http.get( uri,
  //     headers: {
  //       "x-rapidapi-host" : "deezerdevs-deezer.p.rapidapi.com",
  //       "x-rapidapi-key" : "44ddcae731mshd3bec744261612cp10453fjsn107100f92202",
  //     },
  //   );
  //   artist = artistFromJson(response.body);
  //   debugPrint(artist.toString());
  //   return artist;
  // }

  Future<List<Datum?>> getRecommendedSongs(String songName,String artistName) async {
    List<ChartsDataShazam?> finalList = [];
    var q = songName + " " + artistName;
    var fq="";
    for(int i=0;i<q.length;++i){
      if(q[i] == ' '){
        fq += "%20";
      }
      else {
        fq += q[i];
      }
    }
    var query = "https://shazam-core.p.rapidapi.com/v1/tracks/search?query=$fq";
    print("Query = " + query);
    var uri = Uri.parse(query);
    final response = await http.get( uri,
      headers: {
        "x-rapidapi-host": "shazam-core.p.rapidapi.com",
        "x-rapidapi-key": "44ddcae731mshd3bec744261612cp10453fjsn107100f92202",
      },
    );
    var id="-1";
    bool flag = true;
    var probableSongs = jsonDecode(response.body);
    for(int i=0;i<probableSongs.length;++i){
      if(songName.toLowerCase().trim() == probableSongs[i]["heading"]["title"].toString().toLowerCase().trim() &&
          artistName.toLowerCase().trim() == probableSongs[i]["heading"]["subtitle"].toString().toLowerCase().trim()){
        id = probableSongs[i]["id"];
        flag = false;
        break;
      }
    }
    if(flag){
      for(int i=0;i<probableSongs.length;++i){
        if(probableSongs[i]["heading"]["title"].toString().toLowerCase().trim().contains(songName.toLowerCase().trim()) &&
            probableSongs[i]["heading"]["subtitle"].toString().toLowerCase().trim().contains(artistName.toLowerCase().trim())){
          id = probableSongs[i]["id"];
          break;
        }
      }
    }
    if(id == "-1"){
      if(probableSongs.length > 0) {
        id = probableSongs[0]["id"];
      } else {
        return [];
      }
    }

    var idQuery = "https://shazam-core.p.rapidapi.com/v1/tracks/related?track_id=$id&limit=5";
    print("idQuery = " + idQuery);
    var iduri = Uri.parse(idQuery);
    final idResponse = await http.get( iduri,
      headers: {
        "x-rapidapi-host": "shazam-core.p.rapidapi.com",
        "x-rapidapi-key": "44ddcae731mshd3bec744261612cp10453fjsn107100f92202",
      },
    );

    var rsongs = jsonDecode(idResponse.body);
    for(int i=0;i<rsongs.length;++i){
      var temp = ChartsDataShazam.fromJson(rsongs[i]);
      finalList.add(temp);
    }
    print(finalList);
    // return finalList;

    List<Datum> finalDeezerList = [];
    for(var s in finalList){
      await getData(s!.title.toString()).then((value){
        if(value.data!.length == 0) {}
        else {
          finalDeezerList.add(value.data![0]);
        }
      }).onError((error, stackTrace) => null);
    }
    return finalDeezerList;

  }

}

class ArtistAndSearchQueryResults {
  final List<Artist?> artist;
  final List<Datum> songs;
  ArtistAndSearchQueryResults(this.artist, this.songs);
}
