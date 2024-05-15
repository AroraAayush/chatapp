class CommunityMessageModel
{
  final String msgId;
  final String msgText;
  final String mediaUrl;
  final List<dynamic> isRead;
  final List<dynamic> isStarred;
  final String senderId;
  final DateTime time;
  final String communityId;


  factory CommunityMessageModel.fromCommunityMessage(dynamic infoMap) {
    //print("Message : ${infoMap}");
    return CommunityMessageModel(
        msgId: infoMap["msgId"],
        msgText: infoMap["msgText"],
        mediaUrl: infoMap["mediaUrl"],
        isRead : infoMap["isRead"],
        isStarred : infoMap["isStarred"],
        senderId : infoMap["senderId"],
        time : infoMap["time"].toDate(),
        communityId: infoMap["communityId"]

    );
  }

  CommunityMessageModel({ required this.communityId,required this.msgId,required this.msgText, required this.mediaUrl, required this.isRead, required this.isStarred,required this.senderId, required this.time});



// UserModel copyWith({String? id, String? profileUrl,String? username, String? email , String? firstname,List<dynamic>? chatted_with,bool? activeStatus,int? unreadMsgs,List<dynamic>? starred_msgs})
// {
//   return UserModel(username: username ?? this.username, email: email ?? this.email, profileUrl: profileUrl ?? this.profileUrl, id: id ?? this.id,firstname: firstname ?? this.firstname,unreadMsgs: unreadMsgs ?? this.unreadMsgs,starred_msgs: starred_msgs ?? this.starred_msgs,activeStatus: activeStatus ?? this.activeStatus,chatted_with: chatted_with ?? this.chatted_with);
// }

}

