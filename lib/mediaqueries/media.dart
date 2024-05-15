import 'package:flutter/material.dart';


class Utils {
  static Size screenSize(BuildContext context)
  {
    return MediaQuery.of(context).size;
  }
  static double screenWidth(BuildContext context)
  {
    return screenSize(context).width;
  }
  static double screenHeight(BuildContext context)
  {
    return screenSize(context).height;
  }
}

