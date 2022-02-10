import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magic_sdk/magic_sdk.dart';
import 'package:verbyl_project/authentication/setup_profile.dart';
import 'package:verbyl_project/models/general.dart';
import '/authentication/login_email.dart';
import '../theme.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //Magic magic = Magic.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        backgroundColor: bgDark,
        title: Text("Your Profile",style: GoogleFonts.montserrat(),),
        elevation: 0.0,
        actions: [
          IconButton(onPressed: (){
            setState(() {});
            }, icon: Icon(Icons.refresh_rounded,color: textLight,)
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 0.28 * size.height,
                decoration: const BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            child: Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                color: Colors.purple.shade900.withOpacity(0.7),
                                borderRadius: const BorderRadius.all(Radius.circular(15.0),),
                                image: DecorationImage(
                                  image: AssetImage("assets/images/${users[0].avatarIndex}.png"),
                                ),
                              ),
                            ),
                            onTap: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const SetupAvatar())
                              );
                              setState(() {});
                            },
                          ),
                          const SizedBox(width: 30,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 15,),
                              Text(users[0].name,style: GoogleFonts.montserrat(
                                color: textLight,
                                fontSize: 24,
                              ),),
                              const SizedBox(height: 10,),
                              Row(
                                children: [
                                  Icon(Icons.people_rounded,color: Colors.purple.shade200,),
                                  const SizedBox(width: 5,),
                                  Text(users[0].followingArtists.toString(),style: GoogleFonts.montserrat(
                                    color: textLight,
                                  ),),
                                  const SizedBox(width: 20,),
                                  Icon(Icons.queue_music_rounded,color: Colors.purple.shade200,),
                                  const SizedBox(width: 5,),
                                  Text(users[0].playlists.toString(),style: GoogleFonts.montserrat(
                                    color: textLight,
                                  ),),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 15,),
                      Row(
                        children: [
                          Container(
                              child: Icon(Icons.alternate_email_rounded,color: textLight,size: 18,),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius: const BorderRadius.all(Radius.circular(10.0),),
                            ),
                          ),
                          const SizedBox(width: 15,),
                          Text("divsmistry30@gmail.com",style: GoogleFonts.montserrat(
                              color: textLight,
                            fontSize: 16,
                          ),),
                        ],
                      ),
                      const SizedBox(height: 15,),
                      Row(
                        children: [
                          Container(
                            child: Icon(Icons.location_on_rounded,color: textLight,size: 18,),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius: const BorderRadius.all(Radius.circular(10.0),),
                            ),
                          ),
                          const SizedBox(width: 15,),
                          Text("Bilimora, Gujarat",style: GoogleFonts.montserrat(
                            color: textLight,
                            fontSize: 16,
                          ),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// TextButton(
// onPressed: () async {
// try {
// print("try");
// await magic.user.logout();
// debugPrint(await magic.user.isLoggedIn().toString());
// } catch (e) {
// debugPrint("Divyam Error : " + e.toString());
// }
// Navigator.pushReplacement(context,
// MaterialPageRoute(builder: (context) => const LoginEmail())
// );
// },
// child: Text("Logout")),