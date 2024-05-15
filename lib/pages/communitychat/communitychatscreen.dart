import 'package:chatwithaayushhhh/custom/customText.dart';
import 'package:chatwithaayushhhh/custom/customprofile.dart';
import 'package:chatwithaayushhhh/firebase/communitychatservices.dart';
import 'package:chatwithaayushhhh/firebase/userservices.dart';
import 'package:chatwithaayushhhh/mediaqueries/media.dart';
import 'package:chatwithaayushhhh/pages/communitychat/communitycontroller.dart';
import 'package:chatwithaayushhhh/pages/communitychat/models/communityModel.dart';
import 'package:chatwithaayushhhh/pages/communitychat/models/communitymessagemodel.dart';
import 'package:chatwithaayushhhh/pages/communitychat/widgets/communitymessagewidget.dart';
import 'package:chatwithaayushhhh/pages/communitychat/widgets/customcommunitymessagetextfield.dart';
import 'package:chatwithaayushhhh/pages/generalchat/widgets/custommessagetextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
class CommunityChatScreen extends StatefulWidget {
  final CommunityModel community;
  const CommunityChatScreen({super.key,required this.community});

  @override
  State<CommunityChatScreen> createState() => _CommunityChatScreenState();
}

class _CommunityChatScreenState extends State<CommunityChatScreen> {

