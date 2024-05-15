import 'dart:io';

import 'package:chatwithaayushhhh/pages/generalchat/generalchatcontroller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChatServices
{
  static FirebaseAuth auth=FirebaseAuth.instance;
  static  ImagePicker imagePicker=ImagePicker();
  static FirebaseStorage storage=FirebaseStorage.instance;
  static final generalchatcontroller=Get.put(GeneralChatController());
  static Stream<DocumentSnapshot> getUserDets(String uid)
  {
    return FirebaseFirestore.instance.collection("users").doc(uid).snapshots();
  }


  static sendMessage(String roomId,String msgText,String media,String recId) async
  {
    print("Sending msg");
    await FirebaseFirestore.instance.collection("chatrooms").doc(roomId).collection("messages").add({
      "msgId" : "",
      "mediaUrl":media,
      "msgText": msgText,
      "isRead": false,
      "isStarred" : [],
      "recieverId" : recId,
      "senderId" : auth.currentUser!.uid,
      "time" : DateTime.now(),
      "roomId" : roomId
    });


    await FirebaseFirestore.instance.collection("chatrooms").doc(roomId).update({"recent": DateTime.now()});
  }

  static createRoom(String roomId,List<String> members) async
  {
    print("Creating room");
    await FirebaseFirestore.instance.collection("chatrooms").doc(roomId).set({
      "roomId":roomId,
      "recent": DateTime.now(),
      "members" : members,
      "typing" : []
    });
  }

  static updateChattedWith(List<String> members)async
  {
    await FirebaseFirestore.instance.collection("users").doc(members[0]).update({"chatted_with":FieldValue.arrayUnion([members[1]])});
    await FirebaseFirestore.instance.collection("users").doc(members[1]).update({"chatted_with":FieldValue.arrayUnion([members[0]])});
  }

  static Stream<QuerySnapshot> getMessages(String roomId)
  {
    return FirebaseFirestore.instance.collection("chatrooms").doc(roomId).collection("messages").orderBy("time",descending: false).snapshots();
  }

  static Stream<QuerySnapshot> getMessagesDescending(String roomId)
  {
    return FirebaseFirestore.instance.collection("chatrooms").doc(roomId).collection("messages").orderBy("time",descending: true).snapshots();
  }

  static editMessage(String roomId,String editedUsername,String msgId)async
  {
    await FirebaseFirestore.instance.collection("chatrooms").doc(roomId).collection("messages").doc(msgId).update({"msgText": editedUsername});
  }

  static Future<Map<String,dynamic>> getMessageInfo(String roomId,String msgId) async
  {
    Map<String,dynamic> msg={};
    await FirebaseFirestore.instance.collection("chatrooms").doc(roomId).collection("messages").doc(msgId).get().then((tmp){
      msg=tmp.data()!;
    });
    return msg;
  }

  static starMessages(List<dynamic> selected,String userId,String roomId)async
  {
    List<Map<String,dynamic>> lstt=[];
   for(dynamic msgId in selected)
     {
       lstt.add({
         "type": "general",
         "roomId" :roomId,
         "msgId": msgId
       });
       await FirebaseFirestore.instance.collection("chatrooms").doc(roomId).collection("messages").doc(msgId).update({"isStarred":FieldValue.arrayUnion([userId])});
     }
   await FirebaseFirestore.instance.collection("users").doc(userId).update({"starred_msgs": FieldValue.arrayUnion(lstt)});


  }

  static unstarMessages(List<dynamic> selected,String userId,String roomId)async
  {List<Map<String,dynamic>> lstt=[];
    for(dynamic msgId in selected)
    {
      lstt.add({
        "type": "general",
        "roomId" :roomId,
        "msgId": msgId
      });
      await FirebaseFirestore.instance.collection("chatrooms").doc(roomId).collection("messages").doc(msgId).update({"isStarred":FieldValue.arrayRemove([userId])});
    }
  await FirebaseFirestore.instance.collection("users").doc(userId).update({"starred_msgs": FieldValue.arrayRemove(lstt)});

  }

  static deleteMessages(List<dynamic> selected,String roomId)async
  {
    for(dynamic msgId in selected)
      {
        await FirebaseFirestore.instance.collection("chatrooms").doc(roomId).collection("messages").doc(msgId).delete();
      }
  }

  static updateIsRead(String msgId,String roomId)async
  {
    await FirebaseFirestore.instance.collection("chatrooms").doc(roomId).collection("messages").doc(msgId).update({"isRead":true});
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
        generalchatcontroller.loading.value=true;
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
        generalchatcontroller.loading.value=true;
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
        generalchatcontroller.mediaUrl.value=url;
      generalchatcontroller.loading.value=false;
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
      generalchatcontroller.loading.value=true;
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
    final destination='documents/${fileName}';
    print("FIlename : ${fileName}");
    try{
     final ref=storage.ref().child(destination);
     final uploaded=await ref.putFile(file!);
      print("Uploaded");
     String url = await uploaded.ref.getDownloadURL();
     print("Url is ${url}");
      generalchatcontroller.mediaUrl.value=url;
     generalchatcontroller.loading.value=false;
      //await FirebaseFirestore.instance.collection("chatrooms").doc(roomId).collection("messages").doc(msgId).update({"mediaUrl": url});

      return url;
    }
    catch(e)
    {
      return "";
    }
  }

  static Stream<DocumentSnapshot> getMessageDetails(String msgId,String roomId)
  {
    return  FirebaseFirestore.instance.collection("chatrooms").doc(roomId).collection("messages").doc(msgId).snapshots();
  }

}