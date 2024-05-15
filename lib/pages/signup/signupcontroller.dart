import 'package:get/get.dart';

class SignUpController extends GetxController
{
  RxBool hidePass=true.obs;
  RxBool hideConfirmPass=true.obs;

  togglePass()
  {
    print("Toggled pass");
    print("${hidePass}");
    hidePass.value=!hidePass.value;
  }

  toggleConfirmPass()
  {
    hideConfirmPass.value=!hideConfirmPass.value;
  }
}