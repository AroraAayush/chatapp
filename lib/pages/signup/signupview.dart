import 'package:chatwithaayushhhh/colors/appcolors.dart';
import 'package:chatwithaayushhhh/custom/customText.dart';
import 'package:chatwithaayushhhh/firebase/userservices.dart';
import 'package:chatwithaayushhhh/mediaqueries/media.dart';
import 'package:chatwithaayushhhh/pages/signup/signupcontroller.dart';
import 'package:chatwithaayushhhh/pages/signup/validators.dart';
import 'package:chatwithaayushhhh/pages/signup/widgets/customsubmitbutton.dart';
import 'package:chatwithaayushhhh/pages/signup/widgets/customtextfield.dart';
import 'package:chatwithaayushhhh/pages/signup/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.clear();
    passwordController.clear();
    confirmpasswordController.clear();
    usernameController.clear();
    super.dispose();
  }

  final signupController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: Utils.screenHeight(context) * 0.1,
                      bottom: Utils.screenHeight(context) * 0.03),
                  child: CustomText(text: 'Register Now',
                      fontSize: 26,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black),
                ),
                CustomTextField(controller: emailController,
                    obscure: false,
                    what: "Email",
                    prefixIcon: Icon(Icons.email),
                    validator: (value) {
                      return Validators.emailValidator(value);
                    }),
                SizedBox(height: 15,),
                CustomTextField(controller: usernameController,
                    obscure: false,
                    what: "Username",
                    prefixIcon: Icon(Icons.verified_user),
                    validator: (value) {
                      return Validators.usernameValidator(value);
                    }),
                SizedBox(height: 15,),
                Obx((){
                  return   CustomTextField(
                    controller: passwordController,
                    obscure: signupController.hidePass.value,
                    what: "Password",
                    prefixIcon: Icon(Icons.password),
                    suffixIcon: signupController.hidePass.value==true?Icons.visibility: Icons.visibility_off,
                    suffixIconTapped: signupController.togglePass,
                    validator: (value) {
                      return Validators.passwordValidator(value);
                    },
                  );
                }),
                SizedBox(height: 15,),
                Obx((){
                  return CustomTextField(controller: confirmpasswordController,
                      obscure: signupController.hideConfirmPass.value,
                      prefixIcon: Icon(Icons.password),
                      // suffixIcon: Icon(Icons.visibility),
                      what: "Confirm Password",
                      suffixIcon: signupController.hideConfirmPass.value==true?Icons.visibility: Icons.visibility_off,
                      suffixIconTapped: signupController.toggleConfirmPass,
                      validator: (value) {
                        return Validators.confirmpasswordValidator(
                            value, passwordController.text);
                      });
                })

                ,
                SizedBox(height: 25,),
                CustomSubmitButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      print("Validated");
                      bool res = await UserServices.signupwithemailandpassword(
                          {"email": emailController.text,
                            "username": usernameController.text,
                            "password": passwordController.text});
                      if (res == true) {
                        CustomSnackbar.showCustomSnackbar(
                            context, "Successfully Created an Account !!");
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/homeview', (route) => false);
                      }
                      else {
                        CustomSnackbar.showCustomSnackbar(
                            context, "Cannot create an account !!");
                      }
                    }
                  },
                  text: "Sign Up",
                  buttonTextColor: Colors.white,
                  buttonColor: Colors.green,
                ),
                SizedBox(height: 15,),
                Container(
                  width: Utils.screenWidth(context) * 0.8,
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(text: "Already a User ? ", fontSize: 15,),
                      InkWell(child: CustomText(
                        text: "Login", fontSize: 15, color: Colors.blue,),
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(context,
                              '/loginview', (route) => false);
                        },)
                    ],
                  ),
                ),
                Container(
                  width: Utils.screenWidth(context) * 0.8,
                  child: Divider(
                    height: 30,
                  ),
                ),
                Container(
                    width: Utils.screenWidth(context) * 0.8,
                    margin: EdgeInsets.only(top: 10),
                    child: Center(child: CustomText(text: "or signup with",
                      color: Colors.grey,
                      fontSize: 15,))
                ),
                InkWell(
                  onTap: () async{
                    bool res=await UserServices.signupwithGoogle();
                    if(res==true)
                      {
                        CustomSnackbar.showCustomSnackbar(
                            context, "Successfully Created an Account !!");
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/homeview', (route) => false);
                      }
                    else
                      {
                        CustomSnackbar.showCustomSnackbar(
                            context, "Cannot create an account !!");
                      }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: CircleAvatar(
                      backgroundImage: AssetImage(
                          'assets/images/googleimg.png'),
                    ),
                  ),

                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
