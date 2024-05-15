import 'package:chatwithaayushhhh/custom/customText.dart';
import 'package:chatwithaayushhhh/custom/customprofile.dart';
import 'package:chatwithaayushhhh/firebase/userservices.dart';
import 'package:chatwithaayushhhh/mediaqueries/media.dart';
import 'package:chatwithaayushhhh/pages/home/homecontroller.dart';
import 'package:chatwithaayushhhh/pages/home/models/usermodel.dart';
import 'package:chatwithaayushhhh/pages/home/widgets/homescreendetailswidget.dart';
import 'package:chatwithaayushhhh/pages/home/widgets/tabbarwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}
final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();
final homeController=Get.put(HomeController());
late final AppLifecycleListener _listener;
class _HomeViewState extends State<HomeView>  with WidgetsBindingObserver {

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
  //  print("Init of home");
    updateInitialActiveStatus();
    super.initState();
  }
@override
  void dispose() {
  WidgetsBinding.instance.removeObserver(this );
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed)
    {
      print("Resumed");
      await UserServices.updateActivityStatus(true, FirebaseAuth.instance.currentUser!.uid);
    }
    else
      {
       await  UserServices.updateActivityStatus(false, FirebaseAuth.instance.currentUser!.uid);
        print("Closed");
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
     resizeToAvoidBottomInset: false,
     endDrawer:Drawer(
       child:
       StreamBuilder(
         stream: UserServices.getUserDetails(FirebaseAuth.instance.currentUser!.uid),
         builder: (context,snapshot)
         {
           if(snapshot.hasData)
             {
               UserModel user=UserModel.fromUser(snapshot.data);
               return Column(
                 children: [
                   UserAccountsDrawerHeader(
                     decoration: BoxDecoration(
                       color: Colors.green
                     ),
                     accountName: CustomText(
                     text: "${user.firstname.capitalize}",
                   ), accountEmail: CustomText(
                     text: "${user.email}",
                   ),
                     currentAccountPicture: CustomProfile(
                       profileUrl: user.profileUrl, username: user.username, radius: 30,

                     ),
                   ),
                   Container(
                     height: 40,
                     child: Row(
                       children: [
                         Padding(
                           padding: const EdgeInsets.only(left:15.0,right: 5),
                           child: CustomText(text: "Status : ",
                           fontSize: 16,
                           fontWeight: FontWeight.bold,),
                         ),
                         Padding(
                           padding: const EdgeInsets.only(right: 10),
                           child: CustomText(text: user.activeStatus==false?"Offline":"Online",fontSize: 17,fontWeight: FontWeight.w700,),
                         ),
                         CircleAvatar(
                           radius: 8,
                           backgroundColor: user.activeStatus==false?Colors.red:Colors.green,
                         )
                       ],
                     ),
                   ),
                   Divider(),
                   InkWell(
                     onTap: (){
                       Navigator.pushNamed(context, '/userprofilescreen',
                           arguments: user);
                     },
                     child: ListTile(
                       title: CustomText(text: "Profile",fontSize: 15,),
                       leading: Icon(Icons.house_rounded,size: 23,),
                     ),
                   ),
                   Divider(),
                   ListTile(
                     title: CustomText(text: "Settings",fontSize: 15,),
                     leading: Icon(Icons.settings,size: 23,),
                   ),
                   Divider(),
                   ListTile(
                     onTap: (){
                       Navigator.pushNamed(context, '/starredmessagescreen');
                     },
                     title: CustomText(text: "Starred Messages",fontSize: 15,),
                     leading: Icon(Icons.star,size: 23,),
                   ),
                   Divider(),
                   InkWell(
                     onTap: ()async{
                       await  UserServices.updateActivityStatus(false, FirebaseAuth.instance.currentUser!.uid);
                       FirebaseAuth.instance.signOut();
                       Navigator.pushNamedAndRemoveUntil(context, '/loginview', (route) => false);
                     },
                     child: ListTile(
                       title: CustomText(text: "Logout",fontSize: 15,),
                       leading: Icon(Icons.logout,size: 23,),
                     ),
                   )
                 ],
               );
             }
           else
             {
               return SizedBox();
             }
         },
       )

     ),
      body:SlidingUpPanel(
        borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
        minHeight: Utils.screenHeight(context)*0.66,
        maxHeight: Utils.screenHeight(context)*0.8,
        body: HomeScreenDetailsWidget(scaffoldKey:scaffoldkey),
        panelBuilder: (controller)=> TabbarWidget(
          controller:controller,
        ),
      ),

    );
  }

  updateInitialActiveStatus() async{
    print("Updating status");
    await UserServices.updateActivityStatus(true,FirebaseAuth.instance.currentUser!.uid);
    print("Updated");
  }
}
