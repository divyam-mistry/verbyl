import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:verbyl_project/models/song.dart';
import 'package:verbyl_project/pages/music_player.dart';
import '../models/general.dart';
import '../theme.dart';

Songs? _songs;

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

Future<Songs> getData(String query) async {
  query = query.trim().toLowerCase();
  var uri = Uri.parse("https://deezerdevs-deezer.p.rapidapi.com/search?q=$query");
  final response = await http.get( uri,
    headers: {
      "x-rapidapi-host" : "deezerdevs-deezer.p.rapidapi.com",
      "x-rapidapi-key" : "44ddcae731mshd3bec744261612cp10453fjsn107100f92202",
    },
  );
  _songs = songFromJson(response.body);
  debugPrint(_songs!.data![0].title.toString());
  debugPrint(_songs!.data![0].artist?.name.toString());
  // var test = jsonDecode(response.body);
  // debugPrint(test["data"][0]["title"].toString());
  return _songs!;
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgDark,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15,),
            Text("Search",
              style: TextStyle(
                color: textLight,
                fontSize: 26,
              ),
            ),
            const SizedBox(height: 25,),
            GestureDetector(
              onTap: (){
                showSearch(context: context, delegate: DataSearch());
              },
              child: Container(
                height: 60,
                width: 0.95 * size.width,
                decoration: BoxDecoration(
                  color: textLight,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 15,),
                    Icon(Icons.search_rounded,
                      color: Colors.grey.shade700,
                      size: 30,
                    ),
                    const SizedBox(width: 15,),
                    Text("Songs or Artists",style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 20,
                    ),),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25,),
            FutureBuilder(
              future: getData("Blinding Lights"),
              builder: (ctx,snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  if(snapshot.hasData){
                    final data = snapshot.data as Songs;
                    return Text(data.data![0].title.toString() + "\n" + data.data![0].artist!.name.toString(),
                      style: TextStyle(fontSize: 18,color: textLight),
                    );
                  }
                  else if(snapshot.hasError){
                    return Text( "Snapshot.error = " + snapshot.error.toString(),
                      style: TextStyle(fontSize: 18,color: textLight),
                    );
                  }
                  else {
                    return Text("Error",
                      style: TextStyle(fontSize: 18,color: textLight),);
                  }
                }
                else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String>{

  String searchedSong = "";

  final List<Song> songList = [
    Song(name: "Levitating", imageLink: ""),
    Song(name: "Let Me Go", imageLink: ""),
    Song(name: "Blinding Lights", imageLink: ""),
    Song(name: "Infinity", imageLink: ""),
    Song(name: "Peaches", imageLink: ""),
    Song(name: "Heat Waves", imageLink: ""),
  ];

  final List<Song> recentSongs = [
    Song(name: "Levitating", imageLink: ""),
    Song(name: "Let Me Go", imageLink: ""),
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
      return [
        IconButton(
            onPressed: (){
              query = "";
            },
            icon: const Icon(Icons.clear_rounded)
        ),
      ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
      return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: (){
          searchedSong = "";
          close(context, "");
        },
      );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: null,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionsList = query.isEmpty
        ? recentSongs
        : songList.where((s) => s.name.toLowerCase().startsWith(query.toLowerCase())).toList();
    return Scaffold(
      backgroundColor: bgDark.withOpacity(0.9),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          query.isEmpty
              ? SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("Recent Searches",
                      style: TextStyle(
                        fontSize: 18,
                        color: textLight,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                )
              : const SizedBox(height: 10,),
          suggestionsList.isNotEmpty
              ? SizedBox(
                height: 300,
                child: ListView.builder(
                    itemCount: suggestionsList.length,
                    itemBuilder: (ctx,i){
                      return ListTile(
                        leading: Icon(Icons.music_note_rounded,
                          color: textLight,
                        ),
                        title: RichText(
                          text: TextSpan(
                            text: suggestionsList[i].name.substring(0,query.length),
                            style: GoogleFonts.montserrat(
                              color: textLight,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: suggestionsList[i].name.substring(query.length),
                                style: GoogleFonts.montserrat(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: (){
                          debugPrint(searchedSong = suggestionsList[i].name.toString());
                          showResults(context);
                        },
                      );
                    }
            ),
          )
              : const Center(
                child: SizedBox(
                    height: 50,
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text("No songs found !",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
              ),
        ],
      ),
    );
  }

}
