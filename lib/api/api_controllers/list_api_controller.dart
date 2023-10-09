import 'dart:convert';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:path/path.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/api/api_controllers/menu_api_controller.dart';
import 'package:rakwa/api/api_helper/api_helper.dart';
import 'package:rakwa/api/api_setting/api_setting.dart';
import 'package:rakwa/controller/all_menu_getx_controller.dart';
import 'package:rakwa/controller/image_picker_controller.dart';
import 'package:rakwa/model/add_category.dart';
import 'package:rakwa/model/all_categories_model.dart';
import 'package:rakwa/model/city_model.dart';
import 'package:rakwa/model/country_model.dart';
import 'package:rakwa/model/create_item_model.dart';
import 'package:rakwa/model/custom_field_model.dart';
import 'package:rakwa/model/paid_items_model.dart';
import 'package:rakwa/model/terms.dart';
import 'package:rakwa/screens/add_listing_screens/Controllers/add_work_controller.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';

import '../../model/autocomplete_model.dart';
enum Availability { loading, available, unavailable }

class ListApiController with ApiHelper {

  Future<List<CountryModel>> getCountrys() async {
    Uri uri = Uri.parse(ApiKey.country);
    var response = await http.get(uri, headers: tokenKey);
    // ("Response::: ${response.body}");
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['country'] as List;
      return jsonArray.map((e) => CountryModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<CityModel>> getCitys({required String id}) async {
    Uri uri = Uri.parse('${ApiKey.city}/$id');
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['city'] as List;
      return jsonArray.map((e) => CityModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<StateModel>> getState({required String id}) async {
    Uri uri = Uri.parse('${ApiKey.state}/$id');
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['state'] as List;
      return jsonArray.map((e) => StateModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<CustomFieldModel?> getCustomFields(
      {required List<int> ids, required bool isList}) async {

    // ("IDS::: ${ids}");
    Map<String, String> data = {};
    for (int i = 0; i < ids.length; i++) {
      data.addAll({'category[$i]' : ids[i].toString()});
    }
    // DM("categoryIds body send is => $data ");
    Uri uri;
    if (isList) {
      uri = Uri.parse(ApiKey.customFields);
    } else {
      uri = Uri.parse(ApiKey.customClassifiedFields);
    }
    // DM("getCustomFields uri send is => $uri ");

    var response = await http.post(uri, headers: headers, body: data);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      // (jsonResponse);
      return CustomFieldModel.fromJson(jsonResponse);
    }
    return null;
  }

  Future<List<AllCategoriesModel>> getCategory() async {
    Uri uri = Uri.parse(ApiKey.category);
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['category'] as List;
      return jsonArray
          .where((element) => element['category_parent_id'] == null)
          .map((e) => AllCategoriesModel.fromJson(e))
          .toList();
    }
    return [];
  }

  Future<List<AllCategoriesModel>> getSubCategory({required String id}) async {
    // ("ID :::: $id");
    Uri uri = Uri.parse(ApiKey.category);
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      // ("Response::: ${jsonResponse}");
      var jsonArray = jsonResponse['category'] as List;
      return jsonArray
          .where((element) => element['category_parent_id'] == int.parse(id))
          .map((e) => AllCategoriesModel.fromJson(e))
          .toList();
    }
    return [];
  }

  Future<List<AllCategoriesModel>> getClassifiedCategory() async {
    Uri uri = Uri.parse(ApiKey.classifiedCategory);
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['classified_category'] as List;
      return jsonArray
          .where((element) => element['category_parent_id'] == null)
          .map((e) => AllCategoriesModel.fromJson(e))
          .toList();
    }
    return [];
  }

  Future<List<AllCategoriesModel>> getClassifiedSubCategory(
      {required int id}) async {
    Uri uri = Uri.parse(ApiKey.classifiedCategory);
    var response = await http.get(uri, headers: tokenKey);
    // DM("response getClassifiedSubCategory is => ${response.body}");
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['classified_category'] as List;
      return jsonArray
          .where((element) => element['category_parent_id'] == id)
          .map((e) => AllCategoriesModel.fromJson(e))
          .toList();
    }
    return [];
  }

  Future<List<AutoCompleteModel>> getAddress({required String input}) async {
    Uri uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=AIzaSyBauBUw7ABmSkqpsx0yLM73Eqehz1guZS0');
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['predictions'] as List;
      return jsonArray.map((e) => AutoCompleteModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<Map<String, double>> getAddressDetails({required String id}) async {
    Uri uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$id&key=AIzaSyBauBUw7ABmSkqpsx0yLM73Eqehz1guZS0');
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['result'];
      var result = jsonArray['geometry'];
      var geometry = result['location'];
      Map<String, double> location = {
        'lat': geometry['lat'],
        'lng': geometry['lng'],
      };
      return location;
    }
    return {};
  }

  String generateSlug(String input) {
    return input.replaceAll(RegExp(r'[^a-zA-Z0-9]+'), '-').toLowerCase();
  }

  Future<List<TermsUser>> getTerms() async{
    Uri uri = Uri.parse(ApiKey.terms);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['data'] as List;

      return  jsonArray.map((e) => TermsUser.fromJson(e)).toList();
    }
    return [];
  }

  Future<bool> acceptTerms({required String termId}) async{
    var box = GetStorage();
    Uri uri = Uri.parse("${ApiKey.baseUrl4}${box.read("id")}/term");
    (uri);
    var response = await http.post(uri,body: {
      "terms_id" : termId
    },headers: {
      "Accept" : "application/json",

    });
    (response.statusCode);
    if (response.statusCode == 200) {

      Fluttertoast.showToast(msg: "شكراً لك على القبول",);
      ('success');
    return true;
    }else{
      return false;
    }

  }
  Future<bool> addList({
    required CreateItemModel createItemModel,
    required bool isList,
    required bool isUpdate,
    required List checkBox,
    required List textFiled,
    List? customFileds,
  }) async {
    List myField = [];
    Uri uri;
    if (isList) {
      if (isUpdate) {
        uri = Uri.parse(
            '${ApiKey.addList}${AddWorkOrAdsController.to.wodkId}/update-item');
      } else {
        uri = Uri.parse(
            '${ApiKey.addList}${SharedPrefController().id}/create-item');
      }
    } else {
      if (isUpdate) {
        uri = Uri.parse('${ApiKey.addList}${AddWorkOrAdsController.to
            .adId}/update-classified');
      } else {
        uri = Uri.parse(
            '${ApiKey.addList}${SharedPrefController().id}/create-classified');
      }
    }

    ('URIIII:: $uri');

    if (customFileds != null && customFileds.isNotEmpty) {
      for (int i = 0; i <= customFileds.length - 1; i++) {
        var aString = customFileds[i].replaceAll(RegExp(r'[^0-9]'), '');
        var aInteger = int.parse(aString);
        myField.add(aInteger);
      }
    }

    try {
      // (createItemModel);
      // ("Imeage :: ${createItemModel.featureImage!}");

      var requset = http.MultipartRequest('POST', uri);
      Map<String, String> headers = {
        "Content-type": "multipart/form-data",
        "Accept": "application/json"
      };
      requset.headers.addAll(headers);

      // if(ImagePickerController.to.image_file != null){
      //   requset.files.add(
      //     http.MultipartFile(
      //       'feature_image',
      //       ImagePickerController.to.image_file!.readAsBytes().asStream(),
      //       await ImagePickerController.to.image_file!.length(),
      //       // file.lengthSync(),
      //       filename: "test",
      //       // contentType: MediaType(type, extension),
      //     ),
      //
      //   );
      // }else{
      //   requset.fields
      //       .addAll({"feature_image" : AddWorkOrAdsController.to.featureImage ?? ""});
      // }

      // if(ImagePickerController.to.images != null){
      //
      //   ("From UPload files :::::::");
      //   for (int i = 0; i < createItemModel.imageGallery!.length; i++) {
      //     requset.files.add(
      //         http.MultipartFile(
      //           'image_gallery[$i]',
      //           ImagePickerController.to.images![i]!.readAsBytes().asStream(),
      //           await ImagePickerController.to.images![i]!.length(),
      //           // file.lengthSync(),
      //           filename: "image_gallery[$i]",
      //           // contentType: MediaType(type, extension),
      //         ) );
      //     // imageGallery = await http.MultipartFile.fromPath(
      //     //     'image_gallery[$i]', createItemModel.imageGallery![i].toString());
      //     // requset.files.add(imageGallery);
      //   }
      //
      // }else{
      //   ("from previos imeags ::::");
      //   requset.fields
      //       .addAll({"image_gallery[]" : AddWorkOrAdsController.to.imageGallery.toString() ?? ""});
      // }
      if (ImagePickerController.to.image_file != null) {
        Image? image_temp = decodeImage(
            await ImagePickerController.to.image_file!.readAsBytes());

        Image resized_img = copyResize(image_temp!, width: 800, height: 800);

        File resized_file = File(ImagePickerController.to.image_file!.path)
          ..writeAsBytesSync(encodeJpg(resized_img));

        var stream = new http.ByteStream(resized_file.openRead());
        var length = await resized_file.length();

        requset.files.add(
            http.MultipartFile('feature_image', stream, length,
                filename: basename("test"))
        );
        // http.MultipartFile(
        //   'feature_image',
        //   ImagePickerController.to.image_file!.readAsBytes().asStream(),
        //   await ImagePickerController.to.image_file!.length(),
        //   // file.lengthSync(),
        //   filename: "test",
        //   // contentType: MediaType(type, extension),
        // ),

        // );
        // var featureImage = await http.MultipartFile.fromPath(
        //     'feature_image', createItemModel.featureImage!);
        // requset.files.add(featureImage);
      }
      // if (ImagePickerController.to.menuFile != null) {
      //   requset.files.add(
      //       http.MultipartFile.fromBytes(
      //           'pdf',
      //           File(createItemModel.menuFile!).readAsBytesSync(),
      //           filename: createItemModel.menuFile!.split("/").last
      //       )
      //   );
        // var featureImage = await http.MultipartFile.fromPath(
        //     'pdf', createItemModel.menuFile!,);
        // requset.files.add(featureImage);
        // requset.files.add(
        //     http.MultipartFile(
        //         'pdf',
        //         File(createItemModel.menuFile!).readAsBytes().asStream(),
        //         File(createItemModel.menuFile!).lengthSync(),
        //         filename: createItemModel.menuFile!.split("/").last
        //     ));

      // }
      if (ImagePickerController.to.images != null) {
        if (createItemModel.imageGallery != null &&
            createItemModel.imageGallery!.isNotEmpty) {
          var imageGallery;


          ("we are here from upload gallery");
          for (int i = 0; i < createItemModel.imageGallery!.length; i++) {
            Image? image_temp = decodeImage(
                await ImagePickerController.to.images![i]!.readAsBytes());

            Image resized_img = copyResize(
                image_temp!, width: 800, height: 800);

            File resized_file = File(ImagePickerController.to.images![i]!.path)
              ..writeAsBytesSync(encodeJpg(resized_img));

            var stream = new http.ByteStream(resized_file.openRead());
            var length = await resized_file.length();
            requset.files.add(
                http.MultipartFile('image_gallery[$i]', stream, length,
                    filename: basename("image_gallery[$i]"))
            );
            // requset.files.add(
            //     http.MultipartFile(
            //       'image_gallery[$i]',
            //       ImagePickerController.to.images![i].readAsBytes().asStream(),
            //       await ImagePickerController.to.images![i].length(),
            //       // file.lengthSync(),
            //       filename: "image_gallery[$i]",
            //       // contentType: MediaType(type, extension),
            //     )
            // )
            // ;
            // imageGallery = await http.MultipartFile.fromPath(
            //     'image_gallery[$i]', createItemModel.imageGallery![i].toString());
            // requset.files.add(imageGallery);
          }
        }
      }


      if (checkBox.isNotEmpty) {
        for (int i = 0; i <= checkBox.length - 1; i++) {
          for (int t = 0; t <= myField.length - 1; t++) {
            if (checkBox[i][1] == myField[t]) {
              for (int o = 0;
              o <= {checkBox[i][1] == myField[t]}.length - 1;
              o++) {
                requset.fields['${customFileds![t]}[$o]'] = checkBox[i][0];
                // ('${customFileds[t]}[$o]=>${checkBox[i][0]}');
              }

              // requset.fields['${checkBox[i][2]}${checkBox[1]}'] =
              //     checkBox[i][0].toString();
            }
          }
        }
      }

      if (textFiled.isNotEmpty) {
        for (int i = 0; i <= textFiled.length - 1; i++) {
          for (int t = 0; t <= myField.length - 1; t++) {
            if (textFiled[i][1] == myField[t]) {
              requset.fields['${customFileds![t]}'] =
                  textFiled[i][0].toString();
              // ('${customFileds[t]}=${textFiled[i][0]}');
            }
          }

          // requset.fields['${textFiled[i][2]}${textFiled[1]}'] =
          //     textFiled[i][0].toString();
          // ('${textFiled[i][2]}${textFiled[i][1]}== ${textFiled[i][0]}');
        }
      }
      requset.fields['menu'] = createItemModel.menuLink ?? "";

      requset.fields['item_type'] = createItemModel.itemType.toString();
      requset.fields['item_featured'] = createItemModel.itemFeatured.toString();
      requset.fields['item_title'] = createItemModel.itemTitle!;
      requset.fields['city_id'] = createItemModel.cityId!;
      if (createItemModel.itemAddress != null &&
          createItemModel.itemAddress!.isNotEmpty) {
        requset.fields['item_address'] = createItemModel.itemAddress.toString();
      }
      requset.fields['state_id'] = createItemModel.stateId.toString();
      requset.fields['country_id'] = createItemModel.countryId.toString();
      requset.fields['item_postal_code'] =
          createItemModel.itemPostalCode.toString();
      for (int i = 0; i < createItemModel.category.length; i++) {
        requset.fields['category[$i]'] = createItemModel.category[i].toString();
      }

      if (createItemModel.itemHours.isNotEmpty) {
        for (int i = 0; i < createItemModel.itemHours.length; i++) {

          // ("Item Hours :: ${createItemModel.itemHours[i].toString()}");
          requset.fields['item_hours[$i]'] =
              createItemModel.itemHours[i].toString();
        }


      }

      if (createItemModel.price != null) {
        requset.fields['price'] = createItemModel.price!;
      }

      if (createItemModel.itemDescription != null) {
        requset.fields['item_description'] = createItemModel.itemDescription!;
      }
      if (createItemModel.itemLat != null && createItemModel.itemLng != null) {
        requset.fields['item_lat'] = createItemModel.itemLat!.toString();
        requset.fields['item_lng'] = createItemModel.itemLng!.toString();
      }

      if (createItemModel.itemWebsite != null) {
        requset.fields['item_website'] = createItemModel.itemWebsite!;
      }
      if (createItemModel.itemPhone != null) {
        requset.fields['item_phone'] = createItemModel.itemPhone!;
      }
      if (createItemModel.itemSocialFacebook != null) {
        requset.fields['item_social_facebook'] =
        createItemModel.itemSocialFacebook!;
      }
      if (createItemModel.itemSocialTwitter != null) {
        requset.fields['item_social_twitter'] =
        createItemModel.itemSocialTwitter!;
      }
      if (createItemModel.itemSocialLinkedin != null) {
        requset.fields['item_social_linkedin'] =
        createItemModel.itemSocialLinkedin!;
      }
      if (createItemModel.itemYoutubeId != null) {
        requset.fields['item_youtube_id'] = createItemModel.itemYoutubeId!;
      }
      if (createItemModel.itemHourTimeZone != null) {
        // requset.fields['item_hour_time_zone'] = createItemModel.itemHourTimeZone!;
        requset.fields['item_hour_time_zone'] = "Europe/Istanbul";
        // Europe/Istanbul
      }
      if (createItemModel.itemHourShowHours != null) {
        requset.fields['item_hour_show_hours'] =
            createItemModel.itemHourShowHours!.toString();
      }
      if (createItemModel.itemSocialWhatsapp != null) {
        requset.fields['item_social_whatsapp'] =
        createItemModel.itemSocialWhatsapp!;
      }
      if (createItemModel.itemSocialInstagram != null) {
        requset.fields['item_social_instagram'] =
        createItemModel.itemSocialInstagram!;
      }

      var response = await requset.send();
      final respStr = await response.stream.bytesToString();

      // ("RESPONSE::::: ${respStr}");
      // (response.statusCode);
      // response.stream.transform(utf8.decoder).listen((value) {
      //   (value);
      // });

      if (response.statusCode == 200) {
        // var response2 = await http.Response.fromStream(response);
        // var json = jsonDecode(response2.body);
      return true;
      }
      //   // ("Response After Add:::: ${json}");
      //   // var resIdOld = json['data']['id'].toString();
      //
      //   // if(AddWorkOrAdsController.to.resId.isNotEmpty){
      //   //
      //   // }else{
      //   //   if(AddWorkOrAdsController.to.items.isNotEmpty){
      //   //     Map map =  await MenuApiController().registerVendor(phone: createItemModel.itemPhone ?? "", vendorName: createItemModel.itemTitle ?? "");
      //   //     // ("Length categories::: ${AddWorkOrAdsController.to.categories.length}");
      //   //     ("resId:: ${map['id']}");
      //   //
      //   //     var  uri3 = Uri.parse(
      //   //         '${ApiKey.addList}${resIdOld}/update-item');
      //   //     var requset3 = http.MultipartRequest('POST', uri3);
      //   //     Map<String, String> headers = {
      //   //       "Content-type": "multipart/form-data",
      //   //       "Accept": "application/json"
      //   //     };
      //   //     if (ImagePickerController.to.image_file != null) {
      //   //       Image? image_temp = decodeImage(
      //   //           await ImagePickerController.to.image_file!.readAsBytes());
      //   //
      //   //       Image resized_img = copyResize(image_temp!, width: 800, height: 800);
      //   //
      //   //       File resized_file = File(ImagePickerController.to.image_file!.path)
      //   //         ..writeAsBytesSync(encodeJpg(resized_img));
      //   //
      //   //       var stream = new http.ByteStream(resized_file.openRead());
      //   //       var length = await resized_file.length();
      //   //
      //   //       requset3.files.add(
      //   //           http.MultipartFile('feature_image', stream, length,
      //   //               filename: basename("test"))
      //   //       );
      //   //       if (ImagePickerController.to.images != null) {
      //   //         if (createItemModel.imageGallery != null &&
      //   //             createItemModel.imageGallery!.isNotEmpty) {
      //   //           var imageGallery;
      //   //
      //   //
      //   //           ("we are here from upload gallery");
      //   //           for (int i = 0; i < createItemModel.imageGallery!.length; i++) {
      //   //             Image? image_temp = decodeImage(
      //   //                 await ImagePickerController.to.images![i]!.readAsBytes());
      //   //
      //   //             Image resized_img = copyResize(
      //   //                 image_temp!, width: 800, height: 800);
      //   //
      //   //             File resized_file = File(
      //   //                 ImagePickerController.to.images![i]!.path)
      //   //               ..writeAsBytesSync(encodeJpg(resized_img));
      //   //
      //   //             var stream = new http.ByteStream(resized_file.openRead());
      //   //             var length = await resized_file.length();
      //   //             requset3.files.add(
      //   //                 http.MultipartFile('image_gallery[$i]', stream, length,
      //   //                     filename: basename("image_gallery[$i]"))
      //   //             );
      //   //             // requset.files.add(
      //   //             //     http.MultipartFile(
      //   //             //       'image_gallery[$i]',
      //   //             //       ImagePickerController.to.images![i].readAsBytes().asStream(),
      //   //             //       await ImagePickerController.to.images![i].length(),
      //   //             //       // file.lengthSync(),
      //   //             //       filename: "image_gallery[$i]",
      //   //             //       // contentType: MediaType(type, extension),
      //   //             //     )
      //   //             // )
      //   //             // ;
      //   //             // imageGallery = await http.MultipartFile.fromPath(
      //   //             //     'image_gallery[$i]', createItemModel.imageGallery![i].toString());
      //   //             // requset.files.add(imageGallery);
      //   //           }
      //   //         }
      //   //       }
      //   //     }
      //   //
      //   //     if (checkBox.isNotEmpty) {
      //   //       for (int i = 0; i <= checkBox.length - 1; i++) {
      //   //         for (int t = 0; t <= myField.length - 1; t++) {
      //   //           if (checkBox[i][1] == myField[t]) {
      //   //             for (int o = 0;
      //   //             o <= {checkBox[i][1] == myField[t]}.length - 1;
      //   //             o++) {
      //   //               requset3.fields['${customFileds![t]}[$o]'] = checkBox[i][0];
      //   //               ('${customFileds[t]}[$o]=>${checkBox[i][0]}');
      //   //             }
      //   //
      //   //             // requset.fields['${checkBox[i][2]}${checkBox[1]}'] =
      //   //             //     checkBox[i][0].toString();
      //   //           }
      //   //         }
      //   //       }
      //   //     }
      //   //
      //   //     if (textFiled.isNotEmpty) {
      //   //       for (int i = 0; i <= textFiled.length - 1; i++) {
      //   //         for (int t = 0; t <= myField.length - 1; t++) {
      //   //           if (textFiled[i][1] == myField[t]) {
      //   //             requset3.fields['${customFileds![t]}'] =
      //   //                 textFiled[i][0].toString();
      //   //             ('${customFileds[t]}=${textFiled[i][0]}');
      //   //           }
      //   //         }
      //   //
      //   //         // requset.fields['${textFiled[i][2]}${textFiled[1]}'] =
      //   //         //     textFiled[i][0].toString();
      //   //         // ('${textFiled[i][2]}${textFiled[i][1]}== ${textFiled[i][0]}');
      //   //       }
      //   //     }
      //   //     // requset.fields['menu'] = createItemModel.menuLink ?? "";
      //   //
      //   //     requset3.fields['item_type'] = createItemModel.itemType.toString();
      //   //     requset3.fields['item_featured'] =
      //   //         createItemModel.itemFeatured.toString();
      //   //     requset3.fields['item_title'] = createItemModel.itemTitle!;
      //   //     requset3.fields['city_id'] = createItemModel.cityId!;
      //   //     if (createItemModel.itemAddress != null &&
      //   //         createItemModel.itemAddress!.isNotEmpty) {
      //   //       requset3.fields['item_address'] =
      //   //           createItemModel.itemAddress.toString();
      //   //     }
      //   //     requset3.fields['state_id'] = createItemModel.stateId.toString();
      //   //     requset3.fields['country_id'] = createItemModel.countryId.toString();
      //   //     requset3.fields['item_postal_code'] =
      //   //         createItemModel.itemPostalCode.toString();
      //   //     requset3.headers.addAll(headers);
      //   //     for (int i = 0; i < createItemModel.category.length; i++) {
      //   //       requset3.fields['category[$i]'] =
      //   //           createItemModel.category[i].toString();
      //   //     }
      //   //     if (createItemModel.itemHours.isNotEmpty) {
      //   //       for (int i = 0; i < createItemModel.itemHours.length; i++) {
      //   //         requset3.fields['item_hours[$i]'] =
      //   //             createItemModel.itemHours[i].toString();
      //   //       }
      //   //     }
      //   //
      //   //     if (createItemModel.price != null) {
      //   //       requset3.fields['price'] = createItemModel.price!;
      //   //     }
      //   //
      //   //     if (createItemModel.itemDescription != null) {
      //   //       requset3.fields['item_description'] =
      //   //       createItemModel.itemDescription!;
      //   //     }
      //   //     if (createItemModel.itemLat != null &&
      //   //         createItemModel.itemLng != null) {
      //   //       requset3.fields['item_lat'] = createItemModel.itemLat!.toString();
      //   //       requset3.fields['item_lng'] = createItemModel.itemLng!.toString();
      //   //     }
      //   //
      //   //     if (createItemModel.itemWebsite != null) {
      //   //       requset3.fields['item_website'] = createItemModel.itemWebsite!;
      //   //     }
      //   //     if (createItemModel.itemPhone != null) {
      //   //       requset3.fields['item_phone'] = createItemModel.itemPhone!;
      //   //     }
      //   //     if (createItemModel.itemSocialFacebook != null) {
      //   //       requset3.fields['item_social_facebook'] =
      //   //       createItemModel.itemSocialFacebook!;
      //   //     }
      //   //     if (createItemModel.itemSocialTwitter != null) {
      //   //       requset3.fields['item_social_twitter'] =
      //   //       createItemModel.itemSocialTwitter!;
      //   //     }
      //   //     if (createItemModel.itemSocialLinkedin != null) {
      //   //       requset3.fields['item_social_linkedin'] =
      //   //       createItemModel.itemSocialLinkedin!;
      //   //     }
      //   //     if (createItemModel.itemYoutubeId != null) {
      //   //       requset3.fields['item_youtube_id'] = createItemModel.itemYoutubeId!;
      //   //     }
      //   //     if (createItemModel.itemHourTimeZone != null) {
      //   //       // requset.fields['item_hour_time_zone'] = createItemModel.itemHourTimeZone!;
      //   //       requset3.fields['item_hour_time_zone'] = "Europe/Istanbul";
      //   //       // Europe/Istanbul
      //   //     }
      //   //     if (createItemModel.itemHourShowHours != null) {
      //   //       requset3.fields['item_hour_show_hours'] =
      //   //           createItemModel.itemHourShowHours!.toString();
      //   //     }
      //   //     if (createItemModel.itemSocialWhatsapp != null) {
      //   //       requset3.fields['item_social_whatsapp'] =
      //   //       createItemModel.itemSocialWhatsapp!;
      //   //     }
      //   //     if (createItemModel.itemSocialInstagram != null) {
      //   //       requset3.fields['item_social_instagram'] =
      //   //       createItemModel.itemSocialInstagram!;
      //   //     }
      //   //     requset3.fields['vendor_id'] = map["id"].toString();
      //   //     // if(AddWorkOrAdsController.to.items.isNotEmpty){
      //   //     //   // requset3.fields['menu'] = map["url"];
      //   //     // }
      //   //     var response3 = await requset3.send();
      //   //
      //   //     ("Updated Code ::: ${response3.statusCode}");
      //   //     // (response3.body);
      //   //
      //   //
      //   //     var s = await http.Response.fromStream(response3);
      //   //     var json2 = jsonDecode(s.body);
      //   //     ("JSON:::: ${json2}");
      //   //     if(response3.statusCode == 200){
      //   //       ("Updated");
      //   //     }
      //   //
      //   //
      //   //     ("Options::::: ${AllMenusGetxController.to.optionsName}");
      //   //     (AllMenusGetxController.to.options3);
      //   //     (AllMenusGetxController.to.options);
      //   //     (AllMenusGetxController.to.options2);
      //   //     ("VER:::: ${AllMenusGetxController.to.varents}");
      //   //     (AllMenusGetxController.to.varents2);
      //   //     ("Extra::: ${AllMenusGetxController.to.extras}");
      //   //     (AllMenusGetxController.to.extras2);
      //   //     // for(int i = 0; i < AddWorkOrAdsController.to.categories.length; i++){
      //   //     //   // try{
      //   //     //   AddCategory? add =  await MenuApiController().createCategories(resturentId: map["id"].toString(),
      //   //     //       categoryName: AddWorkOrAdsController.to.categories[i]);
      //   //     //
      //   //     //   // ("ID:::: ${add!.id.toString()}");
      //   //     //   if(add != null){
      //   //     //     String itemID = "";
      //   //     //     String optionId = "";
      //   //     //     ("Options name Len:::::${AllMenusGetxController.to.optionsName.length}");
      //   //     //     ("Length Items::: ${AddWorkOrAdsController.to.items.where((p0) => p0.categoryName ==  AddWorkOrAdsController.to.categories[i]).length}");
      //   //     //     for(int m = 0; m < AddWorkOrAdsController.to.items.where((p0) => p0.categoryName ==  AddWorkOrAdsController.to.categories[i]).length; m++ ) {
      //   //     //     itemID  = await  MenuApiController().createMenuItem(
      //   //     //           item: AddWorkOrAdsController.to.items.where((p0) => p0
      //   //     //               .categoryName == AddWorkOrAdsController.to.categories[i])
      //   //     //               .toList()[m], categoryId: add.id.toString());
      //   //     //     }
      //   //     //
      //   //     //
      //   //     //
      //   //     //
      //   //     //
      //   //     //
      //   //     //
      //   //     //
      //   //     //   }
      //   //     //   // }catch(e){
      //   //     //   //  ("Eror :: ${e.toString()}");
      //   //     //   // }
      //   //     // }
      //   //   }
      //   // }
      //   return true;
      // }
      //
      // ("Fildes::: ${requset.fields}");
      // ("error response::: ${respStr}");
      (response.statusCode);
      return false;
    } catch (e) {
      ("Error :::::::: $e");
    Get.back();
    return false;
    }
    // (uri);

  }
}
