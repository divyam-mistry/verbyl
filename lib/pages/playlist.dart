import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbyl_project/pages/mini_music_player.dart';
import 'package:verbyl_project/pages/song_card.dart';

import '../models/general.dart';
import '../services/helpers.dart';
import '../models/song.dart';
import '../theme.dart';
import 'search.dart';

class PlaylistPage extends StatefulWidget {
  final Playlist playlist;
  final List<Datum> songs;
  const PlaylistPage({
    Key? key,
    required this.playlist,
    required this.songs
  }) : super(key: key);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  // bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print("From Before Return:");
    print(widget.songs[0].title);
    return SafeArea(
        child: Scaffold(
          backgroundColor: bgDark,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset("assets/images/playlist.png",width: size.width),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: widget.playlist.name.toString() + "\n",
                                style: GoogleFonts.montserrat(color: textLight,fontSize: 24),
                                children: [
                                  TextSpan(
                                      text: widget.playlist.songs!.length.toString() + " songs",
                                      style: GoogleFonts.montserrat(color: Colors.grey.shade400,fontSize: 16),
                                  ),
                                ]
                              ),
                            ),
                            SizedBox(
                              height: 80,
                              width: 80,
                              child: IconButton(
                                onPressed: (){
                                  player.queue.loadSongs(widget.songs);
                                  player.isPlaying = !player.isPlaying;
                                  setState(() {
                                  });
                                },
                                icon: Icon(
                                  // isPlaying
                                  //     ? CupertinoIcons.pause_circle_fill
                                  //     :
                                  CupertinoIcons.play_circle_fill,
                                  size: 60,
                                  color: textLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 470,
                      child: FutureBuilder(
                          future: Helpers().getData("hailee"),
                          builder: (ctx,snapshot){
                            if(snapshot.hasError){
                              return const Center(child: CircularProgressIndicator(color: Colors.red,));
                            }
                            else if(snapshot.connectionState == ConnectionState.done){
                              final songs = snapshot.data! as Songs;
                              return ListView.builder(
                                  itemCount: 10,
                                  itemBuilder: (ctx,i){
                                    return SongCard(songs: songs.data![i]);
                                  }
                              );
                            }
                            return const Center(child: CircularProgressIndicator());
                          }
                      ),
                    ),
                    const SizedBox(height: 5,),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios,color: textLight,),
              )),
            ],
          ),
          persistentFooterButtons: [
            MiniMusicPlayer()
          ],
        ),
    );
  }
}

