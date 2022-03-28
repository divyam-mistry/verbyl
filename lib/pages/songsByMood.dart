import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbyl_project/pages/song_card.dart';
import 'package:verbyl_project/services/data.dart';

import '../models/song.dart';
import '../theme.dart';
import 'mini_music_player.dart';

class SongsByMood extends StatefulWidget {
  final Color color;
  final String mood;
  const SongsByMood({Key? key, required this.color, required this.mood})
      : super(key: key);

  @override
  _SongsByMoodState createState() => _SongsByMoodState();
}

class _SongsByMoodState extends State<SongsByMood> {
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
                title: Text(widget.mood.toString() + " Songs",
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: textLight,
                    ) //TextStyle
                    ),
                background: Center(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black54,
                          Colors.black38,
                          Colors.transparent,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
              ), //FlexibleSpaceBar
              expandedHeight: 200,
              backgroundColor: widget.color,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ), //<Widget>[]
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(
                  height: 500,
                  child: FutureBuilder(
                    future: getSongsByMood(widget.mood.toString()),
                    builder: (ctx, ss) {
                      if (ss.hasData &&
                          ss.connectionState == ConnectionState.done) {
                        List<Datum> songList = ss.data as List<Datum>;
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            return SongCard(songs: songList[index]);
                          },
                          itemCount: songList.length,
                        );
                      }
                      if (ss.hasError) return const SizedBox();
                      return Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: SizedBox(
                            child: CircularProgressIndicator(
                              color: primary,
                            ),
                            height: 30,
                            width: 30,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
