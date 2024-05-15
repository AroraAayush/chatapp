import 'package:chatwithaayushhhh/colors/appcolors.dart';
import 'package:chatwithaayushhhh/custom/customText.dart';
import 'package:chatwithaayushhhh/custom/customprofile.dart';
import 'package:chatwithaayushhhh/firebase/groupchatservices.dart';
import 'package:chatwithaayushhhh/firebase/userservices.dart';
import 'package:chatwithaayushhhh/mediaqueries/media.dart';
import 'package:chatwithaayushhhh/pages/groupchat/models/groupmodel.dart';
import 'package:chatwithaayushhhh/pages/home/models/usermodel.dart';
import 'package:chatwithaayushhhh/pages/profile/profilecontroller.dart';
import 'package:chatwithaayushhhh/pages/profile/widgets/customleavegroupbutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class GroupProfileScreen extends StatefulWidget {
  final GroupModel group;
  const GroupProfileScreen({super.key,required this.group});

  @override
  State<GroupProfileScreen> createState() => _GroupProfileScreenState();
}

class _GroupProfileScreenState extends State<GroupProfileScreen> {
  final profileController=Get.put(ProfileController());
  final editgroupnameController=TextEditingController();

  @override
  void initState() {
    editgroupnameController.text=widget.group.groupname;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: CustomText(text: "Group Profile Screen",),
        backgroundColor: Colors.green,
      ),
      body:Stack(
          children:[ StreamBuilder(stream: GroupChatServices.getGroupDetails(widget.group.groupId),
            builder: (context,snapshot)
            {
              if(snapshot.hasData)
              {
                GroupModel group=GroupModel.fromGroup(snapshot.data);
                return  Column(
                    children: [
                      Stack(
                          children:[ Container(
                              margin: EdgeInsets.only(top: 40),
                              width: double.infinity,
                              child: CustomProfile(
                                  profileUrl: group.groupIcon,
                                  username: group.groupname,
                                  radius: 75,
                                  color: AppColors.primary.withOpacity(0.5),
                                  fontsize: 25

                              )
                          ),
                            IsAdmin(group.members,profileController.auth.currentUser!.uid)?
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
                                              await GroupChatServices.pickGroupProfileImage("camera",group.groupId);

                                            },
                                            leading: Icon(Icons.camera),
                                            title: Text('Camera'),
                                          ),
                                          ListTile(
                                            onTap: ()async{
                                              Navigator.pop(context);
                                              await GroupChatServices.pickGroupProfileImage("gallery", group.groupId);

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
                            ):SizedBox()
                          ]
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Obx((){
                        return ListTile(
                          title: CustomText(
                            text: "Groupname",
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                          subtitle:
                          profileController.isEditingGroupname.value==false?
                          Padding(
                            padding: const EdgeInsets.only(left:3.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(text: group.groupname,fontSize: 15,),
                                IsAdmin(group.members,profileController.auth.currentUser!.uid)?
                                Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: InkWell(
                                      onTap: (){
                                        profileController.isEditingGroupname.value=true;
                                      },
                                      child: Icon(Icons.edit)),
                                ):SizedBox()
                              ],
                            ),
                          ) :
                          TextField(
                            controller: editgroupnameController,
                            decoration: InputDecoration(
                                suffixIcon: InkWell(
                                    onTap: (){
                                  //    UserServices.editUsername(user.id, editUsernameController.text);
                                      // editUsernameController.clear();
                                      profileController.isEditingGroupname.value=false;
                                    },
                                    child: Icon(Icons.done))
                            ),
                          )

                        );
                      })
                      ,
                      Divider(
                        height: 1,
                      ),
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Wrap(
                              children: [
                                CustomText(
                                  text: "${group.members.length}",fontSize: 16,
                                ),
                                CustomText(text: " Members")
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Icon(Icons.search),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                      IsAdmin(group.members,profileController.auth.currentUser!.uid)?
                      ListTile(
                        onTap: (){
                          Navigator.pushNamed(context, '/addmemberscreen2',arguments: {"groupId" :group.groupId,
                              "members": group.members});
                        },
                        title: CustomText(text: "Add Members",),
                        leading: Icon(Icons.group_add_outlined),
                      ).marginOnly(left: 10,top: 5):SizedBox(),
                      Container(
                        height: Utils.screenHeight(context)*0.3,
                        child: ListView.separated(itemBuilder: (context,index)
                            {
                              return StreamBuilder(stream: UserServices.getUserDetails(group.members[index]), builder: (context,snapshot)
                              {
                                if(snapshot.hasData)
                                  {
                                    UserModel user=UserModel.fromUser(snapshot.data);
                                    return Container(
                                      margin: EdgeInsets.only(left: 5,right: 5),
                                      padding: EdgeInsets.only(top: 4,bottom: 4),
                                      child: ListTile(
                                        leading: CustomProfile(username: user.username,radius: 22,profileUrl: user.profileUrl,color: Colors.green.withOpacity(0.5),textColor: Colors.black,),
                                        title: CustomText(
                                          text: IfUserIsYou(user.id)? "You":"${user.firstname.toString().capitalize}",
                                          fontSize: 16,
                                        ),

                                      ),
                                    );
                                  }
                                else
                                  {
                                    return SizedBox();
                                  }
                              });
                            },
                            separatorBuilder: (context,index)
                            {
                            return SizedBox(height: 2,);
                            }, itemCount: group.members.length),
                      ).marginOnly(top: 5),

                      Expanded(child: SizedBox()),
                      CustomLeaveGroupButton(text: 'Leave Group',buttonColor: Colors.red,buttonTextColor: Colors.white,onPressed: (){

                      },).marginOnly(bottom: 7)
                    ]
                );
              }
              else
              {
                return SizedBox();
              }

            },) ,
            //
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

  bool IsAdmin(List members, String uid) {
    if(members.contains(uid))
      return true;
    else
      return false;
  }

  IfUserIsYou(String id) {
    if(id==profileController.auth.currentUser!.uid)
      return true;
    else
      return false;
  }
}
