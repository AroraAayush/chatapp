import 'package:flutter/material.dart';
class CustomText extends StatelessWidget {
  final String text;
  final Color? color;
  final int? maxLines;
  final double? fontSize ;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  const CustomText({super.key,
  required this.text,
    this.color,
    this.fontSize,
    this.maxLines,
    this.textAlign,
    this.fontWeight
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      softWrap: true,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize,
        color: color,

        fontWeight: fontWeight,
      ),
    );
  }
}
