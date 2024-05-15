class Validators
{
  static String? emailValidator(String? email)
  {
    RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    bool isValidEmail = emailRegex.hasMatch(email!);
    if(!isValidEmail || email.length==0)
      return "Enter valid Email";
  }


  static String? usernameValidator(String? username)
  {
    if(username!.length==0)
      {
        return "Username can't be empty";
      }
  }

  static String? passwordValidator(String? password)
  {
    if(password!.length==0)
    {
      return "Password can't be empty";
    }
    else if(password.length<6)
      return "Password cannot be less than 6 characters";
  }
  static String? confirmpasswordValidator(String? confirmpassword,String? password)
  {
  if(confirmpassword!=password)
      return "Passwords don't match";
  }


}