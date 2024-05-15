import 'package:chatwithaayushhhh/custom/customText.dart';
import 'package:chatwithaayushhhh/firebase/chatservices.dart';
import 'package:chatwithaayushhhh/mediaqueries/media.dart';
import 'package:chatwithaayushhhh/pages/generalchat/generalchatcontroller.dart';
import 'package:chatwithaayushhhh/pages/generalchat/models/messageModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
class MessageWidget extends StatefulWidget {
  final MessageModel msg;
  final String msgId;
   MessageWidget({super.key,required this.msg,required this.msgId});

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  final generalChatControlller=Get.put(GeneralChatController());

  @override
  void initState() {
    updateIsReadStatus(widget.msgId,widget.msg.roomId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isSender=(generalChatControlller.auth.currentUser!.uid== widget.msg.senderId);
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
             MediaFormat(widget.msg.mediaUrl)=="image"?Center(
                child:
                FadeInImage.assetNetwork(
                  placeholder: 'assets/images/faded.jpeg',
                  image: widget.msg.mediaUrl,
                ),
                // ConstrainedBox(constraints: BoxConstraints(minWidth: 50,minHeight: 50,maxWidth: 300,maxHeight: 300),
                // child: Image.network(widget.msg.mediaUrl),),
              ).marginOnly(bottom: 5): MediaFormat(widget.msg.mediaUrl)=="document"?Container(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   Image.asset('assets/images/docimage.png',height: 150,
                   width: 150,).marginOnly(bottom: 5),
                   CustomText(text: extractFileName())
                 ]

               ).marginOnly(bottom: 5),
             ):Column(
                     children: [

                       Image.asset('assets/images/pdfimage.png',height: 150,
                         width: 150,).marginOnly(bottom: 5),
                       CustomText(text: extractFileName())
                     ]

                 ).marginOnly(bottom: 5),

          widget.msg.msgText==""?SizedBox():
          CustomText(
            text: widget.msg.msgText,
          fontSize: 15,
            maxLines: 50,
          ),
          Wrap(
            children: [
              widget.msg.isStarred.contains(generalChatControlller.auth.currentUser!.uid)?
              Padding(
                padding: const EdgeInsets.only(top:2.0,right: 4),
                child: Icon(Icons.star,color: Colors.black.withOpacity(0.9),size: 14,),
              ):SizedBox(),
              CustomText(
                text: ConvertTimeInto_AMPM_Format(widget.msg.time),
              ),
              widget.msg.senderId==generalChatControlller.auth.currentUser!.uid?
              Padding(
                padding: const EdgeInsets.only(top:2.0,left: 4),
                child: Icon(Icons.done_all,color: widget.msg.isRead==true?Colors.blue:Colors.black.withOpacity(0.9),size: 15,),
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
    if(widget.msg.isRead==false && widget.msg.senderId!=generalChatControlller.auth.currentUser!.uid)
      {

        await ChatServices.updateIsRead(msgId, roomId);
      }
  }

  String MediaFormat(String mediaUrl) {
    if(mediaUrl.contains('.doc') ||mediaUrl.contains('.docx') )
      return "document";
    else if(mediaUrl.contains('.pdf'))
      return "pdf";
    else
      return "image";
  }

  String extractFileName() {
    String url=widget.msg.mediaUrl;
    print("Url : ${url}");
   int start=url.indexOf('documents%2F');
    int end=url.indexOf('?',start);
   return url.substring(start+12,end);
  }
}



