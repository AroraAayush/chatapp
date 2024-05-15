import 'package:chatwithaayushhhh/colors/appcolors.dart';
import 'package:chatwithaayushhhh/custom/customText.dart';
import 'package:chatwithaayushhhh/mediaqueries/media.dart';
import 'package:flutter/material.dart';
class CustomLeaveGroupButton extends StatelessWidget {
  final String text;
  final Color? buttonColor;
  final Function()? onPressed;
  final Color? buttonTextColor;
  const CustomLeaveGroupButton({super.key,required this.text,this.onPressed,this.buttonColor,this.buttonTextColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Utils.screenWidth(context)*0.85,
       height: Utils.screenHeight(context)*0.04,
        decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(20)
        ),
        child: Center(
          child: InkWell(
            onTap: onPressed,
            child: CustomText(
              text: text,
              color: buttonTextColor,
              fontSize: 16,
            ),),
        ));
  }
}
