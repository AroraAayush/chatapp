import 'package:chatwithaayushhhh/colors/appcolors.dart';
import 'package:chatwithaayushhhh/mediaqueries/media.dart';
import 'package:chatwithaayushhhh/pages/groupchat/groupchatcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class CustomGroupNameTextField extends StatelessWidget {
  final TextEditingController controller;
  final String what;
  final Icon? prefixIcon;
  final IconData? suffixIcon;
  final String? Function(String?)? validator;
  final void Function()? suffixIconTapped;
  CustomGroupNameTextField({super.key,required this.controller, required this.what, this.prefixIcon, this.suffixIcon, this.validator, this.suffixIconTapped});

  final groupchatController=Get.put(GroupchatController());
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.only(left:Utils.screenWidth(context)*0.05,right: Utils.screenWidth(context)*0.05),
      child: Container(
        width: Utils.screenWidth(context)*0.8,
        height: Utils.screenHeight(context)*0.06,
        child:
        TextFormField(
          onChanged: (val)
          {
            groupchatController.grpname.value=val;
          },
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            suffixIcon: IconButton(
              onPressed: suffixIconTapped,
              icon:Icon(suffixIcon),
            ),
            fillColor: Colors.grey.withOpacity(0.06),
            filled: true,
            labelText: "${what}",
            hintText: "Enter your ${what}",
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide(
                    width: 1,
                    color: AppColors.black
                )
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide(
                    width: 1,
                    color: AppColors.black
                )
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide(
                  width: 1,
                  color: AppColors.black
              ),

            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide(
                  width: 1,
                  color: AppColors.black
              ),

            ),
          ),
        ),
      ),
    );
  }
}
