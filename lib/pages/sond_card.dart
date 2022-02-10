import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbyl_project/models/song.dart';
import 'package:verbyl_project/pages/music_player.dart';

import '../theme.dart';

class SongCard extends StatefulWidget {
  final Datum songs;
  const SongCard({Key? key,required this.songs}) : super(key: key);

  @override
  _SongCardState createState() => _SongCardState();
}

class _SongCardState extends State<SongCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => MusicPlayer(song: widget.songs)));
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: 60,
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.songs.album!.cover.toString(),
                  height: 50,
                  width: 50,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 0.5 * size.width,
                    child: Text(
                      widget.songs.title.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                          color: textLight, fontSize: 16),
                    ),
                  ),
                  Row(
                    children: [
                      if (widget.songs.explicitLyrics == true)
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Container(
                            height: 14,
                            width: 14,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.all(
                                Radius.circular(2),
                              ),
                            ),
                            child: Center(
                                child: Text(
                                  "E",
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: bgDark,
                                  ),
                                )),
                          ),
                        )
                      else const SizedBox(),
                      SizedBox(
                        width: 0.5 * size.width,
                        child: Text(
                            widget.songs.artist!.name.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                                color: Colors.grey, fontSize: 14)),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: (){},
                icon: Icon(Icons.more_vert,color: textLight,),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
