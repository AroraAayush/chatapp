import 'dart:io';

import 'package:chatwithaayushhhh/pages/profile/profilecontroller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class GroupChatServices
{
  static FirebaseAuth auth=FirebaseAuth.instance;
  static  ImagePicker imagePicker=ImagePicker();
  static FirebaseStorage storage=FirebaseStorage.instance;
  static final profileController=Get.put(ProfileController());
  static createGroup(Map<String,dynamic> grpInfo) async
  {
    String grpId=FirebaseFirestore.instance.collection("groupchatrooms").doc().id;
    grpInfo["groupId"]=grpId;
    await FirebaseFirestore.instance.collection("groupchatrooms").doc(grpId).set(grpInfo);
    // grpId,grpmembers,admin,creationTime,recent,grpname,grpIcon,
  }

  static Stream<QuerySnapshot> getAllGroups(String id)
  {
    return FirebaseFirestore.instance.collection("groupchatrooms").where("members",arrayContains: id).orderBy("recent",descending: true).snapshots();
  }

  static Stream<DocumentSnapshot> getGroupDetails(String groupId)
  {
    return FirebaseFirestore.instance.collection("groupchatrooms").doc(groupId).snapshots();
  }

  static Stream<QuerySnapshot> getMessages(String groupId)
  {
    return FirebaseFirestore.instance.collection("groupchatrooms").doc(groupId).collection("messages").orderBy("time",descending: false).snapshots();
  }

  static Stream<QuerySnapshot> getMessagesDesc(String groupId)
  {
    return FirebaseFirestore.instance.collection("groupchatrooms").doc(groupId).collection("messages").orderBy("time",descending: true).snapshots();
  }


  static sendMessage(String groupId,String msgText,String media) async
  {
    print("Sending msg");
    await FirebaseFirestore.instance.collection("groupchatrooms").doc(groupId).collection("messages").add({
      "msgId" : "",
      "mediaUrl":media,
      "msgText": msgText,
      "isRead": [auth.currentUser!.uid],
      "isStarred" : [],
      "senderId" : auth.currentUser!.uid,
      "time" : DateTime.now(),
      "groupId" : groupId
    });

    await FirebaseFirestore.instance.collection("groupchatrooms").doc(groupId).update({"recent": DateTime.now()});
  }

  static addMembers(List<dynamic> selected,String groupId)async
  {
    await FirebaseFirestore.instance.collection("groupchatrooms").doc(groupId).update({"members": FieldValue.arrayUnion(selected)});
  }

  static Future<String>  pickGroupProfileImage(String source,String id) async {
    File? image;
    profileController.uploading.value=true;
    //  print("Uploading : ${profileController.uploading.value}");
    if(source=="camera")
    {
      final pickedFile=await imagePicker.pickImage(source: ImageSource.camera);
      if(pickedFile!=null)
      {
        image = File(pickedFile.path);
        String url=await uploadGroupProfileImage(id,image);
        if(url!="")
          return url;
        else
          return "";
      }
      return "";
    }
    else {
      ///  print("Source : Gallery");
      final pickedFile=await imagePicker.pickImage(source: ImageSource.gallery);
      if(pickedFile!=null)
      {
        image = File(pickedFile.path);
        // print("Uploading image");
        String url=await uploadGroupProfileImage(id,image);
        if(url!="")
          return url;
        else
          return "";
      }
      return "";
    }
  }

  static Future<String> uploadGroupProfileImage(String groupId,File? image) async{
    print("Upload func");
    final filename="groupProfile_${groupId}";
    final destination='groupProfile/${filename}';
    try{
      final ref=storage.ref().child(destination);
      final uploaded=await ref.putFile(image!);
      //print("Uploaded");
      String url = await uploaded.ref.getDownloadURL();
      //  print("Url is ${url}");
      await FirebaseFirestore.instance.collection("groupchatrooms").doc(groupId).update({"groupIcon": url});
      profileController.uploading.value=false;
      // print("Uploading : ${profileController.uploading.value}");
      return url;
    }
    catch(e)
    {
      return "";
    }
  }
}