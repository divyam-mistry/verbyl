import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbyl_project/pages/song_card.dart';
import 'package:verbyl_project/services/helpers.dart';
import 'package:verbyl_project/models/song.dart';
import '../models/general.dart';
import '../theme.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  void initState() {
    //Helpers().predictMood("Blinding Lights");
    super.initState();
  }

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
            const SizedBox(
              height: 15,
            ),
            Text(
              "Search",
              style: TextStyle(
                color: textLight,
                fontSize: 26,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () {
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
                    const SizedBox(
                      width: 15,
                    ),
                    Icon(
                      Icons.search_rounded,
                      color: Colors.grey.shade700,
                      size: 30,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Songs or Artists",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            _makeMoodButton(
              mood: "Happy",
              clr: Colors.redAccent,
              onPressed: (){}
            ),
            _makeMoodButton(
                mood: "Energetic",
                clr: Colors.deepPurple,
                onPressed: (){}
            ),
            _makeMoodButton(
                mood: "Sad",
                clr: const Color(0xFF211d22),
                onPressed: (){}
            ),
            _makeMoodButton(
                mood: "Calm",
                clr: const Color(0xFF00b9bc),
                onPressed: (){}
            ),
          ],
        ),
      ),
    );
  }

  Widget _makeMoodButton({required String mood,required Function() onPressed,required Color clr}){
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            width: size.width,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  clr,
                  clr.withOpacity(0.8),
                  clr.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset('assets/images/${mood.toLowerCase().toString()}.png'),
                  ),
                ),
                Positioned(
                  left: 20,
                  bottom: 20,
                  child: Text(mood, style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: textLight,
                  ),),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15,),
        ],
      ),
    );
  }

}

class DataSearch extends SearchDelegate<String> {

  List<Artist?> artist = [];
  List<Datum> songs = [];

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
          onPressed: () {
            query = "";
            artist.clear();
            songs.clear();
          },
          icon: const Icon(Icons.clear_rounded)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        searchedSong = "";
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    artist = [];
    songs = [];
    return Scaffold(
      backgroundColor: bgDark,
      body: (artist.isEmpty && songs.isEmpty)
          ? FutureBuilder(
              future: Helpers().getSearchResults(query),
              builder: (ctx, ss) {
                if (ss.connectionState == ConnectionState.done && ss.hasData) {
                  var artistAndSongs = ss.data as ArtistAndSearchQueryResults;
                  artist = artistAndSongs.artist;
                  songs = artistAndSongs.songs;
                  return ListView.builder(
                      itemCount: artist.length + songs.length,
                      itemBuilder: (ctx, i) {
                        if (i < artist.length) return ArtistCard(artist: artist[i]!);
                        return SongCard(songs: songs[i - artist.length]);
                      }
                    );
                }
                if(query.isEmpty) return buildSuggestions(context);
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          : ListView.builder(
              itemCount: artist.length + songs.length,
              itemBuilder: (ctx, i) {
                if (i < artist.length) return ArtistCard(artist: artist[i]!);
                return SongCard(songs: songs[i - artist.length]);
              }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionsList = query.isEmpty
        ? recentSongs
        : songList
            .where((s) => s.name.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
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
                    child: Text(
                      "Suggestions",
                      style: TextStyle(
                        fontSize: 18,
                        color: textLight,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                )
              : const SizedBox(
                  height: 10,
                ),
          suggestionsList.isNotEmpty
              ? SizedBox(
                  height: 300,
                  child: ListView.builder(
                      itemCount: suggestionsList.length,
                      itemBuilder: (ctx, i) {
                        return ListTile(
                          leading: Icon(
                            Icons.music_note_rounded,
                            color: textLight,
                          ),
                          title: RichText(
                            text: TextSpan(
                              text: suggestionsList[i]
                                  .name
                                  .substring(0, query.length),
                              style: GoogleFonts.montserrat(
                                color: textLight,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: suggestionsList[i]
                                      .name
                                      .substring(query.length),
                                  style: GoogleFonts.montserrat(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            query = suggestionsList[i].name.toString();
                            debugPrint(searchedSong =
                                suggestionsList[i].name.toString());
                            showResults(context);
                          },
                        );
                      }),
                )
              : const Center(
                  child: SizedBox(
                    height: 50,
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "No songs found !",
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