  final scrollController=ScrollController();
  final communitychatcontroller=Get.put(CommunityController());
  final messageController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/communityProfileScreen',
                arguments: widget.community);
          },
          child: StreamBuilder(
            stream:CommunityChatServices.getCommunityDetails(widget.community.communityId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                CommunityModel communityy = CommunityModel.fromCommunity(snapshot.data);
                return Container(
                  child: Row(
                    children: [
                      CustomProfile(
                        username: communityy.communityname,
                        radius: 20,
                        profileUrl: communityy.communityIcon,
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
                              text: "${communityy.communityname.capitalize}",
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                            width: Utils.screenWidth(context)*0.45,
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context,index)
                                {
                                  dynamic member=communityy.members[index];
                                  return StreamBuilder(stream: UserServices.getUserDetails(member), builder: (context,snapshot)
                                  {
                                    if(snapshot.hasData)
                                    {
                                      dynamic user=snapshot.data;
                                      return CustomText(text: "${user["username"].toString().capitalize}",fontSize: 13,);
                                    }
                                    else
                                    {
                                      return SizedBox();
                                    }
                                  }
                                  );
                                }, separatorBuilder: (context,index){
                              return CustomText(text: " , ",fontSize: 13,);
                            }, itemCount: communityy.members.length),
                          )
                        ],
                      ),
                      Spacer(),
                      Obx((){
                        return  communitychatcontroller.selectedMsg.length>=1 ?Row(
                          children: [
                            communitychatcontroller.unstarredCount.value>0 ? InkWell(
                                onTap:()async{
                                  // await ChatServices.starMessages(generalchatcontroller.selectedMsg, generalchatcontroller.auth.currentUser!.uid,widget.args["roomId"]);
                                  // generalchatcontroller.resetAllControllers();
                                },
                                child: Icon(Icons.star)):InkWell(
                                onTap:()async{
                                  // await ChatServices.unstarMessages(generalchatcontroller.selectedMsg, generalchatcontroller.auth.currentUser!.uid,widget.args["roomId"]);
                                  // generalchatcontroller.resetAllControllers();
                                },
                                child: Icon(Icons.star_border)),
                            (communitychatcontroller.recieverMsgCount.value==0)?
                            InkWell(
                                onTap:()async{
                                  // await ChatServices.unstarMessages(generalchatcontroller.selectedMsg, generalchatcontroller.auth.currentUser!.uid, widget.args["roomId"]);
                                  // await ChatServices.deleteMessages(groupchatcontroller.selectedMsg,widget.args["roomId"]);
                                  // groupchatcontroller.resetAllControllers();
                                },
                                child: Icon(Icons.delete).paddingOnly(right: 2)) : SizedBox(),
                            (communitychatcontroller.selectedMsg.length==1 && communitychatcontroller.senderMsgCount.value==1)?
                            InkWell(
                                onTap: ()async{
                                  // Map<String,dynamic> selectedMsgInfo=await ChatServices.getMessageInfo(widget.args["roomId"],groupchatcontroller.selectedMsg[0]);
                                  // messageController.text=selectedMsgInfo["msgText"];
                                  // groupchatcontroller.msgText.value=messageController.text;
                                  // groupchatcontroller.isEditingMessage.value=true;
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
                      stream: CommunityChatServices.getMessages(widget.community.communityId),
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
                                // print("Starred : ${starred}");
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
                                    (index==0 || IfNewMessageSender(message["senderId"],msgs[index-1]["senderId"]))? IfMessageSentByYou(message["senderId"])?Align(
                                        alignment:Alignment.centerRight,
                                        child: CustomText(text: "You",fontSize: 15,fontWeight: FontWeight.w700,)).marginOnly(left: 5,right: 5,bottom: 3):
                                    StreamBuilder(stream: UserServices.getUserDetails(message["senderId"]),
                                        builder: (context,snapshot)
                                        {
                                          if(snapshot.hasData)
                                          {
                                            dynamic user=snapshot.data;
                                            return Align(
                                                alignment:message["senderId"]==communitychatcontroller.auth.currentUser!.uid?Alignment.centerRight:Alignment.centerLeft,
                                                child: CustomText(text: "${user["firstname"].toString().capitalize}",fontSize: 15,fontWeight: FontWeight.w700,)).marginOnly(left: 5,right: 5,bottom: 3);
                                          }
                                          else
                                          {
                                            return SizedBox();
                                          }
                                        }) : SizedBox(),
                                    Stack(
                                      children: [
                                        InkWell(
                                          onTap: () async{
                                            if (communitychatcontroller
                                                .selectedMsg.length >=
                                                1) {
                                              communitychatcontroller.selectedMsg
                                                  .add(msgId);
                                              CheckMessageSentByWho(message["senderId"],"add");
                                              //   UserModel currentUser=await UserServices.getUserDets(groupchatcontroller.auth.currentUser!.uid);
                                              await CheckWhetherToStarOrUnStar(communitychatcontroller.auth.currentUser!.uid,message["isStarred"],"add");

                                            }
                                          },
                                          onLongPress: () async{
                                            communitychatcontroller.selectedMsg
                                                .add(msgId);
                                            CheckMessageSentByWho(message["senderId"],"add");
                                            await CheckWhetherToStarOrUnStar(communitychatcontroller.auth.currentUser!.uid,message["isStarred"],"add");
                                          },
                                          child:
                                          Align(
                                            alignment:message["senderId"]==communitychatcontroller.auth.currentUser!.uid?Alignment.centerRight:Alignment.centerLeft,
                                            child: CommunityMessageWidget(
                                              msg: CommunityMessageModel.fromCommunityMessage(
                                                  msgs[index].data()),
                                              msgId: msgId,
                                              members: widget.community.members,
                                            ),
                                          )
                                          ,
                                        ),
                                        Obx(() {
                                          return communitychatcontroller.selectedMsg
                                              .contains(msgId)
                                              ? Positioned.fill(
                                            child: InkWell(
                                              onTap: ()async{
                                                if(communitychatcontroller.selectedMsg.length>=1)
                                                {
                                                  communitychatcontroller.selectedMsg.removeWhere((val) => msgId==val);
                                                  CheckMessageSentByWho(message["senderId"],"remove");
                                                  await CheckWhetherToStarOrUnStar(communitychatcontroller.auth.currentUser!.uid,message["isStarred"],"remove");
                                                }
                                              },
                                              child: Container(
                                                width: Utils.screenWidth(context),
                                                color: Colors.blue.withOpacity(0.4),
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
                                await CommunityChatServices.pickImage("camera");

                              },
                              leading: Icon(Icons.camera),
                              title: Text('Camera'),
                            ),
                            ListTile(
                              onTap: ()async{
                                Navigator.pop(context);
                                await CommunityChatServices.pickImage("gallery");

                              },
                              leading: Icon(Icons.camera_alt),
                              title: Text('Gallery'),
                            ),
                            ListTile(
                              onTap: ()async{
                                Navigator.pop(context);
                                await CommunityChatServices.pickDocument();
                                //await UserServices.pickFile("gallery", communitychatcontroller.auth.currentUser!.uid);

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
                CustomCommunityMessageTextField(
                  controller: messageController,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Obx(() {
                      return InkWell(
                          onTap: (communitychatcontroller.msgText.value == "" && communitychatcontroller.mediaUrl.value=="")
                              ? null
                              : () async {
                            String tmp=communitychatcontroller.msgText.value;
                            String tmp2=communitychatcontroller.mediaUrl.value;
                            communitychatcontroller.msgText.value = "";
                            communitychatcontroller.mediaUrl.value = "";
                            messageController.clear();
                            if(communitychatcontroller.isEditingMessage.value==true)
                            {
                              String msgId=communitychatcontroller.selectedMsg[0];
                              // await communityChatServices.editMessage(widget.args["roomId"],tmp,msgId);
                              communitychatcontroller.resetAllGroupControllers();
                            }
                            else {
                              await CommunityChatServices.sendMessage(
                                  widget.community.communityId,
                                  tmp,
                                  tmp2);
                            }

                          },
                          child: Icon(
                            Icons.send,
                            color: (communitychatcontroller.msgText.value== "" && communitychatcontroller.mediaUrl.value=="")
                                ? Colors.grey
                                : Colors.black,
                          ));
                    }))
              ])
            ],
          ).paddingOnly(bottom: 10),

            Obx((){
              return   communitychatcontroller.loading.value==true?
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
                      Text("Uploading Image"),
                    ],
                  ),
                ),
              ):SizedBox();
            }) ]
      ),
    );
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
    String currentId=communitychatcontroller.auth.currentUser!.uid;
    if(currentId==senderId)
    {
      print("Senders msg ${action}");
      if(action=="add")
        communitychatcontroller.senderMsgCount.value++;
      else
        communitychatcontroller.senderMsgCount.value--;
    }
    else
    {
      print("Recievr Msg");
      if(action=="add")
        communitychatcontroller.recieverMsgCount.value++;
      else
        communitychatcontroller.recieverMsgCount.value--;
    }
  }
  CheckWhetherToStarOrUnStar(String currentId,List<dynamic> isStarred,String action) {
    print("Length : ${communitychatcontroller.selectedMsg.length}");
    print('Starred Count : ${communitychatcontroller.starredCount.value}');
    print("Unstarred COunt : ${communitychatcontroller.unstarredCount.value}");
    //print("Action prev : ${communitychatcontroller.action.value}");
    print("Action : ${action}");
    if(action=="add")
    {
      if(isStarred.contains(currentId))
      {
        communitychatcontroller.starredCount++;
      }
      else
      {
        communitychatcontroller.unstarredCount.value++;
      }
    }
    else
    {
      if(isStarred.contains(currentId))
      {
        communitychatcontroller.starredCount.value--;
      }
      else
      {
        communitychatcontroller.unstarredCount.value--;
      }
    }
  }

  bool IfNewMessageSender(String currentId, String prevId) {
    if(currentId==prevId)
    {
      return false;
    }
    else
    {
      return true;
    }
  }

  bool IfMessageSentByYou(String senderId) {
    if(senderId==communitychatcontroller.auth.currentUser!.uid)
      return true;
    else
      return false;
  }


}