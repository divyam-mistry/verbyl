import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magic_sdk/magic_sdk.dart';
import 'package:verbyl_project/main.dart';
import '/pages/home.dart';
import '/authentication/login_phone.dart';
import 'validators.dart';
import '/theme.dart';

Magic magic = Magic.instance;
String userEmail = "";

class LoginEmail extends StatefulWidget {
  const LoginEmail({Key? key}) : super(key: key);

  @override
  _LoginEmailState createState() => _LoginEmailState();
}

class _LoginEmailState extends State<LoginEmail> {

  final TextEditingController emailController = TextEditingController();
  String emailId = "";
  bool showSplash = true;

  getData() async{
    var v =  await magic.user.getMetadata();
    userEmail = v.email.toString();
    debugPrint("Email : " + userEmail);
  }

  @override
  void initState() {
    var future = magic.user.isLoggedIn();
    future.then((isLoggedIn) {
      if (isLoggedIn) {
        try{
          getData();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Home())
          );
        } catch(e){
          debugPrint("Email not found");
          debugPrint(e.toString());
        }
      }
      else {
        setState(() {
          showSplash = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: showSplash ? const SplashScreen() : Scaffold(
        backgroundColor: bgDark,
        appBar: AppBar(
          toolbarHeight: 75,
          centerTitle: true,
          backgroundColor: bgDark,
          elevation: 0.0,
          title: Text("Login with Email",
            style: GoogleFonts.montserrat(
              color: textLight,
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios,
              size: 22,
              color: Color(0xFFf2f2f2),
            ),
            onPressed: (){
              SystemNavigator.pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 0.35 * size.height,
                child: Image.asset("assets/images/verbyl_login.png"),
              ),
              SizedBox(
                height: 0.1 * size.height,
                child: Center(
                  child: Text("What is your email-id? ",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 28,
                      color: textLight,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              SizedBox(
                height: 0.125 * size.height,
                width: 0.85 * size.width,
                child: TextField(
                  style: GoogleFonts.montserrat(color: textLight),
                  controller: emailController,
                  onChanged: (value){
                    setState(() {
                      emailId = value.trim();
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: textLight),
                        borderRadius: const BorderRadius.all(Radius.circular(5.0))
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: textLight),
                        borderRadius: const BorderRadius.all(Radius.circular(5.0))
                    ),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: textLight),
                        borderRadius: const BorderRadius.all(Radius.circular(5.0))
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: textLight),
                        borderRadius: const BorderRadius.all(Radius.circular(5.0))
                    ),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 20.0,right: 10.0),
                      child: Icon(Icons.mail,color: Color(0xfff2f2f2),),
                    ),
                    labelText: "Email-id",
                    labelStyle: GoogleFonts.montserrat(color: textLight),
                    errorStyle: GoogleFonts.montserrat(),
                    errorText: emailId.isNotEmpty
                        ? EmailValidator.validate(emailId)
                        : "",
                  ),
                  // ignore: prefer_const_literals_to_create_immutables
                  autofillHints: [AutofillHints.email],
                  keyboardType: TextInputType.text,
                ),
              ),
              //const SizedBox(height: 10,),
              SizedBox(
                height: 56,
                width: 0.85 * size.width,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: primary,
                  ),
                  onPressed: () async {
                    //print("email : " + emailId.toString());
                    if(EmailValidator.validate(emailController.value.text) == null){
                      //print("valid email");
                      userEmail = emailId.toString();
                      var token = await magic.auth.loginWithMagicLink(email: emailId.toString());
                      try{
                        if(token.isNotEmpty){
                          //print("token : " + token.toString());
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const Home())
                          );
                        }
                      }
                      catch(e){
                        print(e.toString());
                      }
                    }
                  },
                  child: Text("Continue",
                    style: GoogleFonts.montserrat(
                      color: textLight,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 50,
              //   child: Center(child: Text("Or",style: GoogleFonts.montserrat(
              //     color: textLight,
              //   ),)),
              // ),
              // SizedBox(
              //   height: 56,
              //   width: 0.85 * size.width,
              //   child: TextButton(
              //     style: TextButton.styleFrom(
              //       backgroundColor: primary,
              //     ),
              //     onPressed: (){
              //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPhone()));
              //     },
              //     child: Text("Login with Phone number",
              //       style: GoogleFonts.montserrat(
              //         color: textLight,
              //         fontSize: 18,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

