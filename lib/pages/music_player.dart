import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:verbyl_project/models/song.dart';
import 'package:verbyl_project/theme.dart';

class MusicPlayer extends StatefulWidget {
  final Datum song;
  const MusicPlayer({Key? key,required this.song}) : super(key: key);

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {

  // late Duration _visibleValue;
  // bool listenOnlyUserInterraction = false;
  // double get percent => _visibleValue.inMilliseconds / 30;
  bool isPlaying = false,isShuffled = false;
  bool isLiked = false;

  PaletteColor appbar = PaletteColor(textLight, 2);
  PaletteColor color = PaletteColor(primary, 2);

  _updatePalette() async{
    final PaletteGenerator generator =
      await PaletteGenerator.fromImageProvider(
        NetworkImage(widget.song.album!.coverBig.toString()),
      );
    setState(() {
      //appbar = PaletteColor(generator.vibrantColor!.color, 2);
      color = PaletteColor(generator.dominantColor!.color, 2);
    });
  }

  @override
  void initState() {
    _updatePalette();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.color,
                bgDark,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: bgDark.withOpacity(0.5),
            elevation: 0.0,
            toolbarHeight: 80,
            title: SizedBox(
              width: 0.6 * size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("NOW PLAYING",
                    style: TextStyle(
                      color: appbar.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Text(widget.song.title.toString(),
                  style: TextStyle(
                    color: appbar.color.withOpacity(0.8),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                    ),
                ],
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios,color: appbar.color,),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.more_vert,color: appbar.color,)),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30,),
              songImage(widget.song.album!.coverBig.toString()),
              const SizedBox(height: 40,),
              songDetails(song: widget.song),
              const SizedBox(height: 15,),
              musicPlayerControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget musicPlayerControls(){
    Size size = MediaQuery.of(context).size;
    double val = 0.0;
    return SizedBox(
      width: size.width,
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: SliderTheme(
                      data: const SliderThemeData(
                          trackHeight: 1,
                          thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: 5)
                      ),
                      child: Slider(
                        min: 0,
                        inactiveColor: Colors.grey,
                        activeColor: Colors.white,
                        max: 30,
                        value: 10,
                        onChangeEnd: (newValue) {
                          setState(() {
                            //listenOnlyUserInterraction = false;
                            //widget.seekTo(_visibleValue);
                          });
                        },
                        onChangeStart: (_) {
                          setState(() {
                            //listenOnlyUserInterraction = true;
                          });
                        },
                        onChanged: (newValue) {
                          setState(() {
                            //final to = Duration(milliseconds: newValue.floor());
                            //_visibleValue = to;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    SizedBox(
                      width: 40,
                      child: Text("00:00",
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                    SizedBox(
                      width: 40,
                      child: Text("00:30",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 80,
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    splashRadius: 24,
                    onPressed: () {
                      setState(() {
                        isShuffled = !isShuffled;
                      });
                    },
                    icon: isShuffled
                        ? Icon(Icons.shuffle, color: primary)
                        : const Icon(Icons.shuffle, color: Colors.white),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: (){},
                      icon: Icon(
                        Icons.skip_previous,
                        size: 40,
                        color: textLight,
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      width: 120,
                      child: IconButton(
                        onPressed: (){
                          setState(() {
                            isPlaying = !isPlaying;
                          });
                        },
                        icon: Icon(
                          isPlaying
                              ? CupertinoIcons.pause_circle_fill
                              : CupertinoIcons.play_circle_fill,
                          size: 80,
                          color: textLight,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: (){},
                      icon: Icon(
                        Icons.skip_next,
                        color: textLight,
                        size: 40,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 80,
                  child: IconButton(
                    splashRadius: 24,
                    onPressed: () {},
                    icon: Icon(CupertinoIcons.arrow_2_circlepath,color: textLight,),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget songDetails({required Datum song}){
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 0.65 * size.width,
                child: Text(song.title.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: textLight,
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Row(
                children: [
                  if (widget.song.explicitLyrics == true)
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
                    width: 0.65 * size.width,
                    child: Text(song.artist!.name.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey.shade500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: isLiked
                ? Icon(
              Icons.favorite_rounded,
              color: textLight,
              size: 30,
            )
                : Icon(
              Icons.favorite_border_outlined,
              color: textLight,
              size: 30,
            ),
            onPressed: (){
              setState(() {
                isLiked = !isLiked;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget songImage(String imageUrl){
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Center(
        child: SizedBox(
          height: 0.9 * size.width,
          width: size.width,
          child: Hero(
            tag: "songImage", child: Image.network(imageUrl,fit: BoxFit.fill,)),
        ),
      ),
    );
  }


}
