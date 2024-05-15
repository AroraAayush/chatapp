
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  @override
  void initState(){
    navigate();
    super.initState();
  }
  FirebaseAuth auth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
            height: 400,
            width: 200,
            child: Lottie.asset('assets/lottie/splashanimation.json')),
      ),
    );
  }

  void navigate() {
      Future.delayed(Duration(seconds: 6),(){
        if(auth.currentUser==null)
          {
            Navigator.pushNamedAndRemoveUntil(context, '/signupview',(route)=> false);
          }
        else
          {
            Navigator.pushNamedAndRemoveUntil(context, '/homeview',(route)=> false);
          }

      });
    }

}
