import 'package:chatwithaayushhhh/custom/customText.dart';
import 'package:chatwithaayushhhh/custom/customprofile.dart';
import 'package:chatwithaayushhhh/firebase/groupchatservices.dart';
import 'package:chatwithaayushhhh/firebase/userservices.dart';
import 'package:chatwithaayushhhh/mediaqueries/media.dart';
import 'package:chatwithaayushhhh/pages/groupchat/groupchatcontroller.dart';
import 'package:chatwithaayushhhh/pages/groupchat/widgets/customgroupdescriptiontextfield.dart';
import 'package:chatwithaayushhhh/pages/groupchat/widgets/customgroupnametextfield.dart';
import 'package:chatwithaayushhhh/pages/home/models/usermodel.dart';
import 'package:chatwithaayushhhh/pages/signup/widgets/customsubmitbutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class CreateNewGroupScreen extends StatefulWidget {
  const CreateNewGroupScreen({super.key});

  @override
  State<CreateNewGroupScreen> createState() => _CreateNewGroupScreenState();
}

class _CreateNewGroupScreenState extends State<CreateNewGroupScreen> {
  final groupnameController=TextEditingController();
  final groupdescController=TextEditingController();
  final groupchatcontroller=Get.put(GroupchatController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Create New Group"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SizedBox(
        width: Utils.screenWidth(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(

              children:[ Positioned(
                child: CircleAvatar(backgroundColor: Colors.green.withOpacity(0.5),
                child: Icon(Icons.group,size: 50,),radius: 70,),
              ),
                Positioned(
                    right: 4,
                    top: 100,
                    child: InkWell(
                        onTap: (){
                          // showModalBottomSheet(
                          //   context: context,
                          //   builder: (context) {
                          //     return Wrap(
                          //       children: [
                          //         ListTile(
                          //           onTap: ()async{
                          //             Navigator.pop(context);
                          //             //await GroupChatServices.pickGroupProfileImage("camera", groupchatcontroller.currentId);
                          //
                          //           },
                          //           leading: Icon(Icons.camera),
                          //           title: Text('Camera'),
                          //         ),
                          //         ListTile(
                          //           onTap: ()async{
                          //             Navigator.pop(context);
                          //            // await GroupChatServices.pickGroupProfileImage("gallery", groupchatcontroller.currentId);
                          //
                          //           },
                          //           leading: Icon(Icons.camera_alt),
                          //           title: Text('Gallery'),
                          //         ),
                          //
                          //       ],
                          //     );
                          //   },
                          // );
                        },
                        child: CircleAvatar(radius: 15,backgroundColor: Colors.white,child: Icon(Icons.add_circle,size: 28,),)))


              ]
            ),
            CustomGroupNameTextField(controller: groupnameController, what: "Group Name",prefixIcon: Icon(Icons.group_outlined),validator: (value) {
              return groupnameValidator(
                  value);
            },).marginOnly(top:25,bottom: 20),
            CustomGroupDescriptionTextField(controller: groupdescController),
            Divider(
              height: 30,
            ),
            Column(
              children: [
                ListTile(
                  title: Text("Selected Members"),
                ),
                Obx((){
                  return Container(
                  height: 100,
                  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: groupchatcontroller.selectedMembers.length,
    itemBuilder: (context,index)
    {
    dynamic id=groupchatcontroller.selectedMembers[index];
    return StreamBuilder(stream: UserServices.getUserDetails(id),
    builder: (context,snapshot)
    {
    if(snapshot.hasData)
    {
    UserModel user=UserModel.fromUser(snapshot.data);
    return Column(
    children: [
    CustomProfile(username: user.username, radius:28 , profileUrl: user.profileUrl,fontsize: 16,color: Colors.green.withOpacity(0.5),),
    SizedBox(height: 6,),
    SizedBox(
    width: 90,
    child: Center(child: CustomText(text: "${user.firstname.capitalize}",fontSize: 16,maxLines: 1)))
    ],
    );
    }
    else
    {
    return SizedBox();
    }
    }
    );
    }),
    );
                }),
              ],
            ),
            Spacer(),
            Obx((){
              return CustomSubmitButton(text: "Create new group",buttonColor: groupchatcontroller.grpname.value==""?Colors.grey.withOpacity(0.3):Colors.green,buttonTextColor: Colors.white,
                onPressed:groupchatcontroller.grpname.value==""? null: ()async{
                  groupchatcontroller.selectedMembers.add(groupchatcontroller.currentId);
                  DateTime time=DateTime.now();
                await GroupChatServices.createGroup({
                  "groupname" : groupnameController.text,
                  "groupIcon" : null,
                  "members" : groupchatcontroller.selectedMembers.value,
                  "admin" : [groupchatcontroller.currentId],
                  "creationTime" :time,
                  "recent": time,
                });
               Navigator.pop(context);
               Navigator.pop(context);
               groupchatcontroller.resetAllGroupControllers();
               groupnameController.clear();
               groupdescController.clear();
              },).marginOnly(bottom: 10);

            })
                      ],
        ),
      ).marginOnly(top:30),
    );
  }

}

String? groupnameValidator(String? username)
{
if(username!.length==0)
{
return "Username can't be empty";
}
}

