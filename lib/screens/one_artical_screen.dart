import 'dart:io';

// import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/model/artical_model.dart';
import 'package:html/parser.dart';
import 'package:rakwa/screens/details_screen/details_screen.dart';
// import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class OneArticalScreen extends StatefulWidget {
  final ArticalModel articalModel;

  OneArticalScreen({required this.articalModel});

  @override
  State<OneArticalScreen> createState() => _OneArticalScreenState();
}

class _OneArticalScreenState extends State<OneArticalScreen> {
  var text;
  YoutubePlayerController? _controller;
  List<String> urls = [];
  @override
  void initState() {
    super.initState();

    text = _parseHtmlString(widget.articalModel.body!);
    //
  String s = widget.articalModel.body!;
    RegExp exp = new RegExp(r"([/|.|\w|\s|-])*\.(?:jpg|gif|png)");

    Iterable<Match> matches = exp.allMatches(s);

    print("List::: ${matches.toList()}");
    matches.toList().forEach((item) {
      print("Images:::: ${item[0]}");
    });

    if(s.contains("https://www.youtube.com")){

    int startIndex = s.indexOf("https://www.youtube.com");
    int endIndex = s.indexOf("\"", startIndex + '\"'.length);

    // lat = l.substring(startIndex + "h/".length, endIndex);
    // print(l.substring(startIndex + "h/".length, endIndex));

    // int startIndex2 = s.indexOf(",");
    // int endIndex2 = s.indexOf("?s", startIndex2 + "?s".length);

    // lng = l.substring(startIndex2 + ",".length, endIndex2);
    // print("URL::: ${s.substring(startIndex,endIndex)}");
    // String url = s.substring(startIndex,endIndex);
    // urls.add(url);
    // print(urls);
    // String? videoId;
    // videoId = YoutubePlayer.convertUrlToId(url);
    // print("ID::: ${videoId}");
    // _controller =  YoutubePlayerController(
    //   initialVideoId: videoId!,
    //
    // );
    // extractLink(s);

    RegExp exp = new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    Iterable<RegExpMatch> matches = exp.allMatches(s);
    urls.clear();
    matches.forEach((match) {
      urls.add(s.substring(match.start, match.end).toString());
      print("URL::: ${s.substring(match.start, match.end)}");
      print(urls);
    });
  }
  }
  String extractLink(String input) {
    var elements = Linkify(
        options: LinkifyOptions(
          humanize: false,
        ), text: input,).linkifiers;
    for (var e in elements) {
      if (e is LinkableElement) {
        print("URL ::: ${e}");
      }
    }
    return "";
  }
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 232.h,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.black12,
            leadingWidth: 80,
            leading:   Center(
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.4),
                child: IconButton(
                    onPressed: () {
                        Get.back();

                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: SizedBox(
                height: 232,
                width: Get.width,
                child: Image.network(
                  'https://www.rakwa.com/laravel_project/public${widget.articalModel.featuredImage}',
                  height: 232,
                  width: Get.width,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                AnimationLimiter(
                  // child: Column(
                  //   children: AnimationConfiguration.toStaggeredList(
                  //     duration: const Duration(milliseconds: 375),
                  //     childAnimationBuilder: (widget) => SlideAnimation(
                  //       horizontalOffset: 50.0,
                  //       child: FadeInAnimation(
                  //         child: widget,
                  //       ),
                  //     ),
                  //     children: [
                  //       const SizedBox(height: 24),
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  //         child: SizedBox(
                  //           height: 20,
                  //           child: Row(
                  //             children: [
                  //                VerticalDivider(
                  //                 color: AppColors().mainColor,
                  //                 thickness: 1,
                  //               ),
                  //               Text(
                  //                 widget.articalModel.publishedAt!.toString(),
                  //                 style: GoogleFonts.tajawal(
                  //                     textStyle: const TextStyle(
                  //                   color: AppColors.viewAllColor,
                  //                 )),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //       const SizedBox(height: 16),
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  //         child: Text(
                  //           widget.articalModel.title!,
                  //           style: GoogleFonts.notoKufiArabic(
                  //               textStyle: const TextStyle(
                  //             fontWeight: FontWeight.w700,
                  //             color: Colors.black,
                  //           )),
                  //         ),
                  //       ),
                  //       const SizedBox(
                  //         height: 12,
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(
                  //             horizontal: 24.0, vertical: 10),
                  //         child: SingleChildScrollView(
                  //           physics: const BouncingScrollPhysics(),
                  //           child: Text(
                  //             text.replaceAll('.', '\n'),
                  //
                  //             style: GoogleFonts.notoKufiArabic(
                  //               color: AppColors.describtionLabel,
                  //             height: 2
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       // Padding(
                  //       //   padding:  EdgeInsetsDirectional.only(
                  //       //     start: 24.w,
                  //       //       end: 24.w,
                  //       //       top: 10.h,
                  //       //       bottom: 30.h),
                  //       //   child: ListView.builder(
                  //       //     itemBuilder: (context, index) {
                  //       //       return YoutubePlayer(
                  //       //         controller: _controller!.load,
                  //       //       );
                  //       //     }
                  //       //   ),
                  //       // ),
                  //       ListView.separated(
                  //         shrinkWrap: true,
                  //         cacheExtent: 1000,
                  //         physics: NeverScrollableScrollPhysics(),
                  //         scrollDirection: Axis.vertical,
                  //         // key: PageStorageKey(widget.position),
                  //         addAutomaticKeepAlives: true,
                  //         itemCount: urls.isEmpty ? 0 : urls.length,
                  //         itemBuilder: (BuildContext context, int index) =>
                  //             VideoWidget(
                  //               play: false,
                  //               url: urls.elementAt(index),
                  //             ),
                  //         separatorBuilder: (context, index) {
                  //           return Divider();
                  //         },
                  //       )
                  //     ],
                  //   ),
                  // ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: HtmlWidget( //to show HTML as widget.
              widget.articalModel.body ?? "",
            customWidgetBuilder: (element) {
              final src = Uri.parse(element.attributes["src"] ?? "");
              if (element.localName == "img") {
                return Image.network("https://rakwa.com/$src");
              }else if(element.localName == "iframe"){
                return VideoWidget(url: src.toString(), play: false);

              }
              //
              // final src2 = Uri.parse(element.localName["title"] ?? "");
              // if (src2.toString().isNotEmpty) {
              //   return VideoWidget(url: src2.toString(), play: false);
              // }
              return null;
            },
            renderMode: RenderMode.column,
            textStyle: GoogleFonts.notoKufiArabic(
                textStyle:  TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black))


              // webView: true,
              // bodyPadding: EdgeInsets.all(10),
              //body padding (Optional)
              // baseUrl: Uri.parse("https://www.hellohpc.com"),
              //baseURl (optional)
              // onTapUrl:(url){
              //   return
              //   print("Clicked url is $url");
              //   //by default it shows app to open url.
              //   //or you can do it in your own way
              // }
          ),
        ),
                ),

                const SizedBox(
                  height: 24,
                ),
                // Container(
                //   color: Colors.grey.shade400,
                //   width: double.infinity,
                //   height: 120.h,
                //   alignment: AlignmentDirectional.center,
                //   child: Text("مساحة اعلانية",style: TextStyle(
                //       color: Colors.white,
                //       fontWeight: FontWeight.bold,
                //       fontSize: 20.sp
                //   ),),
                // ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VideoWidget extends StatefulWidget {

  final bool play;
  final String url;

  const VideoWidget({ required this.url, required this.play});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}


class _VideoWidgetState extends State<VideoWidget> {
  YoutubePlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  String? videoId;
  @override
  void initState() {
    super.initState();
    videoId = YoutubePlayer.convertUrlToId(widget.url);
    // print("ID::: ${videoId}");
    if(videoId != null){
      _controller =  YoutubePlayerController(
        initialVideoId: videoId!,
          flags: const YoutubePlayerFlags(autoPlay: false, loop: false)


    );
    }else{
      _controller =  YoutubePlayerController(
        initialVideoId: widget.url.replaceAll("//www.youtube.com/embed/", ""),
      );
    }


  } // This closing tag was missing

  @override
  void dispose() {
    //    widget.videoPlayerController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return FittedBox(
      fit: BoxFit.cover,
      child: Card(
        key: new PageStorageKey(widget.url),
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: YoutubePlayer(

            controller: _controller!,
          ),
        ),
      ),
    );


  }


}


