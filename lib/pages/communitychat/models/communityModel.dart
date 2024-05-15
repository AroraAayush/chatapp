class CommunityModel
{
  final String communityname;
  final String communityId;
  final String? communityIcon;
  final List<dynamic> members;
  final DateTime creationTime;
  final DateTime recent;
  final List<dynamic> admin;


  factory CommunityModel.fromCommunity(dynamic infoMap) {
    print("Infomap : ${infoMap}");
    return CommunityModel(
        communityname: infoMap["communityname"],
        communityId: infoMap["communityId"],
        communityIcon: infoMap["communityIcon"],
        members: infoMap["members"],
        creationTime: infoMap["creationTime"].toDate(),
        recent: infoMap["recent"].toDate(),
        admin: infoMap["admin"]

    );
  }

  CommunityModel({required this.communityname, required this.communityId, required this.communityIcon, required this.members, required this.creationTime, required this.recent, required this.admin});



}

