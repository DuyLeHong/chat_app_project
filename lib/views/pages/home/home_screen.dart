import 'package:chat_app_project/views/pages/home/chat_page/chat_screen.dart';
import 'package:chat_app_project/views/pages/home/user_page/user_screen.dart';
import 'package:chat_app_project/views/pages/home/video_page/video_screen.dart';
import 'package:chat_app_project/views/widgets/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _tabIndex = 0;
  final List<Widget> _list = [VideoScreen(), ChatScreen(), UserInfoScreen()];

  void _changeTabIndex(int index) {
    setState(() {
      _tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: IndexedStack(
          index: _tabIndex,
          children: _list,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.music_house_fill),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_2_fill),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_alt_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _tabIndex,
        selectedItemColor: MyColors.thirdColor,
        onTap: _changeTabIndex,
      ),
    );
  }
}
