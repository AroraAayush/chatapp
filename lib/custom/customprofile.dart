import 'package:flutter/material.dart';
import 'package:get/get.dart';
class CustomProfile extends StatelessWidget {
  final String? profileUrl;
  final String username;
  final double radius;
  final Color? color;
  final double? fontsize;
  final Color? textColor;
  const CustomProfile({super.key,required this.username,this.profileUrl,required this.radius,this.color, this.fontsize,this.textColor});

  @override
  Widget build(BuildContext context) {
    return profileUrl==null? CircleAvatar(
      backgroundColor: color?? Colors.white,
      child: Text("${username[0].capitalize}",style: TextStyle(
        fontSize: fontsize,
        color: textColor ?? Colors.black
      ),),
      radius: radius,
    ): CircleAvatar(
      backgroundImage: NetworkImage(profileUrl!),
      radius: radius,
    );
  }
}
