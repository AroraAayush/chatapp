class GroupModel
{
  final String groupname;
  final String groupId;
  final String? groupIcon;
  final List<dynamic> members;
  final DateTime creationTime;
  final DateTime recent;
  final List<dynamic> admin;


  factory GroupModel.fromGroup(dynamic infoMap) {
    print("Infomap : ${infoMap}");
    return GroupModel(
        groupname: infoMap["groupname"],
        groupId: infoMap["groupId"],
        groupIcon: infoMap["groupIcon"],
        members: infoMap["members"],
        creationTime: infoMap["creationTime"].toDate(),
        recent: infoMap["recent"].toDate(),
        admin: infoMap["admin"]

    );
  }

  GroupModel({required this.groupname, required this.groupId, required this.groupIcon, required this.members, required this.creationTime, required this.recent, required this.admin});



}

