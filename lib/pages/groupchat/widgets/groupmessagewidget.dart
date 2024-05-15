import 'package:chatwithaayushhhh/custom/customText.dart';
import 'package:chatwithaayushhhh/firebase/chatservices.dart';
import 'package:chatwithaayushhhh/mediaqueries/media.dart';
import 'package:chatwithaayushhhh/pages/generalchat/generalchatcontroller.dart';
import 'package:chatwithaayushhhh/pages/generalchat/models/messageModel.dart';
import 'package:chatwithaayushhhh/pages/groupchat/groupchatcontroller.dart';
import 'package:chatwithaayushhhh/pages/groupchat/models/groupmessagemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
class GroupMessageWidget extends StatefulWidget {
  final GroupMessageModel msg;
  final String msgId;
  final List<dynamic> members;
  GroupMessageWidget({super.key,required this.msg,required this.msgId,required this.members});

  @override
  State<GroupMessageWidget> createState() => _GroupMessageWidgetState();
}

class _GroupMessageWidgetState extends State<GroupMessageWidget> {
  final groupChatControlller=Get.put(GroupchatController());

  @override
  void initState() {
    updateIsReadStatus(widget.msgId,widget.msg.groupId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isSender=(groupChatControlller.auth.currentUser!.uid== widget.msg.senderId);
    //bool starred=IsThisMessageStarredByCurrentUser(msgId,starredMsgs);
    return Container(
      constraints: BoxConstraints(
          maxWidth: Utils.screenWidth(context)*0.65
      ),

      padding: EdgeInsets.only(top:8,bottom: 8,right: 8,left: 8),
      decoration: BoxDecoration(
          color: isSender? Colors.green : Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.all(Radius.circular(7))
      ),
      margin: isSender?EdgeInsets.only(right: 5,top: 2,bottom: 2):EdgeInsets.only(left: 5,top: 2,bottom: 2),

      child: Column(
        crossAxisAlignment: isSender?  CrossAxisAlignment.end :CrossAxisAlignment.start ,
        children: [
          widget.msg.mediaUrl==""?SizedBox():
          Center(
            child:
            FadeInImage.assetNetwork(
              placeholder: 'assets/images/faded.jpeg',
              image: widget.msg.mediaUrl,
            ),
            // ConstrainedBox(constraints: BoxConstraints(minWidth: 50,minHeight: 50,maxWidth: 300,maxHeight: 300),
            // child: Image.network(widget.msg.mediaUrl),),
          ).marginOnly(bottom: 5),

          widget.msg.msgText==""?SizedBox():
          CustomText(
            text: widget.msg.msgText,
            fontSize: 15,
            maxLines: 50,
          ),
          Wrap(
            children: [
              widget.msg.isStarred.contains(groupChatControlller.auth.currentUser!.uid)?
              Padding(
                padding: const EdgeInsets.only(top:2.0,right: 4),
                child: Icon(Icons.star,color: Colors.black.withOpacity(0.9),size: 14,),
              ):SizedBox(),
              CustomText(
                text: ConvertTimeInto_AMPM_Format(widget.msg.time),
              ),
              widget.msg.senderId==groupChatControlller.auth.currentUser!.uid?
              Padding(
                padding: const EdgeInsets.only(top:2.0,left: 4),
                child: Icon(Icons.done_all,color: widget.msg.isRead.length>=widget.members.length?Colors.blue:Colors.black.withOpacity(0.9),size: 15,),
              ):SizedBox()
            ],
          )
        ],
      ),
    );
  }

  String ConvertTimeInto_AMPM_Format(DateTime time) {
    //  print("time type : ${time.runtimeType}");
    String res=DateFormat.jm().format(time);
    return res;
  }

  bool IsThisMessageStarredByCurrentUser(String msgId, List<dynamic> starredMsgs) {
    for(dynamic starred in starredMsgs!)
    {
      if(starred==msgId)
      {
        return true;
      }
    }
    return false;
  }

  void updateIsReadStatus(String msgId,String roomId) async{
    if(widget.msg.isRead==false && widget.msg.senderId!=groupChatControlller.auth.currentUser!.uid)
    {

     // await ChatServices.updateIsRead(msgId, roomId);
    }
  }
}



