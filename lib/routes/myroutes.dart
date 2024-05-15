import 'package:chatwithaayushhhh/pages/error/errorview.dart';
import 'package:chatwithaayushhhh/pages/generalchat/documentdisplayscreen.dart';
import 'package:chatwithaayushhhh/pages/generalchat/generalchatscreen.dart';
import 'package:chatwithaayushhhh/pages/generalchat/imagedisplayscreen.dart';
import 'package:chatwithaayushhhh/pages/groupchat/addmemberscreen.dart';
import 'package:chatwithaayushhhh/pages/groupchat/addmemberscreen2.dart';
import 'package:chatwithaayushhhh/pages/groupchat/creategroupscreen.dart';
import 'package:chatwithaayushhhh/pages/groupchat/groupchatscreen.dart';
import 'package:chatwithaayushhhh/pages/groupchat/models/groupmodel.dart';
import 'package:chatwithaayushhhh/pages/home/homeview.dart';
import 'package:chatwithaayushhhh/pages/home/models/usermodel.dart';
import 'package:chatwithaayushhhh/pages/home/starredMessageScreen.dart';
import 'package:chatwithaayushhhh/pages/login/loginview.dart';
import 'package:chatwithaayushhhh/pages/profile/groupProfileScreen.dart';
import 'package:chatwithaayushhhh/pages/profile/recieverprofilescreen.dart';
import 'package:chatwithaayushhhh/pages/profile/userprofilescreen.dart';
import 'package:chatwithaayushhhh/pages/signup/signupview.dart';
import 'package:chatwithaayushhhh/pages/splash/splashview.dart';
import 'package:flutter/material.dart';

class Routes
{
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name)
        {
      case '/':
        return MaterialPageRoute(builder: (context)=> SplashView());

      case '/signupview' :
        return MaterialPageRoute(builder: (context)=> SignupView());

      case '/loginview' :
        return MaterialPageRoute(builder: (context)=> LoginView());

        case '/homeview' :
       return MaterialPageRoute(builder: (context)=> HomeView());

      case '/creategroupscreen' :
        return MaterialPageRoute(builder: (context)=> CreateNewGroupScreen());

      case '/generalchatscreen':
        Map<String,dynamic> args=settings.arguments as Map<String,dynamic>;
        return MaterialPageRoute(builder: (context)=> GeneralChatScreen(args:args));

      case '/starredmessagescreen':
        return MaterialPageRoute(builder: (context)=> StarredMessageScreen());


      case '/groupchatscreen':
        GroupModel group=settings.arguments as GroupModel;
        return MaterialPageRoute(builder: (context)=> GroupChatScreen(group:group));

      case '/imagedisplayscreen':
        String mediaUrl=settings.arguments as String;
        return MaterialPageRoute(builder: (context)=> ImageDisplayScreen(mediaUrl:mediaUrl));

      case '/documentdisplayscreen':
        String mediaUrl=settings.arguments as String;
        return MaterialPageRoute(builder: (context)=> DocumentDisplayScreen(mediaUrl:mediaUrl));
      case '/addmemberscreen':
        return MaterialPageRoute(builder: (context)=> AddMemberScreen());

      case '/addmemberscreen2':
        Map<String,dynamic> args=settings.arguments as Map<String,dynamic>;
        return MaterialPageRoute(builder: (context)=> AddMemberScreen2(args: args,));
      case '/userprofilescreen' :
        UserModel user = settings.arguments as UserModel;
        return MaterialPageRoute(builder: (context)=> UserProfileScreen(user:user));

      case '/groupProfileScreen' :
        GroupModel group = settings.arguments as GroupModel;
        return MaterialPageRoute(builder: (context)=> GroupProfileScreen(group:group));

      case '/recieverprofilescreen' :
        UserModel reciever = settings.arguments as UserModel;
        return MaterialPageRoute(builder: (context)=> RecieverProfileScreen(reciever:reciever));

      default:
        return MaterialPageRoute(builder: (context)=> ErrorView());



    }
  }
}