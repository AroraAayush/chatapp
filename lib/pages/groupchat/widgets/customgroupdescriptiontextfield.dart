import 'package:chatwithaayushhhh/colors/appcolors.dart';
import 'package:chatwithaayushhhh/mediaqueries/media.dart';
import 'package:flutter/material.dart';
class CustomGroupDescriptionTextField extends StatelessWidget {
  final TextEditingController controller;
  const CustomGroupDescriptionTextField({super.key,required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(left:Utils.screenWidth(context)*0.05,right: Utils.screenWidth(context)*0.05),
      child: Container(
        width: Utils.screenWidth(context)*0.8,
        child:
        TextFormField(
          controller: controller,
          minLines: 2,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top:15,left: 15),
            hintText: "Enter group description....",
            fillColor: Colors.grey.withOpacity(0.06),
            filled: true,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                    width: 1,
                    color: AppColors.black
                )
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                    width: 1,
                    color: AppColors.black
                )
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                  width: 1,
                  color: AppColors.black
              ),

            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
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