// class VideoWidget extends StatefulWidget {
//
//   final bool play;
//   final String url;
//
//   const VideoWidget({ required this.url, required this.play});
//
//   @override
//   _VideoWidgetState createState() => _VideoWidgetState();
// }
//
//
// class _VideoWidgetState extends State<VideoWidget> {
//   VideoPlayerController? videoPlayerController ;
//   Future<void>? _initializeVideoPlayerFuture;
//
//   Future<ClosedCaptionFile> _loadCaptions() async {
//     final String fileContents = await DefaultAssetBundle.of(context)
//         .loadString('assets/bumble_bee_captions.vtt');
//     return WebVTTCaptionFile(
//         fileContents); // For vtt files, use WebVTTCaptionFile
//   }
//   @override
//   void initState() {
//     super.initState();
//     videoPlayerController = new VideoPlayerController.network(
//       widget.url,
//       videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false,),
//       closedCaptionFile: _loadCaptions(),
//
//     );
//     videoPlayerController!.setLooping(true);
//     videoPlayerController!.setVolume(0.0);
//     videoPlayerController!.play();
//     _initializeVideoPlayerFuture = videoPlayerController!.initialize().then((_) {
//       //       Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//       setState(() {});
//     });
//   } // This closing tag was missing
//
//   @override
//   void dispose() {
//     videoPlayerController!.dispose();
//     //    widget.videoPlayerController.dispose();
//     super.dispose();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return FutureBuilder(
//       future: _initializeVideoPlayerFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           return FittedBox(
//             fit: BoxFit.cover,
//             child: SizedBox(
//               height: 300.h,
//               child: Card(
//                 key: new PageStorageKey("https://www.youtube.com/watch/P1vuIU4B5HM"),
//                 elevation: 5.0,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Chewie(
//                     key: new PageStorageKey(widget.url),
//                     controller: ChewieController(
//                       videoPlayerController: videoPlayerController!,
//                       aspectRatio: 1,
//                       // Prepare the video to be played and display the first frame
//                       autoInitialize: true,
//                       looping: false,
//                       autoPlay: false,
//                       // Errors can occur for example when trying to play a video
//                       // from a non-existent URL
//                       errorBuilder: (context, errorMessage) {
//                         return Center(
//                           child: Text(
//                             errorMessage,
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }
//         else {
//           return Center(
//             child: CircularProgressIndicator(),);
//         }
//       },
//     );
//
//
//   }
//
//
// }
