import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'mini_music_player.dart';
import '/theme.dart';
import 'home_page.dart';
import 'library.dart';
import 'profile.dart';
import 'search.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgDark,
        body: buildBody(),
        bottomNavigationBar: buildBottomNavy(),
        persistentFooterButtons: const [
          MiniMusicPlayer(),
        ],
      ),
    );
  }

  int navBarIndex = 0;

  Widget buildBottomNavy(){
    final inactiveColor = Colors.grey;
    return Stack(
      children: [
        BottomNavyBar(
          showElevation: false,
          backgroundColor: bgDark,
          selectedIndex: navBarIndex,
          onItemSelected: (index) => setState(() {
            navBarIndex = index;
          }),
          items: [
            BottomNavyBarItem(
              icon: const Icon(Icons.home_outlined),
              title: Text('Home',
                style: GoogleFonts.montserrat(color: primary),
              ),
              activeColor: primary,
              inactiveColor: inactiveColor.shade600,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              inactiveColor: inactiveColor.shade600,
              textAlign: TextAlign.center,
              icon: const Icon(Icons.search),
              title: Text('Search',
                style: GoogleFonts.montserrat(color: primary),
              ),
              activeColor: primary,
            ),
            BottomNavyBarItem(
              inactiveColor: inactiveColor.shade600,
              textAlign: TextAlign.center,
              icon: const Icon(Icons.library_music),
              title: Text('Library',
                style: GoogleFonts.montserrat(color: primary),
              ),
              activeColor: primary,
            ),
            BottomNavyBarItem(
              inactiveColor: inactiveColor.shade600,
              textAlign: TextAlign.center,
              icon: const Icon(Icons.account_circle_outlined),
              title: Text('Profile',
                style: GoogleFonts.montserrat(color: primary),
              ),
              activeColor: primary,
            ),
          ],
        ),
        const SizedBox(height: 10,),
      ],
    );
  }

  Widget buildBody(){
    switch (navBarIndex) {
      case 1 :
        return Search();
      case 2 :
        return Library();
      case 3 :
        return Profile();
      case 0 :
      default :
        return HomePage();
    }
  }

}
