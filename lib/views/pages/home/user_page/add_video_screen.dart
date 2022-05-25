import 'dart:io';

import 'package:chat_app_project/database/services/storage_services.dart';
import 'package:chat_app_project/views/widgets/text.dart';
import 'package:chat_app_project/views/widgets/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../database/models/loading_model.dart';
import '../../../widgets/video_player_item.dart';

class AddVideoScreen extends StatelessWidget {
  final File videoFile;
  final String videoPath;
  AddVideoScreen({
    Key? key,
    required this.videoFile,
    required this.videoPath,
  }) : super(key: key);

  final _addVideoFormKey = GlobalKey<FormState>();
  TextEditingController _songController = TextEditingController();
  TextEditingController _captionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.read<LoadingModel>().isPushingVideo = false;
    return Scaffold(
      body: Consumer<LoadingModel>(
        builder: (_, isPushingVideo, __) {
          if (isPushingVideo.isPushingVideo) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                CustomText(
                  text: "Pushing Video ....",
                  fontsize: 25,
                  alignment: Alignment.center,
                  fontFamily: 'Popins',
                ),
              ],
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 2 / 3,
                    height: MediaQuery.of(context).size.height / 2,
                    child: VideoPlayerItem(
                      videoUrl: videoPath,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: _addVideoFormKey,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          width: MediaQuery.of(context).size.width - 20,
                          child: CustomTextFormField(
                            controller: _songController,
                            text: 'Song Name',
                            hint: '',
                            validator: (value) {},
                            onSave: (value) {},
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          width: MediaQuery.of(context).size.width - 20,
                          child: CustomTextFormField(
                            controller: _captionController,
                            text: 'Caption',
                            hint: '',
                            validator: (value) {},
                            onSave: (value) {},
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.all(10),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: Colors.red,
                              child: Text('Cancle'),
                            ),
                            SizedBox(
                              width: 60,
                            ),
                            FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.all(10),
                              onPressed: () {
                                context
                                    .read<LoadingModel>()
                                    .changePushingVideo();
                                StorageServices.uploadVideo(
                                    context,
                                    _songController.text,
                                    _captionController.text,
                                    videoPath);
                                // uploadVideoController.uploadVideo(
                                //     _songController.text,
                                //     _captionController.text,
                                //     widget.videoPath);
                              },
                              color: Colors.green,
                              child: Text('Share'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
