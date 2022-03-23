import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbyl_project/pages/song_card.dart';
import '../models/song.dart';
import '../theme.dart';
import 'mini_music_player.dart';

class RecentlyPlayed extends StatefulWidget {
  List<Datum> songs;
  RecentlyPlayed({Key? key,required this.songs}) : super(key: key);

  @override
  _RecentlyPlayedState createState() => _RecentlyPlayedState();
}

class _RecentlyPlayedState extends State<RecentlyPlayed> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
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
            expandedHeight: 240,
            backgroundColor: Colors.blueAccent.shade400,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ), //IconButton
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ), //IconButton
            ], //<Widget>[]
          ), //SliverAppBar
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => SongCard(
                songs: widget.songs[index],
              ),
              childCount: widget.songs.length,
            ),
          )
        ],
      ),
    ));
  }
}
