import 'package:chatwithaayushhhh/colors/appcolors.dart';
import 'package:chatwithaayushhhh/custom/customText.dart';
import 'package:chatwithaayushhhh/custom/customprofile.dart';
import 'package:chatwithaayushhhh/firebase/userservices.dart';
import 'package:chatwithaayushhhh/mediaqueries/media.dart';
import 'package:chatwithaayushhhh/pages/home/homecontroller.dart';
import 'package:chatwithaayushhhh/pages/home/homeview.dart';
import 'package:chatwithaayushhhh/pages/home/models/usermodel.dart';
import 'package:chatwithaayushhhh/pages/home/widgets/customsearchtextfield.dart';
import 'package:chatwithaayushhhh/pages/signup/widgets/customtextfield.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
class HomeScreenDetailsWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  HomeScreenDetailsWidget({super.key,required this.scaffoldKey});

  @override
  State<HomeScreenDetailsWidget> createState() => _HomeScreenDetailsWidgetState();
}

class _HomeScreenDetailsWidgetState extends State<HomeScreenDetailsWidget> {
  final searchController=TextEditingController();

  final homecontroller=Get.put(HomeController());


  @override
  void initState() {
    initial();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color:AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.only(left:15.0,right: 15,top: 52),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
              stream: UserServices.getUserDetails(FirebaseAuth.instance.currentUser!.uid),
              builder: (context, snapshot) {
                if(snapshot.hasData)
                  {
                    print("User : ${snapshot.data!.data().runtimeType}");
                    UserModel user=UserModel.fromUser(snapshot.data!.data());
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding:EdgeInsets.only(left: 5),
                          width: Utils.screenWidth(context)*0.8,
                          child: CustomText(text: "Welcome back ${user.firstname.capitalize} !!! ",maxLines: 1,
                          fontSize: 23,),
                        ),
                        InkWell(
                            onTap:(){
                              widget.scaffoldKey.currentState!.openEndDrawer();
                            },
                            child: Image.asset('assets/images/drawerimg.png',height: 20,width: 20,))
                      ],
                    );
                  }
                else
                  {
                    return CustomText(text: "Loadingg....");
                  }


              }
            ).paddingOnly(bottom: 20),
            SizedBox(
                height: 40,
                child: CustomSearchTextField(controller: searchController,)).paddingOnly(bottom: 20),

           StreamBuilder(stream: UserServices.getAllUsers(), builder: (context,snapshot)
           {
             if(snapshot.hasData)
               {
                 dynamic users=snapshot.data!.docs;
                 return
                   Obx((){
                     return Container(
                       height: 110,
                       //width: 90,
                       child: (users.length==0 || homecontroller.filtered.value==true && homecontroller.filteredUsers.length==0)? Center(
                         child: CustomText(text: "No Users to show",),
                       ):ListView.builder(
                           scrollDirection: Axis.horizontal,
                           itemCount: users.length,
                           itemBuilder: (context,index){
                             UserModel user=UserModel.fromUser(users[index].data());
                             return  (homecontroller.filtered.value==true && !homecontroller.filteredUsers.contains(user.id))? SizedBox()
                            : InkWell(
                               onTap: () {
                                 List<String> members=[homecontroller.userId,user.id];
                                 members.sort();
                                 String roomId=members.join("_");
                                 bool chatted=false;
                                 if(user.chatted_with.contains(homeController.userId))
                                   chatted=true;
                                 Navigator.pushNamed(
                                     context, '/generalchatscreen', arguments: {
                                   "roomId": roomId,
                                   "members": members,
                                   "recId": user.id,
                                   "chatted" :chatted,
                                   "reciever" : user
                                 });
                               },
                               child: Column(
                                 children: [
                                   CustomProfile(username: user.username, radius:33 , profileUrl: user.profileUrl,fontsize: 18,),
                                   SizedBox(height: 6,),
                                   SizedBox(
                                       width: 90,
                                       child: Center(child: CustomText(text: "${user.firstname.capitalize}",fontSize: 17,maxLines: 1)))
                                 ],
                               ),
                             );
                           }),
                     );
                   });


               }
             else
               {
                 return SizedBox();
               }
           }).paddingOnly(top:10)
          ],
        ),
      ),
    );
  }

  void initial() async{
    await homecontroller.getAllUsers();
  }
}
