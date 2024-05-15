import 'package:chatwithaayushhhh/colors/appcolors.dart';
import 'package:chatwithaayushhhh/mediaqueries/media.dart';
import 'package:chatwithaayushhhh/pages/communitychat/communitycontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomCommunityMessageTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  CustomCommunityMessageTextField({super.key,
    required this.controller,
    this.validator});

  final communitychatcontroller=Get.put(CommunityController());
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Utils.screenWidth(context)*0.8,
      //height: Utils.screenHeight(context)*0.07,
      child: TextFormField(
        // keyboardType: TextInputType.multiline,
        // maxLines: null,
        controller: controller,
        validator: validator,
        onChanged: (val){
          communitychatcontroller.msgText.value=val;
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top:2,left:15,right: 5,bottom: 2 ),
          fillColor: Colors.white.withOpacity(0.2),
          filled: true,
          hintText: "Type a message...",
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                  width: 1,
                  color: AppColors.black
              )
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                  width: 1,
                  color: AppColors.black
              )
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
                width: 1,
                color: AppColors.black
            ),

          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
                width: 1,
                color: AppColors.black
            ),

          ),
        ),
      ),
    );
  }
}
