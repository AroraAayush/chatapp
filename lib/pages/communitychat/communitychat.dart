import 'package:chatwithaayushhhh/custom/customText.dart';
import 'package:chatwithaayushhhh/custom/customprofile.dart';
import 'package:chatwithaayushhhh/firebase/communitychatservices.dart';
import 'package:chatwithaayushhhh/firebase/groupchatservices.dart';
import 'package:chatwithaayushhhh/firebase/userservices.dart';
import 'package:chatwithaayushhhh/mediaqueries/media.dart';
import 'package:chatwithaayushhhh/pages/communitychat/communitycontroller.dart';
import 'package:chatwithaayushhhh/pages/communitychat/models/communityModel.dart';
import 'package:chatwithaayushhhh/pages/communitychat/models/communitymessagemodel.dart';
import 'package:chatwithaayushhhh/pages/generalchat/generalchat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class CommunityChat extends StatefulWidget {
  const CommunityChat({super.key});

  @override
  State<CommunityChat> createState() => _CommunityChatState();
}

class _CommunityChatState extends State<CommunityChat> {
  final communityController=Get.put(CommunityController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: Column(
        children: [
          ListTile(
            onTap: (){
              Navigator.pushNamed(context, '/createcommunityscreen');
            },
            leading: CircleAvatar(
              backgroundColor: Colors.green.shade100,
              child: Icon(Icons.groups),
            ),
            title: Text("Create New Community"),
          ),
          Divider(
            height: 3,
          ),
          StreamBuilder(stream: CommunityChatServices.getAllCommunities(communityController.auth.currentUser!.uid), builder: (context,snapshot)
          {
            if(snapshot.hasData)
            {
              dynamic communities=snapshot.data!.docs;
              return Container(
                  height: Utils.screenHeight(context)*0.5,
                  child: ListView.separated(
                      separatorBuilder: (context,index)
                      {
                        return SizedBox(height: 1,);
                      },
                      padding: EdgeInsets.zero,
                      itemCount: communities.length,
                      itemBuilder: (context,index)
                      {
                        CommunityModel community=CommunityModel.fromCommunity(communities[index].data());
                        return ListTile(
                            onTap: (){
                              Navigator.pushNamed(context, '/communitychatscreen',arguments: community);
                            },
                            leading: CustomProfile(username: community.communityname,radius: 21,profileUrl:
                            community.communityIcon,color: Colors.green.withOpacity(0.9),textColor: Colors.black,),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: "${community.communityname.capitalize}",
                                  fontSize: 15,
                                ),
                                CustomText(text: ConvertTimeInto_AMPM_Format(community.recent),fontSize: 14,)
                              ],
                            ),
                            subtitle:
                            StreamBuilder(stream: CommunityChatServices.getMessagesDesc(community.communityId),
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
                                          dynamic member = community.members[index];
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
                                        itemCount: community.members.length,
                                        separatorBuilder: (context, index) {
                                          return Text(" , ");
                                        },),
                                    );
                                  }
                                  else
                                  {
                                    CommunityMessageModel msg = CommunityMessageModel
                                        .fromCommunityMessage(
                                        snapshot.data!.docs[0].data());
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            (msg.senderId==communityController.auth.currentUser!.uid)? Padding(
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
    );;
  }
}
