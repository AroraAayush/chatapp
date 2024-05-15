import 'dart:io';

import 'package:chatwithaayushhhh/pages/communitychat/communitycontroller.dart';
import 'package:chatwithaayushhhh/pages/profile/profilecontroller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CommunityChatServices
{
  static  ImagePicker imagePicker=ImagePicker();
  static FirebaseStorage storage=FirebaseStorage.instance;
  static final profileController=Get.put(ProfileController());
  static final communitycontroller=Get.put(CommunityController());
  static FirebaseAuth auth=FirebaseAuth.instance;
  static createCommunity(Map<String,dynamic> communityInfo) async
  {
    String communityId=FirebaseFirestore.instance.collection("communities").doc().id;
    communityInfo["communityId"]=communityId;
    await FirebaseFirestore.instance.collection("communities").doc(communityId).set(communityInfo);
    // grpId,grpmembers,admin,creationTime,recent,grpname,grpIcon,
  }

  static Stream<QuerySnapshot> getAllCommunities(String id)
  {
    return FirebaseFirestore.instance.collection("communities").where("members",arrayContains: id).orderBy("recent",descending: true).snapshots();
  }

  static Stream<QuerySnapshot> getMessages(String communityId)
  {
    return FirebaseFirestore.instance.collection("communities").doc(communityId).collection("messages").orderBy("time",descending: false).snapshots();
  }

  static Stream<QuerySnapshot> getMessagesDesc(String communityId)
  {
    return FirebaseFirestore.instance.collection("communities").doc(communityId).collection("messages").orderBy("time",descending: true).snapshots();
  }

  static Stream<DocumentSnapshot> getCommunityDetails(String communityId)
  {
    return FirebaseFirestore.instance.collection("communities").doc(communityId).snapshots();
  }

  static Future<String>  pickCommunityProfileImage(String source,String id) async {
    File? image;
    profileController.uploading.value=true;
    //  print("Uploading : ${profileController.uploading.value}");
    if(source=="camera")
    {
      final pickedFile=await imagePicker.pickImage(source: ImageSource.camera);
      if(pickedFile!=null)
      {
        image = File(pickedFile.path);
        String url=await uploadCommunityProfileImage(id,image);
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
        String url=await uploadCommunityProfileImage(id,image);
        if(url!="")
          return url;
        else
          return "";
      }
      return "";
    }
  }

  static Future<String> uploadCommunityProfileImage(String groupId,File? image) async{
    print("Upload func");
    final filename="communityProfile_${groupId}";
    final destination='communityProfile/${filename}';
    try{
      final ref=storage.ref().child(destination);
      final uploaded=await ref.putFile(image!);
      //print("Uploaded");
      String url = await uploaded.ref.getDownloadURL();
      //  print("Url is ${url}");
      await FirebaseFirestore.instance.collection("communities").doc(groupId).update({"communityIcon": url});
      profileController.uploading.value=false;
      // print("Uploading : ${profileController.uploading.value}");
      return url;
    }
    catch(e)
    {
      return "";
    }
  }

  static sendMessage(String communityId,String msgText,String media) async
  {
    print("Sending msg");
    await FirebaseFirestore.instance.collection("communites").doc(communityId).collection("messages").add({
      "msgId" : "",
      "mediaUrl":media,
      "msgText": msgText,
      "isRead": [auth.currentUser!.uid],
      "isStarred" : [],
      "senderId" : auth.currentUser!.uid,
      "time" : DateTime.now(),
      "communityId" : communityId
    });

  }



  static Future<String>  pickImage(String source) async {
    File? image;

    //  print("Uploading : ${profileController.uploading.value}");
    if(source=="camera")
    {
      final pickedFile=await imagePicker.pickImage(source: ImageSource.camera);
      if(pickedFile!=null)
      {
        image = File(pickedFile.path);
        communitycontroller.loading.value=true;
        String url=await uploadImage(image);

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
        communitycontroller.loading.value=true;
        // print("Uploading image");
        String url=await uploadImage(image);
        if(url!="")
          return url;
        else
          return "";
      }
      return "";
    }
  }

  static Future<String> uploadImage(File? image) async{
    print("Uploading");
    String fileName = image!.path.split('/').last;
    final destination='images/${fileName}';
    print("FIlename : ${fileName}");
    try{
      final ref=storage.ref().child(destination);
      final uploaded=await ref.putFile(image!);
      //print("Uploaded");
      String url = await uploaded.ref.getDownloadURL();
      print("Url is ${url}");
      communitycontroller.mediaUrl.value=url;
      communitycontroller.loading.value=false;
      // await FirebaseFirestore.instance.collection("chatrooms").doc(roomId).collection("messages").doc(msgId).update({"mediaUrl": url});
      //  profileController.uploading.value=false;
      // print("Uploading : ${profileController.uploading.value}");
      return url;
    }
    catch(e)
    {
      return "";
    }
  }

  static Future<String> pickDocument()async
  {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowedExtensions: ['doc','docx','pdf'],type: FileType.custom);

    if (result != null) {
      print("Result : ${result}");
      File file = File(result.files.single.path!);
      print("picked doc");
      communitycontroller.loading.value=true;
      String url=await uploadDocument(file);
      return url;
    } else {
      print("No file selected");
      return "";
    }
  }
  static Future<String> uploadDocument(File? file) async{
    print("Uploading");
    String fileName = file!.path.split('/').last;
    String destination;
    if(fileName.contains('.jpg') || fileName.contains('.png') || fileName.contains('.jpeg'))
      destination='images/${fileName}';
    else
     destination='documents/${fileName}';
    print("FIlename : ${fileName}");
    try{
      final ref=storage.ref().child(destination);
      final uploaded=await ref.putFile(file!);
      print("Uploaded");
      String url = await uploaded.ref.getDownloadURL();
      print("Url is ${url}");
      communitycontroller.mediaUrl.value=url;
      communitycontroller.loading.value=false;
      //await FirebaseFirestore.instance.collection("chatrooms").doc(roomId).collection("messages").doc(msgId).update({"mediaUrl": url});

      return url;
    }
    catch(e)
    {
      return "";
    }
  }


}