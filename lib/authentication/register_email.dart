import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbyl_project/authentication/email_verification.dart';
import 'package:verbyl_project/main.dart';
import 'validators.dart';
import '/theme.dart';

String userEmail = "";

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String name = "", emailId = "", password = "";


  @override
  void initState() {
    super.initState();
  }

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
          title: Text("Register",
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
              // SizedBox(
              //   height: 0.1 * size.height,
              //   child: Center(
              //     child: Text("What is your email-id? ",
              //       textAlign: TextAlign.center,
              //       style: GoogleFonts.montserrat(
              //         fontSize: 28,
              //         color: textLight,
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 10,),
              SizedBox(
                height: 0.1 * size.height,
                width: 0.85 * size.width,
                child: TextField(
                  style: GoogleFonts.montserrat(color: textLight),
                  controller: nameController,
                  onChanged: (value){
                    setState(() {
                      name = value.trim();
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
                      child: Icon(CupertinoIcons.person,color: Color(0xfff2f2f2),),
                    ),
                    labelText: "Name",
                    labelStyle: GoogleFonts.montserrat(color: textLight),
                    errorStyle: GoogleFonts.montserrat(),
                    errorText: name.isNotEmpty
                        ? NameValidator.validate(name)
                        : "",
                  ),
                  // ignore: prefer_const_literals_to_create_immutables
                  autofillHints: [AutofillHints.namePrefix],
                  keyboardType: TextInputType.text,
                ),
              ),
              const SizedBox(height: 10,),
              SizedBox(
                height: 0.1 * size.height,
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
                      child: Icon(CupertinoIcons.mail_solid,color: Color(0xfff2f2f2),),
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
              const SizedBox(height: 10,),
              SizedBox(
                height: 0.1 * size.height,
                width: 0.85 * size.width,
                child: TextField(
                  style: GoogleFonts.montserrat(color: textLight),
                  controller: passwordController,
                  onChanged: (value){
                    setState(() {
                      password = value.trim();
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
                      child: Icon(CupertinoIcons.padlock_solid,color: Color(0xfff2f2f2),),
                    ),
                    labelText: "Password",
                    labelStyle: GoogleFonts.montserrat(color: textLight),
                    errorStyle: GoogleFonts.montserrat(),
                    errorText: password.isNotEmpty
                        ? PasswordValidator.validate(password)
                        : "",
                  ),
                  // ignore: prefer_const_literals_to_create_immutables
                  autofillHints: [AutofillHints.password],
                  keyboardType: TextInputType.text,
                ),
              ),
              const SizedBox(height: 10,),
              SizedBox(
                height: 56,
                width: 0.85 * size.width,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: primary,
                  ),
                  onPressed: () async {
                    //print("email : " + emailId.toString());
                    if(EmailValidator.validate(emailController.value.text) == null &&
                        PasswordValidator.validate(passwordController.value.text) == null){
                      setState(() {
                        authenticationController.userEmail = emailId;
                        authenticationController.userPassword = password;
                      });
                      try{
                        if(await authenticationController.signUp()){
                          //Logged in successfully
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => VerifyScreen(name: nameController.text,),)
                          );
                        }
                      }
                      catch(e){
                        debugPrint(e.toString());
                      }
                    }
                  },
                  child: Text("Register",
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

