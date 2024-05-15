class MessageModel
{
  final String msgId;
  final String msgText;
  final String mediaUrl;
  final bool isRead;
  final List<dynamic> isStarred;
  final String recId;
  final String senderId;
  final DateTime time;
  final String roomId;


  factory MessageModel.fromMessage(dynamic infoMap) {
    //print("Message : ${infoMap}");
    return MessageModel(
        msgId: infoMap["msgId"],
          msgText: infoMap["msgText"],
          mediaUrl: infoMap["mediaUrl"],
          isRead : infoMap["isRead"],
          isStarred : infoMap["isStarred"],
          recId : infoMap["recieverId"],
          senderId : infoMap["senderId"],
          time : infoMap["time"].toDate(),
      roomId: infoMap["roomId"]

    );
  }

  MessageModel({ required this.roomId,required this.msgId,required this.msgText, required this.mediaUrl, required this.isRead, required this.isStarred, required this.recId, required this.senderId, required this.time});



  // UserModel copyWith({String? id, String? profileUrl,String? username, String? email , String? firstname,List<dynamic>? chatted_with,bool? activeStatus,int? unreadMsgs,List<dynamic>? starred_msgs})
  // {
  //   return UserModel(username: username ?? this.username, email: email ?? this.email, profileUrl: profileUrl ?? this.profileUrl, id: id ?? this.id,firstname: firstname ?? this.firstname,unreadMsgs: unreadMsgs ?? this.unreadMsgs,starred_msgs: starred_msgs ?? this.starred_msgs,activeStatus: activeStatus ?? this.activeStatus,chatted_with: chatted_with ?? this.chatted_with);
  // }

}

