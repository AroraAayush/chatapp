import 'package:chatwithaayushhhh/firebase/chatservices.dart';
import 'package:chatwithaayushhhh/firebase/userservices.dart';
import 'package:chatwithaayushhhh/pages/generalchat/models/messageModel.dart';
import 'package:chatwithaayushhhh/pages/generalchat/widgets/messagewidget.dart';
import 'package:chatwithaayushhhh/pages/home/models/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class StarredMessageScreen extends StatefulWidget {
  const StarredMessageScreen({super.key});

  @override
  State<StarredMessageScreen> createState() => _StarredMessageScreenState();
}

class _StarredMessageScreenState extends State<StarredMessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text("Starred Message Screen"),
      centerTitle: true,
      backgroundColor: Colors.green,
    ),
    body: StreamBuilder(
      stream: UserServices.getUserDetails(FirebaseAuth.instance.currentUser!.uid),
      builder: (context,snapshot)
      {
        if(snapshot.hasData)
          {
            UserModel user=UserModel.fromUser(snapshot.data!.data());
            dynamic starred=user.starred_msgs;
            return ListView.separated(itemBuilder: (context,index)
                {
                  dynamic msg=starred[index];
                  return msg["type"]=="general"?
                  StreamBuilder(stream: ChatServices.getMessageDetails(msg["msgId"],msg["roomId"]),
                      builder: (context,snapshot)
                      {
                        if(snapshot.hasData)
                          {
                            MessageModel message=MessageModel.fromMessage(snapshot.data);
                            return Align(
                                alignment: message.senderId==FirebaseAuth.instance.currentUser!.uid?Alignment.centerRight:Alignment.centerLeft,
                                child: MessageWidget(msg: message, msgId: msg["msgId"]));
                          }
                        else
                          {
                            return SizedBox();
                          }
                      }
                  ) :SizedBox();
                }, separatorBuilder: (context,index){
              return SizedBox(
                height: 5,
              );
            }, itemCount: starred.length);
          }
        else
          {
            return SizedBox();
          }
      },
    ),
    );
  }
}
