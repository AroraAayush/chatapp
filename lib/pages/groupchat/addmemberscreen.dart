import 'package:chatwithaayushhhh/colors/appcolors.dart';
import 'package:chatwithaayushhhh/custom/customText.dart';
import 'package:chatwithaayushhhh/custom/customprofile.dart';
import 'package:chatwithaayushhhh/firebase/userservices.dart';
import 'package:chatwithaayushhhh/pages/groupchat/groupchatcontroller.dart';
import 'package:chatwithaayushhhh/pages/home/models/usermodel.dart';
import 'package:chatwithaayushhhh/pages/home/widgets/customsearchtextfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final groupchatcontroller=Get.put(GroupchatController());
  final searchUserController=TextEditingController();

  @override
  void initState() {
    groupchatcontroller.selectedMembers.clear();

    super.initState();
  }

  @override
  void dispose() {
    FocusScope.of(context).unfocus();
    groupchatcontroller.selectedMembers.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text("Add Members Screen"),
      centerTitle: true,
      backgroundColor: AppColors.primary,
    ),
    floatingActionButton:  Obx((){
      return FloatingActionButton(
        backgroundColor: groupchatcontroller.selectedMembers.length==0? Colors.grey.withOpacity(0.3):Colors.green,
        onPressed: groupchatcontroller.selectedMembers.length==0?null:()async{
            await Navigator.pushNamed(context, '/creategroupscreen');
            //Navigator.pop(context);
        },
        child: Icon(Icons.navigate_next,color:  groupchatcontroller.selectedMembers.length==0?Colors.black:Colors.white,),
      );
    })
    ,
    body: Column(
      children: [
        Obx((){
          return groupchatcontroller.selectedMembers.length==0? SizedBox():
          SizedBox(
            height: 90,
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
                         return Stack(
                           children:[ Positioned(
                             child: Column(
                               children: [
                                 CustomProfile(username: user.username, radius:28 , profileUrl: user.profileUrl,fontsize: 16,color: Colors.green.withOpacity(0.5),),
                                 SizedBox(height: 6,),
                                 SizedBox(
                                     width: 90,
                                     child: Center(child: CustomText(text: "${user.firstname.capitalize}",fontSize: 16,maxLines: 1)))
                               ],
                             ),
                           ),
                             Positioned(
                                 right:10,

                                 child: InkWell(
                                   onTap:(){
                                     print("User id : ${user.id}");
                                     // print("Members : ${widget.members}");
                                     // print(widget.members.contains(user.id));
                                     updateSelectedMembers(user.id);
                                   },
                                   child: CircleAvatar(
                                     radius: 10,
                                       backgroundColor: Colors.red.withOpacity(0.7),
                                       child: Icon(Icons.delete_forever_outlined,size: 14,)),
                                 ))
                           ]
                         );
                      }
                    else
                      {
                        return SizedBox();
                      }
                  }
              );
            }),
          ).marginOnly(top: 20);
        }),
        Obx((){
          return groupchatcontroller.selectedMembers.length==0?SizedBox():  Divider(height: 10,);
        })
      ,
        CustomSearchTextField(controller: searchUserController).marginOnly(bottom: 10,top: 15),
        Expanded(
          child: StreamBuilder(stream: UserServices.getAllUsers(),
          builder: (context,snapshot)
            {
              if(snapshot.hasData)
                {
                  dynamic users=snapshot.data!.docs;
                  return ListView.separated(
                    separatorBuilder: (context,index)
                      {
                        return SizedBox(height: 5,);
                      },
                      itemCount: users.length,
                      itemBuilder: (context,index){
                        UserModel user= UserModel.fromUser(users[index].data());
                    return
                      Obx((){
                        return  Container(
                          margin: EdgeInsets.only(left: 5,right: 5),
                          padding: EdgeInsets.only(top: 4,bottom: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            color: groupchatcontroller.selectedMembers.contains(user.id)?Colors.grey.withOpacity(0.2):Colors.transparent,

                          ),
                                                    child: ListTile(
                            onTap: groupchatcontroller.selectedMembers.contains(user.id)? null :(){
                              updateSelectedMembers(user.id);
                             // print("members now : ${widget.members}");
                              // Navigator.pushNamed(context, '/generalchatscreen',arguments: {
                              //   "roomId": roomId,
                              //   "members": chatrooms[index]["members"],
                              //   "recId": recId,
                              //   "chatted" :rec.chatted_with,
                              //   "reciever" : rec
                              // });
                            },
                            leading: CustomProfile(username: user.username,radius: 24,profileUrl: user.profileUrl,color: groupchatcontroller.selectedMembers.contains(user.id)?Colors.grey.withOpacity(0.4):Colors.green.withOpacity(0.5),textColor: Colors.black,),
                            title: CustomText(
                              text: "${user.firstname.toString().capitalize}",
                              fontSize: 16,
                            ),

                          ),
                        );
                      });

                  });
                }
              else
                {
                  return SizedBox();
                }
            },),
        ),
      ],
    )
    );
  }

  updateSelectedMembers(String id) {
    if(groupchatcontroller.selectedMembers.contains(id))
      {
        groupchatcontroller.selectedMembers.remove(id);
      }
    else
      groupchatcontroller.selectedMembers.add(id);
  }
}
