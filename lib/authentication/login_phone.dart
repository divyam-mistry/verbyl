import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magic_sdk/magic_sdk.dart';
import '/authentication/login_email.dart';
import '/pages/home.dart';
import '/theme.dart';
import 'validators.dart';

class LoginPhone extends StatefulWidget {
  const LoginPhone({Key? key}) : super(key: key);

  @override
  _LoginPhoneState createState() => _LoginPhoneState();
}

class _LoginPhoneState extends State<LoginPhone> {
  Magic magic = Magic.instance;
  final TextEditingController phoneController = TextEditingController();
  String phoneNumber = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgDark,
        appBar: AppBar(
          toolbarHeight: 75,
          centerTitle: true,
          backgroundColor: bgDark,
          elevation: 0.0,
          title: Text("Login with Number",
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
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginEmail())
              );
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
                  child: Text("What is your \nphone-number? ",
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
                  controller: phoneController,
                  onChanged: (value){
                    setState(() {
                      phoneNumber = value.trim();
                    });
                  },
                  decoration: InputDecoration(
                    prefixStyle: GoogleFonts.montserrat(
                        color: textLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                    prefixText: "+91   ",
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
                      child: Icon(Icons.phone,color: Color(0xfff2f2f2),),
                    ),
                    labelText: "Phone Number",
                    labelStyle: GoogleFonts.montserrat(color: textLight),
                    errorStyle: GoogleFonts.montserrat(),
                    errorText: phoneNumber.isNotEmpty
                        ? PhoneValidator.validate(phoneNumber)
                        : "",
                  ),
                  // ignore: prefer_const_literals_to_create_immutables
                  autofillHints: [AutofillHints.telephoneNumber],
                  keyboardType: TextInputType.phone,
                ),
              ),
              //const SizedBox(height: 10,),
              Container(
                height: 56,
                width: 0.85 * size.width,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF10448b),
                  ),
                  onPressed: () async {
                    if(PhoneValidator.validate(phoneController.value.text) == null){
                      debugPrint("phNumber : " + phoneNumber);
                      var token = await magic.auth.loginWithSMS(phoneNumber: "+91" + phoneNumber.toString());
                      debugPrint('token, $token');
                      try{
                        if(token.isNotEmpty){
                          debugPrint('token, $token');
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => const Home())
                          );
                        }
                      }
                      catch(e){
                        debugPrint(e.toString());
                      }
                      //Navigator.push(context, new MaterialPageRoute(builder: (context) => MainPage()));
                    }
                  },
                  child: Text("Continue",
                    style: GoogleFonts.montserrat(
                      color: textLight,
                      fontSize: 20,
                    ),
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
