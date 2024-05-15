class UserModel
{
  final String id;
  final String username;
  final String firstname;
  final List<dynamic> chatted_with;
  final String email;
  final String? profileUrl;
  final bool activeStatus;
  final int unreadMsgs;
  final List<dynamic> starred_msgs;


  factory UserModel.fromUser(dynamic infoMap) {
    print("Infomap : ${infoMap}");
    return UserModel(
      firstname: infoMap["firstname"],
        email: infoMap["email"],
        username: infoMap["username"],
        id: infoMap["id"],
        profileUrl: infoMap["profileUrl"],
      chatted_with: infoMap["chatted_with"],
      activeStatus: infoMap["activeStatus"],
      unreadMsgs: infoMap["unreadMsgs"],
      starred_msgs: infoMap["starred_msgs"]


    );
  }

  UserModel({required this.id, required this.username, required this.firstname, required this.chatted_with, required this.email, required this.profileUrl, required this.activeStatus, required this.unreadMsgs, required this.starred_msgs});

  UserModel copyWith({String? id, String? profileUrl,String? username, String? email , String? firstname,List<dynamic>? chatted_with,bool? activeStatus,int? unreadMsgs,List<dynamic>? starred_msgs})
  {
    return UserModel(username: username ?? this.username, email: email ?? this.email, profileUrl: profileUrl ?? this.profileUrl, id: id ?? this.id,firstname: firstname ?? this.firstname,unreadMsgs: unreadMsgs ?? this.unreadMsgs,starred_msgs: starred_msgs ?? this.starred_msgs,activeStatus: activeStatus ?? this.activeStatus,chatted_with: chatted_with ?? this.chatted_with);
  }

}

