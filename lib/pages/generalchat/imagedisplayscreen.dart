import 'package:chatwithaayushhhh/custom/customText.dart';
import 'package:chatwithaayushhhh/mediaqueries/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ImageDisplayScreen extends StatefulWidget {
  final String mediaUrl;
  const ImageDisplayScreen({super.key,required this.mediaUrl});

  @override
  State<ImageDisplayScreen> createState() => _ImageDisplayScreenState();
}

class _ImageDisplayScreenState extends State<ImageDisplayScreen> {
  
  String filename="";
  @override
  void initState() {
    extractFileName();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: filename,fontSize: 17,),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Center(
        child:
        FadeInImage.assetNetwork(
          fit: BoxFit.fill,
          placeholder: 'assets/images/faded.jpeg',
          image: widget.mediaUrl,
        ),
        // ConstrainedBox(constraints: BoxConstraints(minWidth: 50,minHeight: 50,maxWidth: 300,maxHeight: 300),
        // child: Image.network(widget.msg.mediaUrl),),
      )
    );
  }

  void extractFileName() {
    String url=widget.mediaUrl;
    int start=url.indexOf('images%');
    int end=url.indexOf('?',start);
    filename=url.substring(start+7,end);
  }
}
