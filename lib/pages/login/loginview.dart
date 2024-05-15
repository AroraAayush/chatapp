import 'package:chatwithaayushhhh/colors/appcolors.dart';
import 'package:chatwithaayushhhh/custom/customText.dart';
import 'package:chatwithaayushhhh/firebase/userservices.dart';
import 'package:chatwithaayushhhh/mediaqueries/media.dart';
import 'package:chatwithaayushhhh/pages/login/loginController.dart';
import 'package:chatwithaayushhhh/pages/signup/validators.dart';
import 'package:chatwithaayushhhh/pages/signup/widgets/customsubmitbutton.dart';
import 'package:chatwithaayushhhh/pages/signup/widgets/customtextfield.dart';
import 'package:chatwithaayushhhh/pages/signup/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

final emailController=TextEditingController();
final passwordController=TextEditingController();
final _formKey = GlobalKey<FormState>();
class _LoginViewState extends State<LoginView> {


  @override
  void dispose() {
    emailController.clear();
    passwordController.clear();
    super.dispose();
  }
final loginController=Get.put(LoginController());
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top:Utils.screenHeight(context) *0.1,bottom: Utils.screenHeight(context) *0.03),
                  child: CustomText(text: 'Login',fontSize: 26,maxLines: 1,textAlign:TextAlign.center,fontWeight: FontWeight.bold,color:AppColors.black),
                ),
                CustomTextField(controller: emailController,prefixIcon: Icon(Icons.email), obscure: false,what: "Email",validator: (value){return Validators.emailValidator(value);},),
                SizedBox(height: 15,),
                Obx((){
                  return CustomTextField(controller: passwordController,obscure: loginController.hidePass.value, what: "Password",
                      prefixIcon: Icon(Icons.password),
                      suffixIcon: loginController.hidePass.value==true?Icons.visibility: Icons.visibility_off,
                      suffixIconTapped: loginController.togglePass,
                      validator: (value){return Validators.passwordValidator(value);});
                })
                ,
                SizedBox(height: 25,),
                CustomSubmitButton(
                  onPressed: () async{
                    if (_formKey.currentState!.validate()){
                      print("Validated");
                      bool res=await UserServices.loginwithemailandpassword({"email":emailController.text,
                        "password":passwordController.text});
                      if(res==true) {
                        CustomSnackbar.showCustomSnackbar(context, "Successfully Logged in !!");
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/homeview', (route) => false);
                      }
                      else
                      {
                        CustomSnackbar.showCustomSnackbar(context, "No acccount exists with such credentials !!");
                      }
                    }
                  },
                  text: "Login",
                  buttonTextColor: Colors.white,
                  buttonColor:Colors.green,
                ),
                SizedBox(height: 15,),
                Container(
                  width: Utils.screenWidth(context)*0.8,
                  margin: EdgeInsets.only(top:10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(text: "Not a existing user ? ", fontSize: 15,),
                      InkWell(child:  CustomText(text: "Signup", fontSize: 15,color: Colors.blue,),
                        onTap: (){
                          Navigator.pushNamedAndRemoveUntil(context, '/signupview', (route) => false);
                        },)
                    ],
                  ),
                ),
                Container(
                  width: Utils.screenWidth(context)*0.8,
                  child: Divider(
                    height: 30,
                  ),
                ),
                Container(
                    width: Utils.screenWidth(context)*0.8,
                    margin: EdgeInsets.only(top:10),
                    child: Center(child: CustomText(text: "or login with", color: Colors.grey,fontSize: 15,))
                ),
                InkWell(
                  onTap: ()async{
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
                  child:Container(
                    margin: EdgeInsets.only(top:10),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/googleimg.png'),
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
