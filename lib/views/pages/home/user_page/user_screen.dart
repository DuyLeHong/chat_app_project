import 'dart:io';

import 'package:chat_app_project/database/models/loading_model.dart';
import 'package:chat_app_project/database/services/auth_service.dart';
import 'package:chat_app_project/database/services/storage_services.dart';
import 'package:chat_app_project/database/services/user_service.dart';
import 'package:chat_app_project/views/pages/home/user_page/edit_user_screen.dart';
import 'package:chat_app_project/views/pages/home/user_page/update_password_screen.dart';
import 'package:chat_app_project/views/widgets/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../../widgets/colors.dart';
import '../video_page/video_profile_player_screen.dart';
import 'add_video_screen.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  // File? imageFile;

  @override
  void initState() {
    super.initState();
    // print('Current UserID:${FirebaseAuth.instance.currentUser?.uid}');
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<File?> getImage() async {
    var _picker = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_picker != null) {
      File? imageFile = File(_picker.path);
      return imageFile;
    }
    return null;
  }

  Stream<QuerySnapshot> getUserImage() async* {
    final currentUserID = await FirebaseAuth.instance.currentUser?.uid;
    yield* FirebaseFirestore.instance
        .collection('users')
        .where('uID', isEqualTo: currentUserID)
        .snapshots();
  }

  pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    if (video != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AddVideoScreen(
            videoFile: File(video.path),
            videoPath: video.path,
          ),
        ),
      );
    }
  }

  showLogoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'SIGN OUT',
                  style: TextStyle(fontSize: 25, color: Colors.red),
                ),
                Text(
                  'Are you sure ?',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SimpleDialogOption(
                onPressed: () {
                  AuthService.Logout(context: context);
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.done,
                      color: Colors.green,
                    ),
                    Padding(
                      padding: EdgeInsets.all(7.0),
                      child: Text(
                        'Yes',
                        style: TextStyle(fontSize: 20, color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.of(context).pop(),
                child: Row(
                  children: const [
                    Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
                    Padding(
                      padding: EdgeInsets.all(7.0),
                      child: Text(
                        'No',
                        style: TextStyle(fontSize: 20, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  showOptionsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditUserInfoScreen()),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Icon(Icons.edit),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpdatePasswordScreen()),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Icon(Icons.lock_clock),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Update Password',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => pickVideo(ImageSource.gallery, context),
            child: Row(
              children: const [
                Icon(Icons.image),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Add Video - Gallery',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => pickVideo(ImageSource.camera, context),
            child: Row(
              children: const [
                Icon(Icons.camera_alt),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Add Video - Camera',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: Row(
              children: const [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: UserService.getUserInfo(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width / 8,
                    // ),
                    IconButton(
                      onPressed: () => showOptionsDialog(context),
                      iconSize: 25,
                      icon: Icon(
                        Icons.menu,
                        color: MyColors.thirdColor,
                      ),
                    ),
                    Center(
                      child: CustomText(
                        fontsize: 40,
                        text: '${snapshot.data.get('fullName')}',
                        fontFamily: 'DancingScript',
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () => showLogoutDialog(context),
                      iconSize: 25,
                      icon: Icon(
                        Icons.logout,
                        color: MyColors.thirdColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: 100,
                  width: 100,
                  child: Stack(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        child: StreamBuilder<QuerySnapshot>(
                            stream: getUserImage(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Something went wrong');
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return Consumer<LoadingModel>(
                                builder: (_, isLoadingImage, __) {
                                  if (isLoadingImage.isLoading) {
                                    return const CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  } else {
                                    return CircleAvatar(
                                      backgroundColor: MyColors.mainColor,
                                      backgroundImage: NetworkImage(snapshot
                                          .data?.docs.first['avartaURL']),
                                    );
                                  }
                                },
                              );
                            }),
                      ),
                      Positioned(
                        bottom: -16,
                        right: -15,
                        child: IconButton(
                          onPressed: () async {
                            context.read<LoadingModel>().changeLoading();
                            File? fileImage = await getImage();
                            if (fileImage == null) {
                              context.read<LoadingModel>().changeLoading();
                            } else {
                              String fileName =
                                  await StorageServices.uploadImage(fileImage);
                              UserService.editUserImage(
                                  context: context, ImageStorageLink: fileName);
                              context.read<LoadingModel>().changeLoading();
                            }
                          },
                          icon: Icon(
                            Icons.upload_sharp,
                            color: MyColors.thirdColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 20),
                // CustomText(
                //   alignment: Alignment.center,
                //   fontsize: 20,
                //   text: snapshot.data.get('fullName') == null
                //       ? ''
                //       : '${snapshot.data.get('fullName')}',
                //   fontFamily: 'Inter',
                //   color: Colors.black,
                // ),
                const SizedBox(height: 10),
                CustomText(
                  alignment: Alignment.center,
                  fontsize: 25,
                  text: '${snapshot.data.get('email')}',
                  fontFamily: 'DancingScript',
                  color: Colors.black,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  child: TabBar(
                    controller: _tabController,
                    // indicatorColor: Colors.green,
                    // labelColor: Colors.red,
                    indicator: MaterialIndicator(
                      height: 3,
                      topLeftRadius: 0,
                      topRightRadius: 0,
                      bottomLeftRadius: 5,
                      bottomRightRadius: 5,
                      horizontalPadding: 16,
                      tabPosition: TabPosition.bottom,
                    ),
                    tabs: const <Widget>[
                      Tab(
                        icon: Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                      ),
                      Tab(
                        icon: Icon(
                          Icons.video_collection,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: MediaQuery.of(context).size.height - 363,
                  width: MediaQuery.of(context).size.width,
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, top: 22),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  CustomText(
                                    alignment: Alignment.centerLeft,
                                    fontsize: 14,
                                    text: 'Full Name ',
                                    fontFamily: 'Poppins',
                                    color: Colors.black26,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomText(
                                    alignment: Alignment.centerLeft,
                                    fontsize: 20,
                                    text: '${snapshot.data.get('fullName')}',
                                    fontFamily: 'Montserrat',
                                    color: Colors.black87,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  CustomText(
                                    alignment: Alignment.centerLeft,
                                    fontsize: 14,
                                    text: 'Phone Number ',
                                    fontFamily: 'Poppins',
                                    color: Colors.black26,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomText(
                                    alignment: Alignment.centerLeft,
                                    fontsize: 20,
                                    text: '${snapshot.data.get('phone')}',
                                    fontFamily: 'Montserrat',
                                    color: Colors.black87,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  CustomText(
                                    alignment: Alignment.centerLeft,
                                    fontsize: 14,
                                    text: 'Age',
                                    fontFamily: 'Poppins',
                                    color: Colors.black26,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomText(
                                    alignment: Alignment.centerLeft,
                                    fontsize: 20,
                                    text: '${snapshot.data.get('age')}',
                                    fontFamily: 'Montserrat',
                                    color: Colors.black87,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  CustomText(
                                    alignment: Alignment.centerLeft,
                                    fontsize: 14,
                                    text: 'Gender',
                                    fontFamily: 'Poppins',
                                    color: Colors.black26,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomText(
                                    alignment: Alignment.centerLeft,
                                    fontsize: 20,
                                    text: '${snapshot.data.get('gender')}',
                                    fontFamily: 'Montserrat',
                                    color: Colors.black87,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  CustomText(
                                    alignment: Alignment.centerLeft,
                                    fontsize: 14,
                                    text: 'Email',
                                    fontFamily: 'Poppins',
                                    color: Colors.black26,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomText(
                                    alignment: Alignment.centerLeft,
                                    fontsize: 20,
                                    text: '${snapshot.data.get('email')}',
                                    fontFamily: 'Montserrat',
                                    color: Colors.black87,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('videos')
                            .where('uid', isEqualTo: uid)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 2 / 3),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                final item = snapshot.data!.docs[index];
                                return Card(
                                  color: Colors.grey,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VideoProfileScreen(
                                                  videoID: item['id'],
                                                )),
                                      );
                                    },
                                    child: Stack(
                                      fit: StackFit.expand,
                                      alignment: Alignment.center,
                                      children: [
                                        ClipRect(
                                          child: Image.network(
                                            '${item['thumbnail']}',
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 5,
                                          left: 5,
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.favorite_border,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                '${item['likes'].length}',
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
