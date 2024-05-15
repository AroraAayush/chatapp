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
class UserProfileScreen extends StatefulWidget {
  final UserModel user;
  const UserProfileScreen({super.key,required this.user});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final editUsernameController=TextEditingController();
  final profileController=Get.put(ProfileController());

  @override
  void initState() {
    editUsernameController.text=widget.user.username;
    super.initState();
  }

  @override
  void dispose() {
    editUsernameController.clear();
    super.dispose();
  }
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
        children:[ StreamBuilder(stream: UserServices.getUserDetails(widget.user.id),
        builder: (context,snapshot)
          {
            if(snapshot.hasData)
              {
                UserModel user=UserModel.fromUser(snapshot.data);
                return  Column(
                    children: [
                      Stack(
                          children:[ Container(
                            margin: EdgeInsets.only(top: 40),
                            width: double.infinity,
                            child: CustomProfile(
                                profileUrl: user.profileUrl,
                              username: user.username,
                              radius: 75,
                              color: AppColors.primary.withOpacity(0.5),
                              fontsize: 25

                            )
                          ),
                            Positioned(
                              left: 240,
                              top: 140,
                              child: InkWell(
                                onTap: (){
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Wrap(
                                        children: [
                                          ListTile(
                                            onTap: ()async{
                                              Navigator.pop(context);
                                             await UserServices.pickProfileImage("camera", profileController.auth.currentUser!.uid);

                                            },
                                            leading: Icon(Icons.camera),
                                            title: Text('Camera'),
                                          ),
                                          ListTile(
                                            onTap: ()async{
                                              Navigator.pop(context);
                                              await UserServices.pickProfileImage("gallery", profileController.auth.currentUser!.uid);

                                            },
                                            leading: Icon(Icons.camera_alt),
                                            title: Text('Gallery'),
                                          ),

                                        ],
                                      );
                                    },
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.white.withOpacity(0.3),
                                  child: Icon(Icons.camera_alt),
                                ),
                              ),
                             )
          ]
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Obx((){
                        return ListTile(
                          title: CustomText(
                            text: "Username",
                          color: Colors.black54,
                            fontSize: 14,
                          ),
                          subtitle:
                          profileController.isEditingUsername.value==false?
                          Padding(
                            padding: const EdgeInsets.only(left:3.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(text: user.username,fontSize: 15,),
                                Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: InkWell(
                                      onTap: (){
                                        profileController.isEditingUsername.value=true;
                                      },
                                      child: Icon(Icons.edit)),
                                )
                              ],
                            ),
                          ) :
                          TextField(
                            controller: editUsernameController,
                            decoration: InputDecoration(
                                suffixIcon: InkWell(
                                    onTap: (){
                                      UserServices.editUsername(user.id, editUsernameController.text);
                                      // editUsernameController.clear();
                                      profileController.isEditingUsername.value=false;
                                    },
                                    child: Icon(Icons.done))
                            ),
                          )
                          ,

                        );
                      })
        ,
                      Divider(
                        height: 1,
                      ),
                      ListTile(
                        title: CustomText(
                      text: "Email",
          color: Colors.black54,
          fontSize: 14,
          ),
                        subtitle: Text("${user.email}"),
                      ),

                    ]
          );
              }
            else
              {
                return SizedBox();
              }

          },) ,

          Obx((){
            return   profileController.uploading.value==true?
            Center(
              child: Container(
                height: 70,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                        color: Colors.lime.withOpacity(0.6),
                      ),

                    ),
                    Text("Updating Profile "),
                  ],
                ),
              ),
            ):SizedBox();
          })


        ]
      )

        
      );

  }
}
