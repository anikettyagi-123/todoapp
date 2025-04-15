


import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_list/view/loginScreem.dart';
import 'package:todo_list/view/welcome_screen.dart';

import 'firebase/firebase.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    isLogin();



  }
  isLogin() async{
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;


    if(user != null){

      Timer(Duration(seconds: 3), () {
       Get.offAll(()=>WelcomeScreen());
       });
      await deleteTask();

    }else{ Timer(Duration(seconds: 3), () {
      Get.offAll(()=>LoginScreen());
    }
    );
    }

  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.greenAccent,
            child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
              children: [
          
                Center(
                  child: Lottie.asset('animation/hello.json',
                      // height: MediaQuery.of(context).size.height*.6,
                      // width: MediaQuery.of(context).size.width*.8
                  ),
                ),
                SizedBox(
                   height: MediaQuery.of(context).size.height*.04
                ),
                Center(
                  child: Lottie.asset('animation/welcome.json',
                    // height: MediaQuery.of(context).size.height*.6,
                    // width: MediaQuery.of(context).size.width*.8
                  ),
                ),
          
          
          
          
              ],
            ),
          ),
        ),

      ),
    );
  }
}
