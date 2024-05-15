import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class GeneralChatController extends GetxController
{
  FirebaseAuth auth=FirebaseAuth.instance;
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
  RxString mediaType="".obs;

  void resetAllControllers()
  {
    senderMsgCount.value=0;
    recieverMsgCount.value=0;
    selectedMsg.clear();
    action="".obs;
    selectedMsg.clear();
  }
}