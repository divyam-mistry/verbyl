import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbyl_project/pages/song_card.dart';
import 'package:verbyl_project/services/data.dart';
import '../models/song.dart';
import '../theme.dart';
import 'mini_music_player.dart';

class RecentlyPlayed extends StatefulWidget {
  const RecentlyPlayed({Key? key}) : super(key: key);

  @override
  _RecentlyPlayedState createState() => _RecentlyPlayedState();
}

class _RecentlyPlayedState extends State<RecentlyPlayed> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      persistentFooterButtons: const [
        MiniMusicPlayer(),
      ],
      backgroundColor: bgDark,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Recently Played",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: textLight,
                  ) //TextStyle
                  ),
              background: Center(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade900,
                        Colors.blueAccent.shade400,
                        Colors.blueAccent.shade100,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ), //FlexibleSpaceBar
            expandedHeight: 200,
            backgroundColor: Colors.blueAccent.shade400,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ), //IconButton//<Widget>[]
          ), //SliverAppBar
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 500,
                child: FutureBuilder(
                  future: getRecentlyPlayed(),
                  builder: (ctx, ss) {
                    if (ss.hasData &&
                        ss.connectionState == ConnectionState.done) {
                      RPSongsAndDateList rp = ss.data as RPSongsAndDateList;
                      List<Datum> songList = rp.songs;
                      List<DateTime> dateList = rp.dates;
                      print(songList.length);
                      print(dateList.length);
                      List<int> isAlreadyPrinted = [];
                      isAlreadyPrinted.add(0);
                      for(int i = 1; i<dateList.length; i++){
                        if(dateList[i].day != dateList[i-1].day ){
                          isAlreadyPrinted.add(i);
                        }
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            String dateTimeText = dateList[index].toString().substring(0,10);
                            if(dateList[index].day == DateTime.now().day && dateList[index].month == DateTime.now().month)
                              dateTimeText = "Today";
                            return Column(
                              children: [
                                (isAlreadyPrinted.contains(index)) ? Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Align(
                                    child: Text(dateTimeText,
                                      style: GoogleFonts.montserrat(color: textLight,fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    alignment: Alignment.topLeft,
                                  ),
                                ) : const SizedBox(),
                                SongCard(songs: songList[index])
                              ],
                            );
                          },
                          itemCount: songList.length,
                        ),
                      );
                    }
                    if (ss.hasError) {
                      print(ss.error.toString());
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Colors.red,
                      ));
                    }
                    return Center(
                        child: CircularProgressIndicator(
                      color: primary,
                    ));
                  },
                ),
              ),
            ]),
          ),
        ],
      ),
    ));
  }
}
