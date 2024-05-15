import 'package:chatwithaayushhhh/firebase/communitychatservices.dart';
import 'package:chatwithaayushhhh/mediaqueries/media.dart';
import 'package:chatwithaayushhhh/pages/communitychat/communitycontroller.dart';
import 'package:chatwithaayushhhh/pages/communitychat/widgets/customcommunitynametextfield.dart';
import 'package:chatwithaayushhhh/pages/signup/widgets/customsubmitbutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class CreateCommunityScreen extends StatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  State<CreateCommunityScreen> createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends State<CreateCommunityScreen> {
  final communitynameController=TextEditingController();
  final communityController=Get.put(CommunityController());

  @override
  void initState() {
    communityController.getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Create New Community"),
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
                    child: Icon(Icons.groups,size: 50,),radius: 70,),
                ),
                  Positioned(
                      right: 4,
                      top: 100,
                      child: InkWell(
                          onTap: (){

                          },
                          child: CircleAvatar(radius: 15,backgroundColor: Colors.white,child: Icon(Icons.add_circle,size: 28,),)))


                ]
            ),
            CustomCommunityNameTextField(controller: communitynameController, what: "Community Name",prefixIcon: Icon(Icons.groups),validator: (value) {
              return communitynameValidator(
                  value);
            },).marginOnly(top:25,bottom: 20),
          //  CustomGroupDescriptionTextField(controller: groupdescController),
            Divider(
              height: 30,
            ),

            Spacer(),
            Obx((){
              return CustomSubmitButton(text: "Create new community",buttonColor: communityController.communityname.value==""?Colors.grey.withOpacity(0.3):Colors.green,buttonTextColor: Colors.white,
                onPressed:communityController.communityname.value==""? null: ()async{
                  communityController.selectedMembers.add(communityController.currentId);
                  DateTime time=DateTime.now();
                  await CommunityChatServices.createCommunity({
                    "communityname" : communitynameController.text,
                    "communityIcon" : null,
                    "members" : communityController.selectedMembers.value,
                    "admin" : [communityController.currentId],
                    "creationTime" :time,
                    "recent": time,
                  });
                  Navigator.pop(context);
                  communityController.resetAllGroupControllers();
                  communitynameController.clear();
                },).marginOnly(bottom: 10);

            })
          ],
        ),
      ).marginOnly(top:30),
    );
  }
}

String? communitynameValidator(String? username)
{
  if(username!.length==0)
  {
    return "Username can't be empty";
  }
}