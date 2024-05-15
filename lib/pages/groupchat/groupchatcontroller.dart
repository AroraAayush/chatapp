import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class GroupchatController extends GetxController
{
  FirebaseAuth auth=FirebaseAuth.instance;
  String currentId=FirebaseAuth.instance.currentUser!.uid;
  RxList selectedMembers=[].obs;
  RxString grpname="".obs;
  RxString grpProfile="".obs;
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


  void resetAllGroupControllers()
  {
    selectedMembers.clear();
    grpname.value="";
    senderMsgCount.value=0;
    recieverMsgCount.value=0;
    selectedMsg.clear();
    action="".obs;
    selectedMsg.clear();
  }
}