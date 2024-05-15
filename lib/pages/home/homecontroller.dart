import 'package:chatwithaayushhhh/pages/home/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeController extends GetxController
{
  FirebaseAuth auth=FirebaseAuth.instance;
  String userId=FirebaseAuth.instance.currentUser!.uid;
  RxBool filtered=false.obs;
  RxList filteredUsers=[].obs;
  RxList allUsers=[].obs;
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
  filterUsers(String search)
  {
    filteredUsers.clear();
    print("All Users length : ${allUsers.length}");
    search=search.toLowerCase();
    for(UserModel user in allUsers)
      {
        if((user.firstname.toLowerCase().contains(search) || user.username.toLowerCase().contains(search)) && FirebaseAuth.instance.currentUser!.uid !=user.id)
          {
            filteredUsers.add(user.id);
          }
      }
    print("Filtered Users length : ${filteredUsers.length}");
  }
}