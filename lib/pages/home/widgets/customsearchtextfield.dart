import 'package:chatwithaayushhhh/colors/appcolors.dart';
import 'package:chatwithaayushhhh/mediaqueries/media.dart';
import 'package:chatwithaayushhhh/pages/home/homeview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class CustomSearchTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  const CustomSearchTextField({super.key,
    required this.controller,
    this.validator});

  @override
  State<CustomSearchTextField> createState() => _CustomSearchTextFieldState();
}

class _CustomSearchTextFieldState extends State<CustomSearchTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Utils.screenWidth(context)*0.9,
      //height: Utils.screenHeight(context)*0.07,
      child: TextFormField(
        onChanged: (val){
          if(val=="")
            {
              homeController.filtered.value=false;
            }
          else
            {
              homeController.filtered.value=true;
            }
          print("filtered : ${homeController.filtered.value}");
          print("Changed : ${val}");
          homeController.filterUsers(val);

        },
        controller: widget.controller,
        validator: widget.validator,
        decoration: InputDecoration(

          contentPadding: EdgeInsets.only(top:2,left:15,right: 5,bottom: 2 ),
          fillColor: Colors.white.withOpacity(0.2),
          filled: true,
          hintText: "Enter to search...",
          suffixIcon: Icon(Icons.search),
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
