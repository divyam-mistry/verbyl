import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbyl_project/pages/playlist.dart';

import '../models/general.dart';
import '../theme.dart';

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);

  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {

  TextEditingController dialogController = TextEditingController();
  showCreatePlaylistDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: bgDark,
          title: Text('Create a Playlist',
            style: GoogleFonts.montserrat(
              color: textLight,
            ),
          ),
          content: TextField(
            style: GoogleFonts.montserrat(
              color: textLight,
            ),
            controller: dialogController,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: textLight),
              ),
              hintText: "Enter Playlist name",
              hintStyle: GoogleFonts.montserrat(
                color: Colors.grey,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL',style: GoogleFonts.montserrat(
                color: textLight,
              ),),
              onPressed: () {
                dialogController.clear();
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('OK',style: GoogleFonts.montserrat(
                color: textLight,
              ),),
              onPressed: () {
                int index = userPlaylist.indexWhere((element) => element.name == dialogController.text);
                if(index >= 0){
                  Navigator.pop(context);
                  Flushbar(
                    flushbarPosition: FlushbarPosition.TOP,
                    duration: const Duration(seconds: 3),
                    flushbarStyle: FlushbarStyle.FLOATING,
                    messageText: Text("Playlist already exists",
                      style: GoogleFonts.montserrat(color: textLight),
                    ),
                    margin: const EdgeInsets.all(8),
                    borderRadius: BorderRadius.circular(8),
                    backgroundColor: flushBarDark,
                    messageColor: textLight,
                    icon: Icon(
                      Icons.error,
                      size: 28.0,
                      color: Colors.red[400],
                    ),
                  ).show(context);
                  debugPrint("Playlist already exists");
                }
                else{
                  userPlaylist.add(Playlist(name: dialogController.text,songs: []));
                  users[0].playlists++;
                  Navigator.pop(context);
                  Flushbar(
                    flushbarPosition: FlushbarPosition.TOP,
                    duration: const Duration(seconds: 3),
                    flushbarStyle: FlushbarStyle.FLOATING,
                    messageText: Text("Created new playlist named " + dialogController.text,
                      style: GoogleFonts.montserrat(color: textLight),
                    ),
                    margin: const EdgeInsets.all(8),
                    borderRadius: BorderRadius.circular(8),
                    backgroundColor: flushBarDark,
                    messageColor: textLight,
                    icon: Icon(
                      Icons.done_rounded,
                      size: 28.0,
                      color: Colors.green[400],
                    ),
                  ).show(context);
                }
                setState(() {});
                debugPrint(dialogController.text);
                dialogController.clear();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Your Library",
          style: GoogleFonts.montserrat(color: textLight),
        ),
        actions: [
          IconButton(
            onPressed: (){
              debugPrint("Before sorting");
              for (var element in userPlaylist) {
                debugPrint(element.name);
              }
              setState(() {
                userPlaylist.sort((a,b){
                  return a.name.toString().toLowerCase().compareTo(b.name.toString().toLowerCase());
                });
              });
              debugPrint("After sorting");
              for (var element in userPlaylist) {
                debugPrint(element.name);
              }
            },
            icon: Stack(
              children: [
                Icon(Icons.sort_rounded,color: textLight,),
                Positioned(
                  right: -2,
                  bottom: 0,
                  child: Icon(Icons.south_rounded,color: textLight,size: 15,),
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: (){
                showCreatePlaylistDialog(context);
              },
              icon: Icon(Icons.add,color: textLight,),
          ),
        ],
      ),
      backgroundColor: bgDark,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8,),
              makeListCard(
                title: "Liked Songs",
                numOfSongs: 5,
                color: Colors.redAccent.shade400,
                icon: const Icon(Icons.favorite_rounded),
              ),
              makeListCard(
                title: "Recently Played",
                numOfSongs: 10,
                color: Colors.blueAccent.shade400,
                icon: const Icon(Icons.history_rounded),
              ),
              const SizedBox(height: 8,),
              if(userPlaylist.isNotEmpty) Divider(
                indent: 10,
                endIndent: 10,
                color: textLight,
              ),
              const SizedBox(height: 8,),
              SizedBox(
                height: 370,
                child: ListView.builder(
                  itemCount: userPlaylist.length,
                  itemBuilder: (context,index){
                      return makePlaylistCard(plist: userPlaylist[index],);
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget makeListCard({required String title,required Icon icon,required int numOfSongs,required Color color}){
    return GestureDetector(
      child: SizedBox(
        height: 80,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color,color.withOpacity(0.2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                  child: Icon(icon.icon,color: Colors.white,),
                ),
              ),
              const SizedBox(width: 20,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                    style: GoogleFonts.montserrat(
                        fontSize: 18,
                        color: textLight,
                    ),
                  ),
                  Text(numOfSongs.toString() + " songs",
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: (){
        // PlaylistPage(title: title);
        debugPrint(title);
      },
    );
  }

  Widget makePlaylistCard({required Playlist plist}){
    String title = plist.name.toString();
    int numOfSongs = plist.songs!.length;
    Icon icon = const Icon(Icons.queue_music_rounded);
    Color color = Colors.purple.shade400;
    return GestureDetector(
      child: SizedBox(
        height: 80,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color,color.withOpacity(0.2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                  child: Icon(icon.icon,color: Colors.white,),
                ),
              ),
              const SizedBox(width: 20,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      color: textLight,
                    ),
                  ),
                  Text(numOfSongs.toString() + " songs",
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                  onPressed: (){
                    //remove playlist from user list
                    int index = userPlaylist.indexWhere((element) => element.name == title);
                    if(index >= 0) {
                      users[0].playlists--;
                      userPlaylist.removeAt(index);
                      String msg = title + " removed from your playlists";
                      Flushbar(
                        duration: const Duration(seconds: 3),
                        flushbarPosition: FlushbarPosition.TOP,
                        flushbarStyle: FlushbarStyle.FLOATING,
                        messageText: Text(msg, style: GoogleFonts.montserrat(
                          color: textLight
                        ),),
                        margin: const EdgeInsets.all(8),
                        borderRadius: BorderRadius.circular(8),
                        backgroundColor: flushBarDark,
                        messageColor: textLight,
                        icon: Icon(
                          Icons.done_rounded,
                          size: 28.0,
                          color: Colors.green[400],
                        ),
                      ).show(context);
                      debugPrint(msg);
                    } else {
                      debugPrint("cant remove " + title + " from your playlists");
                    }
                    setState(() {});
                  },
                  icon: Icon(Icons.delete_outline_outlined,color: textLight,)),
            ],
          ),
        ),
      ),
      onTap: (){
        // PlaylistPage(title: title);
        Navigator.push(context, MaterialPageRoute(builder: (ctx) =>
            PlaylistPage(playlist: plist))
        );
        debugPrint(title);
      },
    );
  }

}



