import 'package:chatwithaayushhhh/colors/appcolors.dart';
import 'package:chatwithaayushhhh/custom/customText.dart';
import 'package:chatwithaayushhhh/custom/customprofile.dart';
import 'package:chatwithaayushhhh/firebase/userservices.dart';
import 'package:chatwithaayushhhh/pages/home/models/usermodel.dart';
import 'package:chatwithaayushhhh/pages/profile/profilecontroller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
class RecieverProfileScreen extends StatefulWidget {
  final UserModel reciever;
  const RecieverProfileScreen({super.key,required this.reciever});

  @override
  State<RecieverProfileScreen> createState() => _RecieverProfileScreenState();
}

class _RecieverProfileScreenState extends State<RecieverProfileScreen> {

  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  final profileController=Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile Screen"),
          centerTitle: true,
          backgroundColor: AppColors.primary,
        ),
        body:
        Stack(
            children:[ StreamBuilder(stream: UserServices.getUserDetails(widget.reciever.id),
              builder: (context,snapshot)
              {
                if(snapshot.hasData)
                {
                  UserModel rec=UserModel.fromUser(snapshot.data);
                  return  Column(
                      children: [
                        Stack(
                            children:[ Container(
                                margin: EdgeInsets.only(top: 40),
                                width: double.infinity,
                                child: CustomProfile(
                                    profileUrl:rec.profileUrl,
                                    username: rec.username,
                                    radius: 75,
                                    color: AppColors.primary.withOpacity(0.5),
                                    fontsize: 30

                                )
                            ),
                            ]
                        ),
                        SizedBox(
                          height: 40,
                        ),
                       ListTile(
                            title: CustomText(
                              text: "Username",
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                            subtitle:
                            Padding(
                              padding: const EdgeInsets.only(left:3.0),
                              child: CustomText(text: rec.username,fontSize: 15,),
                            ),
                        ),
                        Divider(
                          height: 1,
                        ),
                        ListTile(
                          title: CustomText(
                            text: "Email",
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                          subtitle: Text("${rec.email}"),
                        ),

                      ]
                  );
                }
                else
                {
                  return SizedBox();
                }

              },) ,



            ]
        )


    );

  }
}
