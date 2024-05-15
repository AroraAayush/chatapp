import 'package:chatwithaayushhhh/custom/customText.dart';
import 'package:chatwithaayushhhh/custom/customprofile.dart';
import 'package:chatwithaayushhhh/firebase/groupchatservices.dart';
import 'package:chatwithaayushhhh/firebase/userservices.dart';
import 'package:chatwithaayushhhh/mediaqueries/media.dart';
import 'package:chatwithaayushhhh/pages/generalchat/generalchat.dart';
import 'package:chatwithaayushhhh/pages/generalchat/models/messageModel.dart';
import 'package:chatwithaayushhhh/pages/groupchat/groupchatcontroller.dart';
import 'package:chatwithaayushhhh/pages/groupchat/models/groupmessagemodel.dart';
import 'package:chatwithaayushhhh/pages/groupchat/models/groupmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class GroupChat extends StatefulWidget {
  const GroupChat({super.key});

  @override
  State<GroupChat> createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  final groupchatController=Get.put(GroupchatController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: Column(
        children: [
          ListTile(
            onTap: (){
              Navigator.pushNamed(context, '/addmemberscreen');
            },
            leading: CircleAvatar(
              backgroundColor: Colors.green.shade100,
              child: Icon(Icons.group),
            ),
            title: Text("Create New Group"),
          ),
          Divider(
            height: 3,
          ),
          StreamBuilder(stream: GroupChatServices.getAllGroups(groupchatController.auth.currentUser!.uid), builder: (context,snapshot)
          {
            if(snapshot.hasData)
              {
                dynamic grps=snapshot.data!.docs;
                return Container(
                    height: Utils.screenHeight(context)*0.5,
                    child: ListView.separated(
                      separatorBuilder: (context,index)
                        {
                          return SizedBox(height: 1,);
                        },
                      padding: EdgeInsets.zero,
                        itemCount: grps.length,
                        itemBuilder: (context,index)
                    {
                      GroupModel grp=GroupModel.fromGroup(grps[index].data());
                      return ListTile(
                          onTap: (){
                            Navigator.pushNamed(context, '/groupchatscreen',arguments: grp);
                          },
                          leading: CustomProfile(username: grp.groupname,radius: 21,profileUrl: grp.groupIcon,color: Colors.green.withOpacity(0.9),textColor: Colors.black,),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: "${grp.groupname.capitalize}",
                                fontSize: 15,
                              ),
                               CustomText(text: ConvertTimeInto_AMPM_Format(grp.recent),fontSize: 14,)
                            ],
                          ),
                        subtitle:
                        StreamBuilder(stream: GroupChatServices.getMessagesDesc(grp.groupId),
                        builder: (context,snapshot)
                          {
                            if(snapshot.hasData)
                              {
                                dynamic msgs=snapshot.data!.docs;
                                if(msgs.length==0) {
                                  return SizedBox(
                                    height: 20,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        dynamic member = grp.members[index];
                                        return StreamBuilder(
                                            stream: UserServices.getUserDetails(
                                                member),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                dynamic user = snapshot.data;
                                                return CustomText(
                                                  text: "${user["username"]
                                                      .toString()
                                                      .capitalize}",
                                                  fontSize: 13,);
                                              }
                                              else {
                                                return SizedBox();
                                              }
                                            }
                                        );
                                      },
                                      itemCount: grp.members.length,
                                      separatorBuilder: (context, index) {
                                        return Text(" , ");
                                      },),
                                  );
                                }
                                else
                                  {
                                    GroupMessageModel msg = GroupMessageModel
                                        .fromGroupMessage(
                                        snapshot.data!.docs[0].data());
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            (msg.senderId==groupchatController.auth.currentUser!.uid)? Padding(
                                                padding: EdgeInsets.only(right: 4),
                                                child: Icon(Icons.done_all,size: 17,color: msg.isRead==true? Colors.blue:Colors.black,)):SizedBox(),
                                            msg.mediaUrl==""?SizedBox(): MediaType(msg.mediaUrl)=="image"?Icon(Icons.image,size: 20,).paddingOnly(right: 5):MediaType(msg.mediaUrl)=="pdf"?Icon(Icons.file_copy,size: 17,).paddingOnly(right: 5):Icon(Icons.file_copy_sharp,size: 17,).paddingOnly(right: 5),
                                            msg.msgText!=""?Container(
                                                width: Utils.screenWidth(context)*0.6,
                                                child: CustomText(text: "${msg.msgText }",fontSize: 14,)):MediaType(msg.mediaUrl)=="image"?CustomText(text: "Image",fontSize: 14,):MediaType(msg.mediaUrl)=="document"?CustomText(text: "Document",fontSize: 14,):CustomText(text: "Pdf",fontSize: 14,),
                                          ],
                                        ),
                                        // (getUnreadMsgsCount(msgs)!= 0 )?
                                        // CircleAvatar(radius: 9,backgroundColor: Colors.green,
                                        //   child: CustomText(text: '${getUnreadMsgsCount(msgs)}',fontSize: 12,),):SizedBox()
                                      ],
                                    );
                                  }

                              }
                            else
                              {
                                return SizedBox();
                              }
                          },)


                      );
                    }
                        ));
              }
            else
              {
                return SizedBox();
              }
          })

        ],
      )),
    );
  }


}
