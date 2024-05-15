import 'package:chatwithaayushhhh/custom/customText.dart';
import 'package:chatwithaayushhhh/custom/customprofile.dart';
import 'package:chatwithaayushhhh/firebase/chatservices.dart';
import 'package:chatwithaayushhhh/firebase/userservices.dart';
import 'package:chatwithaayushhhh/mediaqueries/media.dart';
import 'package:chatwithaayushhhh/pages/generalchat/generalchatcontroller.dart';
import 'package:chatwithaayushhhh/pages/generalchat/models/messageModel.dart';
import 'package:chatwithaayushhhh/pages/home/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
class GeneralChat extends StatefulWidget {
  const GeneralChat({super.key});

  @override
  State<GeneralChat> createState() => _GeneralChatState();
}

class _GeneralChatState extends State<GeneralChat> {
  final generalchatcontroller=Get.put(GeneralChatController());


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: ChatServices.getUserDets(generalchatcontroller.auth.currentUser!.uid),
        builder: (context,snapshot)
        {
          if(snapshot.hasData)
            {
              UserModel userr=UserModel.fromUser(snapshot.data!.data());

              dynamic chatted_with=userr.chatted_with;
              if(chatted_with.length==0)
                {
                  return Center(child: CustomText(
                    text: "You have not chatted with anyone...",
                    fontSize: 16,
                  ),);
                }
              else
                {
                  return StreamBuilder(
                      stream: UserServices.getAllChattedChatRooms(),
                      builder: (context,snapshot)
                  {
                    if(snapshot.hasData)
                      {
                        dynamic chatrooms=snapshot.data!.docs;
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                            itemCount: chatrooms.length,
                            itemBuilder: (context,index){
                            dynamic roomId=chatrooms[index]["roomId"];
                            String recId=roomId.toString().replaceAll(generalchatcontroller.auth.currentUser!.uid, "");
                            recId=recId.replaceAll("_", "");
                            return StreamBuilder(stream: UserServices.getUserDetails(recId),
                                builder: (context,snapshot)
                            {
                              if(snapshot.hasData)
                                {
                                  dynamic tmp=snapshot.data;
                                    UserModel rec=UserModel.fromUser(snapshot.data!.data());
                                  return StreamBuilder(
                                    stream: ChatServices.getMessagesDescending(roomId),
                                    builder: (context, snapshot) {
                                      if(snapshot.hasData)

                                        {
                                          dynamic msgs=snapshot.data!.docs;
                                          if(msgs.length==0)
                                            {
                                              return ListTile(
                                                  onTap: (){
                                                    Navigator.pushNamed(context, '/generalchatscreen',arguments: {
                                                      "roomId": roomId,
                                                      "members": chatrooms[index]["members"],
                                                      "recId": recId,
                                                      "chatted" :rec.chatted_with,
                                                      "reciever" : rec
                                                    });
                                                  },
                                                  leading: CustomProfile(username: rec.username,radius: 20,profileUrl: rec.profileUrl,color: Colors.green.withOpacity(0.9),textColor: Colors.black,),
                                                  title: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      CustomText(
                                                        text: "${rec.firstname.capitalize}",
                                                        fontSize: 16,
                                                      ),
                                                    //  CustomText(text: ConvertTimeInto_AMPM_Format(msg.time),fontSize: 14,)
                                                    ],
                                                  ),
                                                  subtitle: Row(
                                                    children: [
                                                      // (msg.senderId==generalchatcontroller.auth.currentUser!.uid)? Padding(
                                                      //     padding: EdgeInsets.only(right: 4),
                                                      //     child: Icon(Icons.done_all,size: 17,)):SizedBox(),
                                                      Container(
                                                          width: Utils.screenWidth(context)*0.65,
                                                          child: CustomText(text: "${userr.email }",fontSize: 14,)),
                                                    ],
                                                  )
                                              );
                                            }
                                            else {
                                            MessageModel msg = MessageModel
                                                .fromMessage(
                                                snapshot.data!.docs[0].data());
                                            return ListTile(
                                                onTap: (){
                                                  Navigator.pushNamed(context, '/generalchatscreen',arguments: {
                                                    "roomId": roomId,
                                                    "members": chatrooms[index]["members"],
                                                    "recId": recId,
                                                    "chatted" :rec.chatted_with,
                                                    "reciever" : rec
                                                  });
                                                },
                                                leading: CustomProfile(username: rec.username,radius: 20,profileUrl: rec.profileUrl,color: Colors.green.withOpacity(0.9),textColor: Colors.black,),
                                                title: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    CustomText(
                                                      text: "${rec.firstname.capitalize}",
                                                      fontSize: 16,
                                                    ),
                                                    CustomText(text: ConvertTimeInto_AMPM_Format(msg.time),fontSize: 14,)
                                                  ],
                                                ),
                                                subtitle: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        (msg.senderId==generalchatcontroller.auth.currentUser!.uid)? Padding(
                                                            padding: EdgeInsets.only(right: 4),
                                                            child: Icon(Icons.done_all,size: 17,color: msg.isRead==true? Colors.blue:Colors.black,)):SizedBox(),
                                                        msg.mediaUrl==""?SizedBox(): MediaType(msg.mediaUrl)=="image"?Icon(Icons.image,size: 20,).paddingOnly(right: 5):MediaType(msg.mediaUrl)=="pdf"?Icon(Icons.file_copy,size: 17,).paddingOnly(right: 5):Icon(Icons.file_copy_sharp,size: 17,).paddingOnly(right: 5),
                                                        msg.msgText!=""?Container(
                                                            width: Utils.screenWidth(context)*0.6,
                                                            child: CustomText(text: "${msg.msgText }",fontSize: 14,)):MediaType(msg.mediaUrl)=="image"?CustomText(text: "Image",fontSize: 14,):MediaType(msg.mediaUrl)=="document"?CustomText(text: "Document",fontSize: 14,):CustomText(text: "Pdf",fontSize: 14,),
                                                      ],
                                                    ),
                                                    (getUnreadMsgsCount(msgs)!= 0 )?
                                                    CircleAvatar(radius: 9,backgroundColor: Colors.green,
                                                    child: CustomText(text: '${getUnreadMsgsCount(msgs)}',fontSize: 12,),):SizedBox()
                                                  ],
                                                )
                                            );
                                          }
                                          ;}
                                      else
                                        {
                                          return SizedBox();
                                        }

                                    }
                                  );
                                }
                              else
                                {
                                  return SizedBox();
                                }
                            });

                        });
                      }
                    else
                      {
                        return SizedBox();
                      }
                  });
                }
            }
          else
            {
              return SizedBox();
            }
        },
      ),
    );
  }

  int getUnreadMsgsCount(dynamic msgs)
  {
    int ct=0;
    for(dynamic tmp in msgs)
    {
      MessageModel msgg=MessageModel.fromMessage(tmp.data());
      if(msgg.senderId==generalchatcontroller.auth.currentUser!.uid)
        return ct;
      else if(msgg.isRead==false)
        ct++;
      else if(msgg.isRead==true)
        return ct;
    }
    return ct;

  }

}

String ConvertTimeInto_AMPM_Format(DateTime time) {
  print("time type : ${time.runtimeType}");
  String msgDate=DateFormat.yMMMMEEEEd().format(time);
  String currentDate=DateFormat.yMMMMEEEEd().format(DateTime.now());
  DateTime prev= DateTime.now().subtract(Duration(days:1));
  String prevDate=DateFormat.yMMMMEEEEd().format(prev);

  if(msgDate==currentDate)
    return DateFormat.jm().format(time);
  else if( msgDate==prev)
    return "Yesterday";
  else
    {
      return DateFormat.yMd().format(time);
    }

}

MediaType(String mediaUrl) {
  if(mediaUrl.contains('jpg') ||mediaUrl.contains('png') ||mediaUrl.contains('.jpeg'))
  {
    return "image";
  }
  else if(mediaUrl.contains('.doc') || mediaUrl.contains('.docx'))
  {
    return "document";
  }
  else if(mediaUrl.contains('.pdf') )
  {
    return "pdf";
  }
  else
    return "other";
}

