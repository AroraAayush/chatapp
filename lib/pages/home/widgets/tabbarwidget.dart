import 'package:chatwithaayushhhh/custom/customText.dart';
import 'package:chatwithaayushhhh/pages/generalchat/generalchat.dart';
import 'package:chatwithaayushhhh/pages/generalchat/generalchatscreen.dart';
import 'package:chatwithaayushhhh/pages/groupchat/groupchat.dart';
import 'package:flutter/material.dart';
class TabbarWidget extends StatefulWidget {
  final ScrollController controller;
  const TabbarWidget({super.key,required this.controller});

  @override
  State<TabbarWidget> createState() => _TabbarWidgetState();
}

class _TabbarWidgetState extends State<TabbarWidget> with SingleTickerProviderStateMixin{
  TabController? _tabController;


  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
    decoration: BoxDecoration(
        //color: Colors.pink,
      borderRadius: BorderRadius.circular(35),
    ),
      child: Column(
        children: [
          Container(
            child: TabBar(
              tabAlignment: TabAlignment.start,
              dividerColor: Colors.transparent,
              indicatorColor: Colors.black,
              automaticIndicatorColorAdjustment: false,
              indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
              indicatorWeight: 2.5,
              padding: EdgeInsets.only(top:10,bottom: 10),
              isScrollable: true,
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.black,
              tabs: [
                Container(
                  width: 120,
                  height: 40,
                  padding: EdgeInsets.only(left: 10,right: 10,top:5,bottom: 5),
                  margin: EdgeInsets.only(bottom: 7,top: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green.withOpacity(0.2),
                  ),
                  child: Center(child: CustomText(text:"General Chat",fontSize: 14,fontWeight: FontWeight.w600,)),
                ),
                Container(
                  width: 100,
                  height: 40,
                  margin: EdgeInsets.only(bottom: 7,top: 5),
                  padding: EdgeInsets.only(left: 5,right: 5,top:5,bottom: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green.withOpacity(0.2),
                  ),
                  child: Center(child: CustomText(text:"Group Chat",fontSize: 14,fontWeight: FontWeight.w600,)),
                ),
                Container(
                  width: 140,
                  height: 40,
                  margin: EdgeInsets.only(bottom: 7,top: 5),
                  padding: EdgeInsets.only(left: 10,right: 10,top:5,bottom: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green.withOpacity(0.1),
                  ),
                  child: Center(child: CustomText(text:"Community Chat",fontSize: 14,fontWeight: FontWeight.w600,)),
                ),
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                GeneralChat(),
               GroupChat(),
                Container(child: Center(child: Text('people'))),
              ],
              controller: _tabController,
            ),
          ),
        ],
      ),

    );
  }
}
