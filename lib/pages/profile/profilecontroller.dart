import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController
{
  RxBool isEditingUsername=false.obs;
  RxBool isEditingGroupname=false.obs;
  RxBool isEditingCommunityname=false.obs;
  FirebaseAuth auth=FirebaseAuth.instance;
  RxBool uploading=false.obs;
  RxList<dynamic> selectedMembers=[].obs;
}