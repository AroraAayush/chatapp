import 'package:get/get.dart';

class LoginController extends GetxController
{
  RxBool hidePass=true.obs;

  togglePass()
  {
    print("Toggled pass");
    print("${hidePass}");
    hidePass.value=!hidePass.value;
  }


}