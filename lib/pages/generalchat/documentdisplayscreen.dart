import 'package:chatwithaayushhhh/custom/customText.dart';
import 'package:chatwithaayushhhh/mediaqueries/media.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class DocumentDisplayScreen extends StatefulWidget {
  final String mediaUrl;
  const DocumentDisplayScreen({super.key,required this.mediaUrl});

  @override
  State<DocumentDisplayScreen> createState() => _DocumentDisplayScreenState();
}

class _DocumentDisplayScreenState extends State<DocumentDisplayScreen> {
  String filename="";
  @override
  void initState() {
    filename=extractFileName();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: "Document",fontSize: 17,),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SizedBox(
        height: Utils.screenHeight(context),
        width: Utils.screenWidth(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MediaFormat(widget.mediaUrl)=="document"?Image.asset('assets/images/docimage.png'):Image.asset('assets/images/pdfimage.png'),
            CustomText(text: extractFileName(),maxLines: 2,fontSize: 16,fontWeight: FontWeight.bold,).marginOnly(top: 15)
          ],
        ),
      ),
      
    );
  }

  String extractFileName() {
    String url = widget.mediaUrl;
    print("Url : ${url}");
    int start = url.indexOf('documents%2F');
    int end = url.indexOf('?', start);
    return url.substring(start + 12, end);
  }

  String MediaFormat(String mediaUrl) {
    if(mediaUrl.contains('.doc') ||mediaUrl.contains('.docx') )
      return "document";
    else if(mediaUrl.contains('.pdf'))
      return "pdf";
    else
      return "image";
  }
}