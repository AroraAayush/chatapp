import 'package:chatwithaayushhhh/pages/home/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CommunityController extends GetxController
{
  FirebaseAuth auth=FirebaseAuth.instance;
  String currentId=FirebaseAuth.instance.currentUser!.uid;
  RxList selectedMembers=[].obs;
  RxString communityname="".obs;
  RxString communityProfile="".obs;
  RxString msgText="".obs;
  RxString mediaUrl="".obs;
  RxBool loading=false.obs;
  RxList selectedMsg=[].obs;
  RxBool isEditingMessage =false.obs;
  RxInt senderMsgCount=0.obs;
  RxInt recieverMsgCount=0.obs;
  RxString action="".obs;
  RxBool isStarredByThisUser=false.obs;
  RxInt starredCount=0.obs;
  RxInt unstarredCount=0.obs;
  RxList<dynamic> allUsers=[].obs;


  void resetAllGroupControllers()
  {
    selectedMembers.clear();
    communityname.value="";
    senderMsgCount.value=0;
    recieverMsgCount.value=0;
    selectedMsg.clear();
    action="".obs;
    selectedMsg.clear();
  }


  getAllUsers()async
  {
    allUsers.clear();
    await FirebaseFirestore.instance.collection("users").get().then((tmp){
      dynamic users=tmp.docs;
      for(dynamic tp in users)
      {
        UserModel user=UserModel.fromUser(tp.data());
        allUsers.add(user);
      }
    });
    print("All Users : ${allUsers}");
  }

  filterUsers(String institution,String dept)
  {

  }
}
