

import 'dart:ffi';

import 'package:chatwithaayushhhh/custom/customText.dart';
import 'package:chatwithaayushhhh/custom/customprofile.dart';
import 'package:chatwithaayushhhh/firebase/chatservices.dart';
import 'package:chatwithaayushhhh/firebase/userservices.dart';
import 'package:chatwithaayushhhh/mediaqueries/media.dart';
import 'package:chatwithaayushhhh/pages/generalchat/generalchatcontroller.dart';
import 'package:chatwithaayushhhh/pages/generalchat/models/messageModel.dart';
import 'package:chatwithaayushhhh/pages/generalchat/widgets/custommessagetextfield.dart';
import 'package:chatwithaayushhhh/pages/generalchat/widgets/messagewidget.dart';
import 'package:chatwithaayushhhh/pages/home/homeview.dart';
import 'package:chatwithaayushhhh/pages/home/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GeneralChatScreen extends StatefulWidget {
  final Map<String, dynamic> args;
  const GeneralChatScreen({super.key, required this.args});

  @override
  State<GeneralChatScreen> createState() => _GeneralChatScreenState();
}

class _GeneralChatScreenState extends State<GeneralChatScreen> {
  final generalchatcontroller = Get.put(GeneralChatController());
  final messageController = TextEditingController();
  final editmessageController=TextEditingController();
  final scrollController = ScrollController();
  List<dynamic> starred = [];
  @override
  void initState() {
    initial();
    messageController.text=generalchatcontroller.msgText.value;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/recieverprofilescreen',
                  arguments: widget.args["reciever"]);
            },
            child: StreamBuilder(
              stream: UserServices.getUserDetails(widget.args["recId"]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  UserModel reciever = UserModel.fromUser(snapshot.data);
                  return Container(
                    child: Row(
                      children: [
                        CustomProfile(
                          username: reciever.username,
                          radius: 20,
                          profileUrl: reciever.profileUrl,
                        ),
                        SizedBox(
                          width: 14,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                maxWidth: Utils.screenWidth(context)*0.45
                              ),
                              child: CustomText(
                                text: reciever.username.capitalize.toString(),
                                fontSize: 19,
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: CustomText(
                                    text: reciever.activeStatus == false
                                        ? "Offline"
                                        : "Online",
                                    fontSize: 17,
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 6,
                                  backgroundColor:
                                      reciever.activeStatus == false
                                          ? Colors.red
                                          : Colors.green,
                                )
                              ],
                            ),

                          ],
                        ),
                        Spacer(),
                        Obx((){
                          return  generalchatcontroller.selectedMsg.length>=1 ?Row(
                            children: [
                              generalchatcontroller.unstarredCount.value>0 ? InkWell(
                                  onTap:()async{
                            await ChatServices.starMessages(generalchatcontroller.selectedMsg, generalchatcontroller.auth.currentUser!.uid,widget.args["roomId"]);
                            generalchatcontroller.resetAllControllers();
                          },
                                  child: Icon(Icons.star)):InkWell(
                                  onTap:()async{
                                    await ChatServices.unstarMessages(generalchatcontroller.selectedMsg, generalchatcontroller.auth.currentUser!.uid,widget.args["roomId"]);
                                    generalchatcontroller.resetAllControllers();
                                  },
                                  child: Icon(Icons.star_border)),
                              (generalchatcontroller.recieverMsgCount.value==0)?
                              InkWell(
                                  onTap:()async{
                                    await ChatServices.unstarMessages(generalchatcontroller.selectedMsg, generalchatcontroller.auth.currentUser!.uid, widget.args["roomId"]);
                                    await ChatServices.deleteMessages(generalchatcontroller.selectedMsg,widget.args["roomId"]);
                                    generalchatcontroller.resetAllControllers();
                                  },
                                  child: Icon(Icons.delete).paddingOnly(right: 2)) : SizedBox(),
                              (generalchatcontroller.selectedMsg.length==1 && generalchatcontroller.senderMsgCount.value==1)?
                              InkWell(
                                  onTap: ()async{
                                    Map<String,dynamic> selectedMsgInfo=await ChatServices.getMessageInfo(widget.args["roomId"],generalchatcontroller.selectedMsg[0]);
                                    messageController.text=selectedMsgInfo["msgText"];
                                    generalchatcontroller.msgText.value=messageController.text;
                                    generalchatcontroller.isEditingMessage.value=true;
                                  },
                                  child: Icon(Icons.edit).paddingOnly(right: 2)):SizedBox()
                            ],
                          ):SizedBox();
                        })

                      ],
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ),
        ),
        body: Stack(
          children:[ Column(
            children: [
              Expanded(
                  child: Container(
                color: Colors.white.withOpacity(0.4),
                child: StreamBuilder(
                  stream: ChatServices.getMessages(widget.args["roomId"]),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      dynamic msgs = snapshot.data!.docs;
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        scrollController.animateTo(
                          scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 10),
                          curve: Curves.easeOut,
                        );
                      });
                      return ListView.separated(
                          controller: scrollController,
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 1,
                            );
                          },
                          itemCount: msgs.length,
                          itemBuilder: (context, index) {
                            dynamic message = msgs[index];
                            String msgId = message.reference.id;
                            print("MsgID : ${msgId}");
                            print("Starred : ${starred}");
                            print("MSg Date : ${message["time"].toDate()}");
                            return Column(
                              children: [
                                (index == 0 ||
                                        IfNewDate(message["time"].toDate(),
                                            msgs[index - 1]["time"].toDate()))
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        padding: EdgeInsets.all(6),
                                        child: CustomText(
                                            text:
                                                "${ConvertTimeInto_AMPM_Format(message["time"].toDate())}"),
                                      ).marginOnly(top:5,bottom: 5)
                                    : SizedBox(),
                                Stack(
                                  children: [
                                    InkWell(
                                      onTap: () async{
                                        if (generalchatcontroller
                                                .selectedMsg.length >=
                                            1) {
                                          generalchatcontroller.selectedMsg
                                              .add(msgId);
                                          CheckMessageSentByWho(message["senderId"],"add");
                                       //   UserModel currentUser=await UserServices.getUserDets(generalchatcontroller.auth.currentUser!.uid);
                                          await CheckWhetherToStarOrUnStar(generalchatcontroller.auth.currentUser!.uid,message["isStarred"],"add");

                                        }
                                        else if(MediaType(message["mediaUrl"])=="image")
                                          {
                                            Navigator.pushNamed(context, '/imagedisplayscreen',arguments: message["mediaUrl"]);
                                          }
                                        else if(MediaType(message["mediaUrl"])=='document' || MediaType(message["mediaUrl"])=='pdf')
                                          {
                                            Navigator.pushNamed(context, '/documentdisplayscreen',arguments: message["mediaUrl"]);
                                          }
                                      },
                                      onLongPress: () async{
                                        generalchatcontroller.selectedMsg
                                            .add(msgId);
                                        CheckMessageSentByWho(message["senderId"],"add");
                                        await CheckWhetherToStarOrUnStar(generalchatcontroller.auth.currentUser!.uid,message["isStarred"],"add");
                                      },
                                      child:
                                      Align(
                                        alignment:message["senderId"]==generalchatcontroller.auth.currentUser!.uid?Alignment.centerRight:Alignment.centerLeft,
                                        child: MessageWidget(
                                            msg: MessageModel.fromMessage(
                                                msgs[index].data()),
                                            msgId: msgId,
                                          ),
                                      )
                                      ,
                                    ),
                                    Obx(() {
                                      return generalchatcontroller.selectedMsg
                                              .contains(msgId)
                                          ? Positioned.fill(
                                              child: InkWell(
                                                onTap: ()async{
                                                  if(generalchatcontroller.selectedMsg.length>=1)
                                                    {
                                                      generalchatcontroller.selectedMsg.removeWhere((val) => msgId==val);
                                                      CheckMessageSentByWho(message["senderId"],"remove");
                                                      await CheckWhetherToStarOrUnStar(generalchatcontroller.auth.currentUser!.uid,message["isStarred"],"remove");
                                                    }
                                                },
                                                child: Container(
                                                  width: Utils.screenWidth(context),
                                                  color:
                                                      Colors.blue.withOpacity(0.4),
                                                ),
                                              ),
                                            )
                                          : SizedBox();
                                    }),
                                  ],
                                )
                              ],
                            );
                          });
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              )),
              Row(children: [
                InkWell(
                  onTap: (){
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Wrap(
                          children: [
                            ListTile(
                              onTap: ()async{
                                Navigator.pop(context);
                                await ChatServices.pickImage("camera");

                              },
                              leading: Icon(Icons.camera),
                              title: Text('Camera'),
                            ),
                            ListTile(
                              onTap: ()async{
                                Navigator.pop(context);
                                await ChatServices.pickImage("gallery");

                              },
                              leading: Icon(Icons.camera_alt),
                              title: Text('Gallery'),
                            ),
                            ListTile(
                              onTap: ()async{
                                print("Documentttt");
                                Navigator.pop(context);
                                await ChatServices.pickDocument();

                              },
                              leading: Icon(Icons.file_copy),
                              title: Text('Document'),
                            ),

                          ],
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Icon(
                      Icons.add_circle_outline_sharp,
                      size: 26,
                    ),
                  ),
                ),
                CustomMessageTextField(
                  controller: messageController,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Obx(() {
                      return InkWell(
                          onTap: (generalchatcontroller.msgText.value == "" && generalchatcontroller.mediaUrl.value=="")
                              ? null
                              : () async {
                            String tmp=generalchatcontroller.msgText.value;
                            String tmp2=generalchatcontroller.mediaUrl.value;
                            generalchatcontroller.msgText.value = "";
                            generalchatcontroller.mediaUrl.value = "";
                                  if (widget.args["chatted"] == false) {
                                    await ChatServices.createRoom(
                                        widget.args["roomId"],
                                        widget.args["members"]);
                                    await ChatServices.updateChattedWith(
                                        widget.args["members"]);
                                  }


                                  messageController.clear();
                                  if(generalchatcontroller.isEditingMessage.value==true)
                                    {
                                      String msgId=generalchatcontroller.selectedMsg[0];
                                      await ChatServices.editMessage(widget.args["roomId"],tmp,msgId);
                                      generalchatcontroller.resetAllControllers();
                                    }
                                  else {
                                    await ChatServices.sendMessage(
                                        widget.args["roomId"],
                                        tmp,
                                        tmp2,
                                        widget.args["recId"]);
                                  }

                                },
                          child: Icon(
                            Icons.send,
                            color: (generalchatcontroller.msgText.value== "" && generalchatcontroller.mediaUrl.value=="")
                                ? Colors.grey
                                : Colors.black,
                          ));
                    }))
              ])
            ],
          ).paddingOnly(bottom: 10),

    Obx((){
    return   generalchatcontroller.loading.value==true?
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
    Text("Uploading"),
    ],
    ),
    ),
    ):SizedBox();
    }) ]
        ));
  }

  Future getCurrentUserDets() async {
    Map<String, dynamic>? current;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(generalchatcontroller.auth.currentUser!.uid)
        .get()
        .then((tmp) {
      current = tmp.data()!;
      print("Current : ${current!["starred_msgs"]}");
    });
    return current!["starred_msgs"];
  }

  void initial() async {
    starred = await getCurrentUserDets();
    print("Starred from func: ${starred}");
  }

  bool IfNewDate(DateTime msgDate, DateTime prevMsgDate) {
    print("Current msg Date : ${msgDate}");
    print("Previous msg Date : ${prevMsgDate}");
    String currrent = DateFormat.yMMMMEEEEd().format(msgDate);
    String previous = DateFormat.yMMMMEEEEd().format(prevMsgDate);
    if (currrent == previous) {
      return false;
    }

    return true;
  }

  String ConvertTimeInto_AMPM_Format(DateTime time) {
    print("time type : ${time.runtimeType}");
    String msgDate = DateFormat.yMMMMEEEEd().format(time);
    String currentDate = DateFormat.yMMMMEEEEd().format(DateTime.now());
    DateTime prev = DateTime.now().subtract(Duration(days: 1));
    String prevDate = DateFormat.yMMMMEEEEd().format(prev);

    if (msgDate == currentDate)
      return "Today";
    else if (msgDate == prev)
      return "Yesterday";
    else {
      return DateFormat.yMMMd().format(time);
    }
  }

  void CheckMessageSentByWho(String senderId, String action) {
    String currentId=generalchatcontroller.auth.currentUser!.uid;
    if(currentId==senderId)
      {
        print("Senders msg ${action}");
        if(action=="add")
          generalchatcontroller.senderMsgCount.value++;
        else
          generalchatcontroller.senderMsgCount.value--;
      }
    else
      {
        print("Recievr Msg");
        if(action=="add")
          generalchatcontroller.recieverMsgCount.value++;
        else
          generalchatcontroller.recieverMsgCount.value--;
      }
  }

   CheckWhetherToStarOrUnStar(String currentId,List<dynamic> isStarred,String action) {
    print("Length : ${generalchatcontroller.selectedMsg.length}");
    print('Starred Count : ${generalchatcontroller.starredCount.value}');
    print("Unstarred COunt : ${generalchatcontroller.unstarredCount.value}");
    //print("Action prev : ${generalchatcontroller.action.value}");
    print("Action : ${action}");
    if(action=="add")
      {
        if(isStarred.contains(currentId))
          {
            generalchatcontroller.starredCount++;
          }
        else
          {
            generalchatcontroller.unstarredCount.value++;
          }
      }
    else
      {
        if(isStarred.contains(currentId))
        {
          generalchatcontroller.starredCount.value--;
        }
        else
        {
          generalchatcontroller.unstarredCount.value--;
        }
      }
  }

  void CheckIfThisMessageIsStarredByUser(dynamic msgId) {
    if(starred.contains(msgId))
      {
        generalchatcontroller.isStarredByThisUser.value=true;
      }
    else
      generalchatcontroller.isStarredByThisUser.value=false;
  }

  MediaType(String mediaUrl) {
    if(mediaUrl.contains('jpg') ||mediaUrl.contains('png') ||mediaUrl.contains('.jpeg'))
    {
      generalchatcontroller.mediaType.value="image";
      return "image";
    }
    else if(mediaUrl.contains('.doc') || mediaUrl.contains('.docx'))
      {
        generalchatcontroller.mediaType.value="document";
        return "document";
      }
    else if(mediaUrl.contains('.pdf'))
    {
      generalchatcontroller.mediaType.value="pdf";
    return "pdf";
    }
    else
      return "other";
  }
}
