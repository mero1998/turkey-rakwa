import 'dart:convert';
import 'dart:io';

// import 'package:app_links/app_links.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/screens/details_screen/details_classified_screen.dart';
import 'package:rakwa/screens/details_screen/details_screen.dart';
import 'package:rakwa/screens/messages_screen/messages_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

//
// class FirebaseDynamicLinkService {
//   static Future<String> createDynamicLink(bool short, String id) async {
//     String _linkMessage;
//
//     final DynamicLinkParameters parameters = DynamicLinkParameters(
//       uriPrefix: 'https://rakwa.page.link',
//       link: Uri.parse('https://rakwa.page.link/Kz3a'),
//       androidParameters: AndroidParameters(
//         packageName: 'com.example.rakwa',
//         minimumVersion: 0,
//       ),
//       iosParameters: const IOSParameters(
//         bundleId: 'com.turkey.rakwa',
//         minimumVersion: '1',
//         appStoreId: '1660636889',
//       ),
//     );
//
//         Uri url;
//     if (short) {
//       final ShortDynamicLink shortLink =
//       await FirebaseDynamicLinks.instance.buildShortLink(parameters);
//       url = shortLink.shortUrl;
//     } else {
//       url = await FirebaseDynamicLinks.instance.buildLink(parameters);
//     }
//
//     Share.share(url.toString(), subject: 'eat');
//
//     _linkMessage = url.toString();
//     return _linkMessage;
//   }
//
//   static Future<void> initDynamicLink(BuildContext context) async {
//     FirebaseDynamicLinks.instance.getInitialLink().then((data) {
//       final Uri deepLink = data!.link;
//       printDM("deepLink.pathSegments is 1");
//       printDM("deepLink.pathSegments is ${deepLink.pathSegments}");
//       var isCategory = deepLink.pathSegments.contains('category');
//       if (isCategory) {
//         String? id = deepLink.queryParameters['id'];
//         print("ID :::: $id");
//         Get.to(() => DetailsScreen(
//               id: id!,
//             ));
//       }
//     });
//
//     final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
//
//     try {
//       final Uri deepLink = initialLink!.link;
//       var isCategory = deepLink.pathSegments.contains('category');
//       if (isCategory) {
//         // TODO :Modify Accordingly
//         String? id = deepLink.queryParameters['id'];
//         print("ID :::: $id");
//         Get.to(() => DetailsScreen(
//           id: id!,
//         ));
//         // TODO : Navigate to your pages accordingly here
//
//       }
//     } catch (e) {
//       print('No deepLink found');
//     }
//   }
// }

FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

class DynamicLink {

