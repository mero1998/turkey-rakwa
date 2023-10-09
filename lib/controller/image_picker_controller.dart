import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rakwa/screens/add_listing_screens/Controllers/add_work_controller.dart';
import 'package:path/path.dart' as path;

class ImagePickerController extends GetxController {

 static ImagePickerController get to => Get.find();
  XFile? image_file;
  XFile? image_review_file;
  File? menuFile;
  String menuFileName = "";
  List<XFile>? images;
 RxBool value = false.obs;


 RxString path = "".obs;
 RxString ldrive = "".obs;
 RxString adImage = "".obs;
 RxString adVideo = "".obs;
  ImagePicker _imagePicker = ImagePicker();
  var url;
  List urls =[];

  Future<void> getImageFromGallary() async {
    image_file = await _imagePicker.pickImage(source: ImageSource.gallery);

   // var img = await decodeImageFile(image_file!.path);

   // var img2 = copyResize(img!,
   //      width: (MediaQuery.of(context).size.width * 0.8).toInt(),
   //      height: (MediaQuery.of(context).size.height * 0.7).toInt());

   if(image_file!.path.isNotEmpty){
     url = File(image_file!.path);

     AddWorkOrAdsController.to.featureImage = image_file!.path;

     print('URL::::: ${AddWorkOrAdsController.to.featureImage}');
   }
    update();
  }


  Future<void> getImageFromCamera() async {
    image_file = await _imagePicker.pickImage(source: ImageSource.camera);
    url = File(image_file!.path);
    update();
  }
  removeFile(){
    image_file = null;
    update();
  }

  Future<void> getMultiImage()async{
    images = await _imagePicker.pickMultiImage();

    AddWorkOrAdsController.to.imageGallery.clear();
    for (int i = 0; i < images!.length; i++) {
      var path = images![i].path;
    urls.add(path);
    }
    AddWorkOrAdsController.to.imageGallery = urls;
    AddWorkOrAdsController.to.imageGalleryFile = images!;
    // AddWorkOrAdsController.to.imageGallery =  images.urls;

    update();
  }

 Future<void> getMenuFile()async{
   FilePickerResult? result = await FilePicker.platform.pickFiles(
       allowCompression: false,
        allowMultiple: false,
     // allowedExtensions: ['pdf']
   );


   if (result != null) {
    menuFile = File(result.files.single.path!);
    menuFileName = result.files.single.name;
    // if (Platform.isIOS) {
    //   final documentPath = (await getApplicationDocumentsDirectory()).path;
    //   menuFile = await menuFile!.copy('$documentPath/${path.basename(menuFile!.path)}');
    // }
    AddWorkOrAdsController.to.menuFile = result.files.single.path!;


    print("Path ::${menuFile}");
    print("Path ::${result.files.single.name!}");
   } else {
     // User canceled the picker
   }

   update();
 }

}
