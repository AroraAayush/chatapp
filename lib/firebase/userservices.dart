

import 'dart:io';

import 'package:chatwithaayushhhh/pages/home/models/usermodel.dart';
import 'package:chatwithaayushhhh/pages/profile/profilecontroller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class UserServices
{
  static FirebaseAuth auth=FirebaseAuth.instance;
  static GoogleSignIn googleSignIn=GoogleSignIn();
  static  ImagePicker imagePicker=ImagePicker();
  static FirebaseStorage storage=FirebaseStorage.instance;
  static final profileController=Get.put(ProfileController());
  static Future<bool> signupwithemailandpassword(Map<String,dynamic> userInfo) async
  {
    try{
      // print("Email : ${userInfo["email"]}");
      // print("Password : ${userInfo["password"]}");

      UserCredential? userCred=await auth.createUserWithEmailAndPassword(email: userInfo["email"], password: userInfo["password"]).then((UserCredential? userCreds){
     //   print("Authenticated user");
        final String id=userCreds!.user!.uid;
        List<String> lst=userInfo["username"].toString().split(" ");
        createUser({
          "id":id,
          "username": userInfo["username"],
          "email":userInfo["email"],
          "unreadMsgs":0,
          "activeStatus": false,
          "profileUrl":null,
          "starred_msgs" :[],
          "firstname": lst[0],
         "chatted_with":[]
        },
        id);
      });
      return true;
    }
    on FirebaseAuthException catch(e)
    {
return false;
    }
  }

  static void createUser(Map<String, dynamic> info,String id) async {
    // print("Id : ${id}");
    // print("INfo : ${info}");
    await FirebaseFirestore.instance.collection("users").doc(id).set(info);
  }


  static Future<bool> loginwithemailandpassword(Map<String,dynamic> userInfo) async
  {
    try{
      await auth.signInWithEmailAndPassword(email: userInfo["email"], password: userInfo["password"]);
      return true;
    }
    on FirebaseAuthException catch(e)
    {
      return false;
    }
  }

  static Stream<DocumentSnapshot> getUserDetails(String id)
  {
  //  print("Pringing dets of : ${id}");
    FirebaseFirestore.instance.collection("users").doc(id).get().then((tmp) {
      dynamic user=tmp.data();
    //  print("User from func : ${user}");
    } );
    return FirebaseFirestore.instance.collection("users").doc(id).snapshots();
  }

  static Stream<QuerySnapshot> getAllUsers()
  {
    return FirebaseFirestore.instance.collection("users").where("id",isNotEqualTo: auth.currentUser!.uid).snapshots();
  }

  static Future<bool> signupwithGoogle()async
  {
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn
        .signIn();

    if (googleSignInAccount != null) {
     // print("Google2");
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      try {
        UserCredential userCredential =
        await auth.signInWithCredential(credential);
        User? user = userCredential.user;
        bool chk=await CheckIfUserAlreadyExists(user!.uid);
        //print(chk);
        if(chk==false) {
          List<String> lst=user.displayName!.toString().split(" ");
          Map<String, dynamic> customerInfo = {
            "id": user.uid,
            "email": user.email,
            "username": user.displayName,
            "unreadMsgs":0,
            "activeStatus": false,
            "profileUrl":null,
            "starred_msgs" :[],
            "firstname": lst[0],
            "chatted_with":[]
          };

         createUser(customerInfo, user.uid);
        }
        return true;
      }
      on FirebaseAuthException catch (e) {
        return false;

      }
    }
    return false;
  }


  static Future<bool> CheckIfUserAlreadyExists(String uid) async
  {
    bool chk=false;

    await FirebaseFirestore.instance.collection("users").where("id",isEqualTo: uid).get().then((
        tmps) {
      //print("Tmp docs : ${tmps.docs.length}");
      if(tmps.docs.length==0)
        chk=false;
      else
        chk=true;
    });
    return chk;
  }

  static editUsername(String id,String editedUsername)async
  {
    await FirebaseFirestore.instance.collection("users").doc(id).update({"username":editedUsername});
  }

  static Future<String>  pickProfileImage(String source,String id) async {
    File? image;
    profileController.uploading.value=true;
  //  print("Uploading : ${profileController.uploading.value}");
    if(source=="camera")
    {
      final pickedFile=await imagePicker.pickImage(source: ImageSource.camera);
      if(pickedFile!=null)
      {
        image = File(pickedFile.path);
        String url=await uploadImage(id,image);
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
        String url=await uploadImage(id,image);
        if(url!="")
          return url;
        else
          return "";
      }
      return "";
    }
  }

  static Future<String> uploadImage(String id,File? image) async{
    print("Upload func");
    final filename="profile_${id}";
    final destination='profile/${filename}';
    try{
      final ref=storage.ref().child(destination);
      final uploaded=await ref.putFile(image!);
      //print("Uploaded");
      String url = await uploaded.ref.getDownloadURL();
    //  print("Url is ${url}");
      await FirebaseFirestore.instance.collection("users").doc(id).update({"profileUrl": url});
      profileController.uploading.value=false;
     // print("Uploading : ${profileController.uploading.value}");
      return url;
    }
    catch(e)
    {
      return "";
    }
  }
  static Stream<QuerySnapshot> getAllChattedUsers(List<dynamic> chatted)
  {
    return FirebaseFirestore.instance.collection("users").where("id",isNotEqualTo: auth.currentUser!.uid).where("chatted_with",arrayContains: auth.currentUser!.uid).snapshots();
  }

  static Stream<QuerySnapshot> getAllChattedChatRooms()
  {
    return FirebaseFirestore.instance.collection("chatrooms").where("members",arrayContains: auth.currentUser!.uid).orderBy("recent",descending: true).snapshots();
  }

static  updateActivityStatus(bool status,String id)async
{
  await FirebaseFirestore.instance.collection("users").doc(id).update({"activeStatus": status});
  print("Updated to ${status}");
}

static Future<UserModel> getUserDets(String id) async{
    late UserModel user;
    await FirebaseFirestore.instance.collection("users").doc(id).get().then((value)
    {
      user=UserModel.fromUser(value.data());
    });
    return user;
}

}