  Future<String> createDynamicLink(bool short,

  { required String id,required String title,required String desc,required String image,required String tag}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://rakwa.page.link',
      link: Uri.parse('https://rakwa.page.link/category?id=$id&tag=$tag'),
      androidParameters: const AndroidParameters(
        packageName: 'rakwa.turkey.com',
        minimumVersion: 1,
      ),
      iosParameters:  IOSParameters(
        bundleId: 'com.turkey.rakwa',
        minimumVersion: '1',
        appStoreId: '1660636889',
        fallbackUrl: Uri.parse('https://rakwa.page.link/category?id=$id&tag=$tag')
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: title,
        description: desc,
        imageUrl: Uri.parse(
         image,
        ),
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink =
      await dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await dynamicLinks.buildLink(parameters);
    }


    https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=api_key
  // var  uri = Uri.parse("https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=AIzaSyCtqCoO0NedlmsnEab8acG2CUIaH3XK9ps");
  //
  // var response = await http.post(uri,
  //     headers: {
  // "Content-Type": "application/json"},
  //   body: jsonEncode({
  //     "dynamicLinkInfo": {
  //       "domainUriPrefix": "https://rakwa.page.link",
  //       "link": 'https://rakwa.page.link/category?id=$id&tag=$tag',
  //       "androidInfo": {
  //         "androidPackageName": "rakwa.turkey.com"
  //       },
  //       "iosInfo": {
  //         "iosBundleId": "com.turkey.rakwa"
  //       }
  //     }
  //   })
  // );

  // print(response.statusCode);
    // if (response.statusCode == 200) {
    //   var jsonResponse = jsonDecode(response.body);
      // printDM("jsonResponse search_query is =>${jsonResponse}");
      Share.share(url.toString());
    String _dynamicLink = url.toString();
    return _dynamicLink;
  //     print(response.body);
  // }
///
    // return "";
  }
  // static Future<void>  initDynamicLinkIOS() async {
  //   final appLinks = AppLinks();
  //   final Uri? uri = await appLinks.getInitialAppLink();
  //   if (uri != null) {
  //     final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getDynamicLink(uri);
  //     Uri?  deepLink = data?.link;
  //
  //     print("link ios ::: $deepLink");
  //     if (deepLink != null) {
  //       // do your logic here, like navigation to a specific screen
  //       String? id = deepLink.queryParameters['id']??"";
  //       String? tag = deepLink.queryParameters['tag']??"";
  //       if(tag == "item"){
  //         Get.to(() => DetailsScreen(
  //           id: id,
  //         ));
  //       }else{
  //         Get.to(() => DetailsClassifiedScreen(
  //           id: int.parse(id),
  //         ));
  //       }
  //     }
  //   }
  // }
  Future<void> retrieveDynamicLink() async {
    print("we are here from retreive");


    dynamicLinks.onLink.listen((dynamicLinkData) async{
       Uri deepLink =await dynamicLinkData.link;

      printDM("deepLink. data is ${deepLink.data}");
      printDM("deepLink. path is ${deepLink.path}");
      printDM("deepLink. fragment is ${deepLink.fragment}");
      printDM("deepLink. pathSegments is ${deepLink.pathSegments}");
      printDM("deepLink. queryParameters is ${deepLink.queryParameters}");
      String id = deepLink.queryParameters['id'] ?? "";
      String? tag = deepLink!.queryParameters['tag']??"";

      print(' id....................... $id');
      if(id!='' && id!=null){
        if(tag == "item"){
          print("ID :::: $id");
          Get.to(() => DetailsScreen(
            id: id,
          ));
        }else{
          Get.to(() => DetailsClassifiedScreen(
            id: int.parse(id),
          ));
        }
      }

      /// navigation
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });

    // try{
    //   dynamicLinks.onLink.listen((dynamicLinkData) async{
    //     final Uri deepLink =await dynamicLinkData.link;
    //
    //     printDM("deepLink. data is ${deepLink.data}");
    //     printDM("deepLink. path is ${deepLink.path}");
    //     printDM("deepLink. fragment is ${deepLink.fragment}");
    //     printDM("deepLink. pathSegments is ${deepLink.pathSegments}");
    //     printDM("deepLink. queryParameters is ${deepLink.queryParameters}");
    //     String id = deepLink.queryParameters['id'] ?? "";
    //     String? tag = deepLink!.queryParameters['tag']??"";
    //
    //     print(' id....................... $id');
    //     if(id!='' && id!=null){
    //       if(tag == "item"){
    //         print("ID :::: $id");
    //         Get.to(() => DetailsScreen(
    //           id: id,
    //         ));
    //       }else{
    //         Get.to(() => DetailsClassifiedScreen(
    //           id: int.parse(id),
    //         ));
    //       }
    //     }});
    // }catch(e){
    //   print("Error ::::${e}");
    // }


    try {
      Uri? deepLink;


      Future.delayed(Duration(seconds: 3), ()async{
        // String url = "https://rakwa.page.link/PRsh";
        //  final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getDynamicLink(Uri.parse(url));
        final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();

        print(initialLink);
        if(initialLink != null){
          deepLink = initialLink.link;
          printDM("deepLink.pathSegments is ");
          if (deepLink != null) {
            printDM("deepLink.pathSegments is ${deepLink!.queryParameters}");

            String? id = deepLink!.queryParameters['id']??"";
            String? tag = deepLink!.queryParameters['tag']??"";
            if(id!=""){
              if(tag == "item"){
                Get.to(() => DetailsScreen(
                  id: id,
                ));
              }else{
                Get.to(() => DetailsClassifiedScreen(
                  id: int.parse(id),
                ));
              }

            }
          }
        }
      });

      // FirebaseDynamicLinks.instance.getInitialLink().then((data) {
      //   deepLink = data?.link;
      //   printDM("deepLink.pathSegments is ");
      //   if (deepLink != null) {
      //     printDM("deepLink.pathSegments is ${deepLink!.queryParameters}");
      //
      //     String? id = deepLink!.queryParameters['id']??"";
      //     if(id!=""){
      //     print("ID :::: $id");
      //     Get.to(() => DetailsScreen(
      //           id: id,
      //         ));
      //     }
      //   }
      // });


      // FirebaseDynamicLinks.instance.onLink(
      //     onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      //   final Uri deepLink = dynamicLink!.link;
      //   String id = deepLink.queryParameters['id'] ?? "";
      //   print(' id....................... $id');
      //   Get.to(() => DetailsScreen(
      //     id: id,
      //   ));
      //
      //     });

      dynamicLinks.onLink.listen((dynamicLinkData) async{
        final Uri deepLink =await dynamicLinkData.link;

        printDM("deepLink. data is ${deepLink.data}");
        printDM("deepLink. path is ${deepLink.path}");
        printDM("deepLink. fragment is ${deepLink.fragment}");
        printDM("deepLink. pathSegments is ${deepLink.pathSegments}");
        printDM("deepLink. queryParameters is ${deepLink.queryParameters}");
        String id = deepLink.queryParameters['id'] ?? "";
        String? tag = deepLink!.queryParameters['tag']??"";

        print(' id....................... $id');
        if(id!='' && id!=null){
          if(tag == "item"){
            print("ID :::: $id");
            Get.to(() => DetailsScreen(
              id: id,
            ));
          }else{
            Get.to(() => DetailsClassifiedScreen(
              id: int.parse(id),
            ));
          }
        }

        /// navigation
      }).onError((error) {
        print('onLink error');
        print(error.message);
      });
    } catch (e) {
      print('onLink error');
      print(e.toString());
    }
  }

}


// https://rakwa.page.link?sd=description&si=https%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fcommons%2F7%2F73%2FLion_waiting_in_Namibia.jpg&st=title&amv=1&apn=com.example.rakwa&ibi=com.turkey.rakwa&imv=1&isi=1660636889&link=https%3A%2F%2Frakwa.page.link%2Fcategory%3Fid%3D256
//https://rakwa.page.link?sd=description&si=https%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fcommons%2F7%2F73%2FLion_waiting_in_Namibia.jpg&st=title&amv=1&apn=com.example.rakwa&ibi=com.turkey.rakwa&imv=1&isi=1660636889&link=https%3A%2F%2Frakwa.page.link%2Fcategory%3Fid%3D512
//https://rakwa.page.link?sd=description&si=https%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fcommons%2F7%2F73%2FLion_waiting_in_Namibia.jpg&st=title&amv=1&apn=com.example.rakwa&ibi=com.turkey.rakwa&imv=1&isi=1660636889&link=https%3A%2F%2Frakwa.page.link%2Fcategory%3Fid%3D768
// https://rakwa.page.link/s4QR
//https://rakwa.page.link/WGAX