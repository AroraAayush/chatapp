import 'package:chatwithaayushhhh/colors/appcolors.dart';
import 'package:chatwithaayushhhh/mediaqueries/media.dart';
import 'package:chatwithaayushhhh/pages/signup/signupcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class CustomTextField extends StatefulWidget {
  final String what;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Icon? prefixIcon;
  final IconData? suffixIcon;
  final void Function()? suffixIconTapped;
  final bool obscure;
  const CustomTextField({super.key,
    required this.controller,
  required this.what,
  this.validator,
  this.prefixIcon,
  this.suffixIcon,

  required this.obscure, this.suffixIconTapped});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final signupController=Get.put(SignUpController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(left:Utils.screenWidth(context)*0.05,right: Utils.screenWidth(context)*0.05),
      child: Container(
        width: Utils.screenWidth(context)*0.8,
        //height: Utils.screenHeight(context)*0.07,
        child:
        TextFormField(
          obscureText: widget.obscure,
        controller: widget.controller,
          validator: widget.validator,
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            suffixIcon: IconButton(
              onPressed: widget.suffixIconTapped,
              icon:Icon(widget.suffixIcon),
            ),
            fillColor: Colors.grey.withOpacity(0.06),
            filled: true,
            labelText: "${widget.what}",
            hintText: "Enter your ${widget.what}",
              focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                width: 1,
                color: AppColors.black
              )
          ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(
                    width: 1,
                    color: AppColors.black
                )
            ),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(
                    width: 1,
                    color: AppColors.black
                ),

            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
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
