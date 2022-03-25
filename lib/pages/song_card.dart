import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbyl_project/models/charts.dart';
import 'package:verbyl_project/models/song.dart';
import 'package:verbyl_project/pages/artistPage.dart';
import 'package:verbyl_project/pages/music_player.dart';
import 'package:verbyl_project/services/helpers.dart';
import '../services/data.dart';
import '../theme.dart';

class SongCard extends StatefulWidget {
  final Datum songs;
  const SongCard({Key? key, required this.songs}) : super(key: key);

  @override
  _SongCardState createState() => _SongCardState();
}

class _SongCardState extends State<SongCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String imageUrl = widget.songs.album!.cover.toString();
    return GestureDetector(
      onTap: () {
        player.queue.loadSoloTrack(widget.songs);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => const MusicPlayer()));
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
                child:
                (imageUrl.isEmpty || imageUrl == "null")
                    ? Image.asset('assets/images/placeholder.png',
                  fit: BoxFit.fill,
                  height: 50,
                  width: 50,
                )
                    : Image.network(
                  imageUrl,
                  fit: BoxFit.fill,
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
                      else
                        const SizedBox(),
                      SizedBox(
                        width: 0.5 * size.width,
                        child: Text(widget.songs.artist!.name.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                                color: Colors.grey, fontSize: 14)),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert,color: textLight,),
                onSelected: (value) {
                  switch (value) {
                    case 'View Artist':
                      print("View Artist");
                      Helpers()
                          .getArtistData(widget.songs.artist!.name.toString())
                          .then((value) => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => ArtistPage(
                              artistData: value,
                              i: 0,
                            ),
                          ),
                        )
                      });
                      break;
                    case 'Add to Queue':
                      print("Add to Queue");
                      player.queue.addSong(widget.songs);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {
                    'View Artist',
                    'Add to Queue',
                  }.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
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

// ----

class ChartSongCard extends StatefulWidget {
  final ChartsDataShazam shazamSongData;
  final int index;
  const ChartSongCard(
      {Key? key, required this.shazamSongData, required this.index})
      : super(key: key);

  @override
  _ChartSongCardState createState() => _ChartSongCardState();
}

class _ChartSongCardState extends State<ChartSongCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String imageUrl = widget.shazamSongData.imageURL.toString();
    return GestureDetector(
      onTap: () async {
        await Helpers()
            .getData(widget.shazamSongData.title.toString())
            .then((value) => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => MusicPlayer()))
                });
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
              Text(
                widget.index.toString(),
                style: GoogleFonts.montserrat(color: textLight),
              ),
              const SizedBox(
                width: 15,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: (imageUrl != "null")
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.fill,
                        height: 50,
                        width: 50,
                      )
                    : Image.asset('assets/images/placeholder.png',fit: BoxFit.fill,
                  height: 50,
                  width: 50,),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 0.5 * size.width,
                    child: Text(
                      widget.shazamSongData.title.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                          color: textLight, fontSize: 16),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 0.5 * size.width,
                        child: Text(widget.shazamSongData.subtitle.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                                color: Colors.grey, fontSize: 14)),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert,color: textLight,),
                onSelected: (value) {
                  switch (value) {
                    case 'View Artist':
                      print("View Artist");
                      Helpers()
                          .getArtistData(widget.shazamSongData.subtitle.toString())
                          .then((value) => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => ArtistPage(
                              artistData: value,
                              i: 0,
                            ),
                          ),
                        )
                      });
                      break;
                    case 'Add to Queue':
                      Helpers().getData(widget.shazamSongData.title.toString()).then((value){
                        player.queue.addSong(value.data![0]);
                      });
                      print("Add to Queue");
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {
                    'View Artist',
                    'Add to Queue',
                  }.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
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

// -----

class ArtistCard extends StatefulWidget {
  final Artist artist;
  const ArtistCard({Key? key, required this.artist}) : super(key: key);

  @override
  _ArtistCardState createState() => _ArtistCardState();
}

class _ArtistCardState extends State<ArtistCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String imageURL = widget.artist.pictureBig.toString();
    return GestureDetector(
      onTap: () async {
        await Helpers()
            .getArtistData(widget.artist.name.toString())
            .then((value) => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => ArtistPage(
                                artistData: value,
                                i: 0,
                              )))
                });
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
                borderRadius: BorderRadius.circular(25),
                child: (imageURL != "null")
                    ? Image.network(
                        imageURL,
                        fit: BoxFit.fill,
                        height: 50,
                        width: 50,
                      )
                    : Image.asset('assets/images/placeholder.png',fit: BoxFit.fill,
                  height: 50,
                  width: 50,),
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
                    child: Row(
                      children: [
                        Text(
                          widget.artist.name.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                              color: textLight, fontSize: 16),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.verified_rounded,
                          color: Colors.purple.shade300,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 0.5 * size.width,
                    child: Text(
                      "Artist",
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                          color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ],
              ),
              const Spacer(),
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

// -----

class LikedSongCard extends StatefulWidget {
  final Datum songs;
  const LikedSongCard({Key? key, required this.songs}) : super(key: key);

  @override
  _LikedSongCardState createState() => _LikedSongCardState();
}

class _LikedSongCardState extends State<LikedSongCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String imageUrl = widget.songs.album!.cover.toString();
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => const MusicPlayer()));
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
                child:
                (imageUrl.isEmpty || imageUrl == "null")
                    ? Image.asset('assets/images/placeholder.png',
                  fit: BoxFit.fill,
                  height: 50,
                  width: 50,
                )
                    : Image.network(
                  imageUrl,
                  fit: BoxFit.fill,
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
                      else
                        const SizedBox(),
                      SizedBox(
                        width: 0.5 * size.width,
                        child: Text(widget.songs.artist!.name.toString(),
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
                onPressed: () {},
                icon: Icon(
                  Icons.favorite_rounded,
                  color: textLight,
                ),
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

// -----

class RecSongCard extends StatefulWidget {
  final Datum songs;
  const RecSongCard({Key? key, required this.songs}) : super(key: key);

  @override
  _RecSongCardState createState() => _RecSongCardState();
}

class _RecSongCardState extends State<RecSongCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String imageUrl = widget.songs.album!.cover.toString();
    return GestureDetector(
      onTap: () {
        player.queue.loadSoloTrack(widget.songs);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => const MusicPlayer()));
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
                child:
                (imageUrl.isEmpty || imageUrl == "null")
                    ? Image.asset('assets/images/placeholder.png',
                  fit: BoxFit.fill,
                  height: 50,
                  width: 50,
                )
                    : Image.network(
                  imageUrl,
                  fit: BoxFit.fill,
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
                      else
                        const SizedBox(),
                      SizedBox(
                        width: 0.5 * size.width,
                        child: Text(widget.songs.artist!.name.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                                color: Colors.grey, fontSize: 14)),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}