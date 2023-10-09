import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class VideoPlay extends StatefulWidget {
  String? url;

  @override
  _VideoPlayState createState() => _VideoPlayState();

  VideoPlay({
    Key? key,
    this.url, // Video from assets folder
  }) : super(key: key);
}

class _VideoPlayState extends State<VideoPlay> {
  VideoPlayerController? controller;
  late Future<void> futureController;
  ValueNotifier<VideoPlayerValue?> currentPosition = ValueNotifier(null);


  initVideo() {
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.url!));

    futureController = controller!.initialize();
  }

  @override
  void initState() {
    initVideo();
    controller!.addListener(() {
      if (controller!.value.isInitialized) {
        print("init::::");
        currentPosition.value = controller!.value;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.url);
    return FutureBuilder(
      future: futureController,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator.adaptive();
        } else {
          return SizedBox(
            // height: controller!.value.size.height,
            height: 250.h,
            width: double.infinity,
            child: Stack(children: [
              Positioned(
                  child: Container(
                      foregroundDecoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(.7),
                              Colors.transparent
                            ],
                            stops: [
                              0,
                              .3
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter),
                      ),
                      child: VideoPlayer(controller!))),
              Positioned.fill(
                child: Column(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: GestureDetector(
                              onDoubleTap: () async {
                                Duration? position =
                                await controller!.position;
                                setState(() {
                                  controller!.seekTo(Duration(
                                      seconds: position!.inSeconds - 10));
                                });
                              },
                              child: const Icon(
                                Icons.fast_rewind_rounded,
                                color: Colors.black,
                                size: 40,
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 4,
                              child: IconButton(
                                icon: Icon(
                                  controller!.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.black,
                                  size: 40,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (controller!.value.isPlaying) {
                                      controller!.pause();
                                    } else {
                                      controller!.play();
                                    }
                                  });
                                },
                              )),
                          Expanded(
                            flex: 3,
                            child: GestureDetector(
                              onDoubleTap: () async {
                                Duration? position =
                                await controller!.position;
                                setState(() {
                                  controller!.seekTo(Duration(
                                      seconds: position!.inSeconds + 10));
                                });
                              },
                              child: const Icon(
                                Icons.fast_forward_rounded,
                                color: Colors.black,
                                size: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Expanded(
                    //     flex: 2,
                    //     child: Align(
                    //       alignment: Alignment.bottomCenter,
                    //       child: ValueListenableBuilder(
                    //           valueListenable: currentPosition,
                    //           builder: (context,
                    //               VideoPlayerValue? videoPlayerValue, w) {
                    //             return Padding(
                    //               padding: const EdgeInsets.symmetric(
                    //                   horizontal: 20, vertical: 10),
                    //               child: Row(
                    //                 children: [
                    //                   Text(
                    //                     videoPlayerValue!.position
                    //                         .toString()
                    //                         .substring(
                    //                         videoPlayerValue.position
                    //                             .toString()
                    //                             .indexOf(':') +
                    //                             1,
                    //                         videoPlayerValue.position
                    //                             .toString()
                    //                             .indexOf('.')),
                    //                     style: const TextStyle(
                    //                         color: Colors.white,
                    //                         fontSize: 22),
                    //                   ),
                    //                   const Spacer(),
                    //                   Text(
                    //                     videoPlayerValue.duration
                    //                         .toString()
                    //                         .substring(
                    //                         videoPlayerValue.duration
                    //                             .toString()
                    //                             .indexOf(':') +
                    //                             1,
                    //                         videoPlayerValue.duration
                    //                             .toString()
                    //                             .indexOf('.')),
                    //                     style: const TextStyle(
                    //                         color: Colors.white,
                    //                         fontSize: 22),
                    //                   ),
                    //                 ],
                    //               ),
                    //             );
                    //           }),
                    //     ))
                  ],
                ),
              ),
            ]),
          );
        }
      },
    );
  }
}