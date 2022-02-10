import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magic_sdk/magic_sdk.dart';
import 'package:verbyl_project/authentication/login_email.dart';
import 'package:verbyl_project/pages/mini_music_player.dart';
import '../models/general.dart';
import '../theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Magic magic = Magic.instance;
  var email = "";
  bool loading = true;

  Future<String> getData() async {
    debugPrint("user before await: ");
    var user = await magic.user.getMetadata();
    debugPrint("user : " + user.email.toString());
    email = user.email.toString();
    setState(() {
      userEmail = email;
      loading = false;
    });
    return email;
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0.0,
        title: FutureBuilder(
          future: getData(),
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasError){
                return Text(snapshot.error.toString());
              }
              else if(snapshot.hasData){
                return Text("Welcome, " + snapshot.toString().toUpperCase(),style: GoogleFonts.montserrat(
                ));
              }
              else {
                return const Text("Error");
              }
            }
            else {
              print("else");
              return Text("Welcome,",style: GoogleFonts.montserrat());
            }
          },
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.history_rounded,color: textLight,)),
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications_rounded,color: textLight,)),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [primary, bgDark],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  showCharts(),
                  const SizedBox(height: 10,),
                  showArtists(),
                  const SizedBox(height: 10,),
                  showCharts(),
                  const SizedBox(height: 10,),
                  showArtists(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Charts> topCharts = [
    Charts(title: "Top 50 India", country: "IN"),
    Charts(title: "Top 50 US", country: "US"),
    Charts(title: "Top 50 UK", country: "UK"),
  ];

  List<Artist> topArtists = [
    Artist(name: "DJ Snake",imageLink:
    "https://e-cdns-images.dzcdn.net/images/artist/02b4b508aa974d5f6e8348e2186dd49f/250x250-000000-80-0-0.jpg"
    ),
    Artist(name: "Dua Lipa",imageLink:
    "https://e-cdns-images.dzcdn.net/images/artist/e6a04d735093a46dcc8be197681d1199/250x250-000000-80-0-0.jpg"
    ),
    Artist(name: "Shawn Mendes",imageLink:
    "https://e-cdns-images.dzcdn.net/images/artist/9106de4de092ecb05ec8862d3415337d/250x250-000000-80-0-0.jpg"
    ),
  ];

  Widget showCharts(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("  Top Charts",
          style: GoogleFonts.montserrat(
            color: textLight,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 10,),
        SizedBox(
          height: 170,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: topCharts.length,
              itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: bgDark.withOpacity(0.75),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          designChartImage(country: topCharts[index].country.toString(),index: index),
                          const SizedBox(height: 10,),
                          Text(topCharts[index].title.toString(),style: GoogleFonts.montserrat(
                            color: textLight,
                          ),),
                        ],
                      ),
                    ),
                  ),
                );
              }
          ),
        ),
      ],
    );
  }

  Widget designChartImage({required String country,required int index}){
    List<Color> list = [Colors.blue,Colors.red,Colors.green];
    return Container(
      height: 100,
      width: 125,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(7.5)),
          gradient: LinearGradient(
            colors: [list[index],list[index]],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Top 50",style: GoogleFonts.montserrat(
            color: textLight,
            fontSize: 16,
          ),),
          const SizedBox(height: 5,),
          Divider(color: textLight,indent: 20,endIndent: 20,thickness: 1.5,),
          const SizedBox(height: 5,),
          Text(country.toUpperCase(),style: GoogleFonts.montserrat(
            color: textLight,
            fontSize: 22,
          ),),
        ],
      ),
    );
  }

  Widget showArtists(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("  Top Artists",
          style: GoogleFonts.montserrat(
            color: textLight,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 10,),
        SizedBox(
          height: 190,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: topCharts.length,
              itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: bgDark.withOpacity(0.75),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(topArtists[index].imageLink,
                              height: 125,
                              width: 125,
                              fit: BoxFit.fill,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Text(topArtists[index].name.toString(),style: GoogleFonts.montserrat(
                            color: textLight,
                          ),),
                        ],
                      ),
                    ),
                  ),
                );
              }
          ),
        ),
      ],
    );
  }

}
