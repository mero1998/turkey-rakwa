import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:rakwa/Core/services/dialogs.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/api/api_controllers/list_api_controller.dart';
import 'package:rakwa/controller/app_interface_getx_controller.dart';
import 'package:rakwa/controller/custom_field_getx_controller.dart';
import 'package:rakwa/model/add_item.dart';
import 'package:rakwa/model/app_interface.dart';
import 'package:rakwa/model/city_model.dart';
import 'package:rakwa/model/country_model.dart';
import 'package:rakwa/model/create_item_model.dart';
import 'package:rakwa/model/terms.dart';
import 'package:rakwa/screens/accept_terms_screen.dart';
import 'package:rakwa/screens/add_listing_screens/add_list_address_screen.dart';
import 'package:rakwa/screens/add_listing_screens/add_list_images_screen.dart';
import 'package:rakwa/screens/add_listing_screens/add_list_menu_screen.dart';
import 'package:rakwa/screens/add_listing_screens/add_list_social_information_screen.dart';
import 'package:rakwa/screens/add_listing_screens/add_list_title_screen.dart';
import 'package:rakwa/screens/add_listing_screens/add_list_work_days_screen.dart';
import 'package:rakwa/screens/add_listing_screens/done_screen.dart';
import 'package:rakwa/widget/SnackBar/custom_snack_bar.dart';

import '../../../controller/home_getx_controller.dart';
import '../../../model/all_categories_model.dart';
import '../../../model/paid_items_model.dart';

class AddWorkOrAdsController extends GetxController {

  static AddWorkOrAdsController get to => Get.find();


  final bool isList;
  RxList<String> gallery = <String>[].obs;

  RxString wodkId = "".obs;
  // RxString vId = "".obs;
  RxString resId = "".obs;
  RxString adId = "".obs;
  RxBool edit = false.obs;
  RxList<String> categories = <String>[].obs;
  RxList<AddItem> items = <AddItem>[].obs;
  RxList<TermsUser> terms = <TermsUser>[].obs;

  List<String> daysString = [
    "السبت",
    "الاحد",
    "الاثنين",
    "الثلاثاء",
    "الاربعاء",
    "الخميس",
    "الجمعة",
  ];
  RxList days = [
    [
      'السبت',
      false,
      TimeOfDay(hour: 6, minute: 30),
      TimeOfDay(hour: 16, minute: 30),
      '6'
    ],
    [
      'الاحد',
      false,
      TimeOfDay(hour: 6, minute: 30),
      TimeOfDay(hour: 16, minute: 30),
      '7'
    ],
    [
      'الاثنين',
      false,
      TimeOfDay(hour: 6, minute: 30),
      TimeOfDay(hour: 16, minute: 30),
      '1'
    ],
    [
      'الثلاثاء',
      false,
      TimeOfDay(hour: 6, minute: 30),
      TimeOfDay(hour: 16, minute: 30),
      '2'
    ],
    [
      'الاربعاء',
      false,
      TimeOfDay(hour: 6, minute: 30),
      TimeOfDay(hour: 16, minute: 30),
      '3'
    ],
    [
      'الخميس',
      false,
      TimeOfDay(hour: 6, minute: 30),
      TimeOfDay(hour: 16, minute: 30),
      '4'
    ],
    [
      'الجمعة',
      false,
      TimeOfDay(hour: 6, minute: 30),
      TimeOfDay(hour: 16, minute: 30),
      '5'
    ],
  ].obs;
  RxList<AllCategoriesModel> category = <AllCategoriesModel>[].obs;
  RxList<AllCategoriesModel> subCategory = <AllCategoriesModel>[].obs;
  RxList<AllCategoriesModel> clssifiedCategory = <AllCategoriesModel>[].obs;
  RxList<AllCategoriesModel> subClssifiedCategory = <AllCategoriesModel>[].obs;
  RxBool isLoading = true.obs;
  RxString selectedCategory = "".obs;
  RxInt selectedCategoryID = 0.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Future.delayed(Duration.zero,()async{
      getCategory();
      getClassifiedCategory();
      getTerms();
    });

    // getDates();
    // setMap();
  }


  getTerms() async{
    isLoading.value = true;
    terms.value = await ListApiController().getTerms();
    isLoading.value = false;

  }
  Future<void> getCategory() async {
    isLoading.value = true;
    print("we are here");
    category.value = await ListApiController().getCategory();

    if(edit.value){

    }
    isLoading.value = false;
  }

  Future<void> getSubCategory({required String id}) async {
    isLoading.value = true;

    var data = await ListApiController().getSubCategory(id: id);
    if (data.isNotEmpty) {
      subCategory.addAll(data);
      isLoading.value = false;

    } else {

      subCategory .value= [];
      isLoading.value = false;

      // itemSubCategryStatus = 3;
    }

    update();
  }

  Future<void> getClassifiedCategory() async {
    isLoading.value = true;

    clssifiedCategory.value = await ListApiController().getClassifiedCategory();
    isLoading.value = false;

  }

  Future<void> getSubClassfiedCategory({required int id}) async {
    isLoading.value = true;
    subClssifiedCategory.clear();
    var data = await ListApiController().getClassifiedSubCategory(id: id);
    if (data.isNotEmpty) {
      subClssifiedCategory.addAll(data);
      isLoading.value = false;
    } else {
      subClssifiedCategory .value= [];
      isLoading.value = false;
      // itemSubCategryStatus = 3;
    }

    update();
  }

  AddWorkOrAdsController({required this.isList}); //Category Data
  int parentCategory = -1;

  void setParentCategory(int id) {
    parentCategory = id;
    selectedCategoriesIds.clear();
    printDM("parentCategory is => $parentCategory");
  }

  //Category Data
  List<int> selectedCategoriesIds = [];
  List<int> categoriesIds = [];
  List<int> selectedSubCategoriesIds = [];

  void setCategoriesIds(int id) {
    if (selectedCategoriesIds.contains(id)) {
      selectedCategoriesIds.remove(id);
      update();
    } else {
      selectedCategoriesIds.add(id);
   update();
    }
    if (isList) {
      update(["update_categories_ids"]);
      printDM(
          "isList $isList selectedSubCategoriesIds is => $selectedCategoriesIds");
    } else {
      update(["update_Classified_categories_ids"]);
      printDM(
          "isList $isList selectedSubCategoriesIds is => $selectedCategoriesIds");
    }
  }


  void setSubCategoriesIds(int id) {
    if (selectedSubCategoriesIds.contains(id)) {
      selectedSubCategoriesIds.remove(id);
    } else {
      selectedSubCategoriesIds.add(id);
    }
    if (isList) {
      update(["update_categories_ids"]);
      printDM(
          "isList $isList selectedSubCategoriesIds is => $selectedCategoriesIds");
    } else {
      update(["update_Classified_categories_ids"]);
      printDM(
          "isList $isList selectedSubCategoriesIds is => $selectedCategoriesIds");
    }
  }

  void navigationAfterSelectSubCategories() {
    print("ISLIST::: ${isList}");
    Get.off(
      () => edit.value && resId.isEmpty && isList ?
      AcceptTermsScreen()
          : edit.value ? AddListTitleScreen(
          isList: isList,): selectedCategory.value == "مطاعم" ?  AcceptTermsScreen(): AddListTitleScreen(
        isList: isList,
      ),
    );
    _getCustomField();
    printDM("selectedSubID is $selectedCategoriesIds");
  }

  // Get Custom Field
  final GetCustomFieldController _getCustomFieldController =
      Get.put(GetCustomFieldController());

  void _getCustomField() async {
    printDM("_getCustomField is called ");
    await _getCustomFieldController.getCustom(
        isList: isList, categoryIds: selectedCategoriesIds);
  }

  //add job title & description
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void navigationAfterAddJopTitleAndDescription(
      GlobalKey<FormState> globalKey) {
    if (globalKey.currentState!.validate()) {
      globalKey.currentState!.save();
      Get.to(
        () => AddListAddressScreen(
          isList: isList,
        ),
      );
    }
  }

  // add address
  TextEditingController locationController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  int countryID = 0;

  void setCountryID(CountryModel country) {
    countryID = country.id ?? -1;
    countryController.text = country.countryName ?? "";
    _refreshStateAndCityData();
    update(['update_address_screen']);
  }

  void _refreshStateAndCityData() {
    stateID = 0;
    stateController.clear();
    cityID = 0;
    cityController.clear();
  }

  int stateID = 0;

  void setStateID(StateModel state) {
    stateID = state.id;
    stateController.text = state.stateName;
    _refreshCityData();
    update(['update_address_screen']);
  }

  void _refreshCityData() {
    cityID = 0;
    cityController.clear();
  }

  int cityID = 0;

  void setCity(CityModel city) {
    cityID = city.id;
    cityController.text = city.cityName;
    update(['update_address_screen']);
  }

  double lat = 41.8781;
  double lng = -87.6298;

  void navigationAfterAddAddress(
      GlobalKey<FormState> globalKey) {
    // lat = lat;
    // lng = lng;

    print(lat);
    print(lng);
    if (globalKey.currentState!.validate()) {
      globalKey.currentState!.save();
      if (isList) {
        Get.to(
          () => AddListWorkDaysScreen(
            isList: isList,
          ),
        );
      } else {
        Get.to(
          () => AddListImagesScreen(
            isList: isList,
          ),
        );
      }
    }
  }

  //add Work Day
  List<dynamic> itemHours = [];

  void setItemHours(dynamic itemHour) {}

  TextEditingController priceController = TextEditingController();

  void navigationAfterAddWorkDay(GlobalKey<FormState> globalKey) {
    printDM("itemHours is ${itemHours}");
    if (isList) {
      Get.to(
        () => AddListImagesScreen(
          isList: isList,
        ),
      );
    } else {
      if (isList) {
        Get.to(() => AddListImagesScreen(
              isList: isList,
            ));
      } else {
        if (globalKey.currentState!.validate()) {
          globalKey.currentState!.save();
          Get.to(
            () => AddListImagesScreen(
              isList: isList,
            ),
          );
        }
      }
    }
  }

  // add image
  String? featureImage = '';
  String? menuFile = '';
  List<dynamic> imageGallery = [];
  List<XFile> imageGalleryFile = [];

  void navigationAfterAddImages() {
    Get.to(
      () => selectedCategory.value == "مطاعم" && edit.value ? AddListMenuScreen(isList: isList)
          : selectedCategory.value == "مطاعم" ? AddListMenuScreen(isList: isList)
          : AddListSocialInformationScreen(
        isList: isList,
      ),
    );
  }
  void navigationAfterAddMenu() {
    Get.to(
          () => AddListSocialInformationScreen(
        isList: isList,
      ),
    );
  }
  TextEditingController menuController = TextEditingController();

//add social media links
  TextEditingController phoneController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController twitterController = TextEditingController();
  TextEditingController linkedInController = TextEditingController();

  CreateItemModel get createItemModel {
    CreateItemModel createItemModel = CreateItemModel();
    createItemModel.itemType = '1';
    createItemModel.itemFeatured = '0';
    createItemModel.itemPostalCode = '34515';
    createItemModel.itemHourShowHours = '1';
    createItemModel.category.addAll(selectedCategoriesIds);
    createItemModel.itemTitle = titleController.text;
    createItemModel.itemDescription = descriptionController.text;
    createItemModel.countryId = countryID.toString();
    createItemModel.stateId = stateID.toString();
    createItemModel.cityId = cityID.toString();
    createItemModel.itemLat = lat;
    createItemModel.itemLng = lng;
    createItemModel.itemAddress = locationController.text;
    createItemModel.itemHourTimeZone = locationController.text;
    // createItemModel.menuFile = menuFile;
    // if()
    createItemModel.menuLink = menuController.text;
    if (isList) {
      createItemModel.itemHours = itemHours;
    } else {
      createItemModel.price = priceController.text;
    }
    createItemModel.featureImage = featureImage;
    createItemModel.menuFile = menuFile;
    createItemModel.imageGallery = imageGallery;
    if(facebookController.text.isNotEmpty){
      createItemModel.itemSocialFacebook = facebookController.text.startsWith("https://") ?  facebookController.text: "https://${facebookController.text}";
    }else{
      createItemModel.itemSocialFacebook = null;
    }
    if(instagramController.text.isNotEmpty){
      createItemModel.itemSocialInstagram = instagramController.text.startsWith("https://") ?  instagramController.text: "https://${instagramController.text}";
    }else{
      createItemModel.itemSocialInstagram=  null;
    }
    if(linkedInController.text.isNotEmpty){
      createItemModel.itemSocialLinkedin = linkedInController.text.startsWith("https://") ?  linkedInController.text: "https://${linkedInController.text}";
    }else{
      createItemModel.itemSocialLinkedin = null;
    }
    if(twitterController.text.isNotEmpty){
      createItemModel.itemSocialTwitter = twitterController.text.startsWith("https://") ?  twitterController.text: "https://${twitterController.text}";

    }else{
      createItemModel.itemSocialTwitter =  null;
    }
    if(websiteController.text.isNotEmpty){
      createItemModel.itemWebsite = websiteController.text.startsWith("https://") ?  websiteController.text: "https://${websiteController.text}";
    }else{
      createItemModel.itemWebsite = null;
    }
    createItemModel.itemSocialWhatsapp = phoneController.text;
    createItemModel.itemPhone = phoneController.text;
    // createItemModel.itemYoutubeId = websiteController.text;

    return createItemModel;
  }

// add work

  Future<bool> addWork(
      {required List<dynamic> checkBox,
      required List<dynamic> textFiled}) async {
    setLoading();

    print("Create Model${createItemModel.imageGallery}");
    print("Create Model${createItemModel.featureImage}");
    print("Create Model${createItemModel.itemSocialLinkedin}");
    print("Create Model${createItemModel.itemSocialTwitter}");
    print("Create Model${createItemModel.itemSocialInstagram}");
    print("Create Model${createItemModel.itemSocialFacebook}");
    print("Create Model${createItemModel.itemWebsite}");
    print("Create Model${createItemModel.itemAddress}");
    print("Create Model${createItemModel.itemDescription}");
    print("Create Model${createItemModel.itemTitle}");
    print("Create Model${createItemModel.itemPhone}");
    print("Create Model${createItemModel.itemFeatured}");
    print("Create Model${createItemModel.itemLat}");
    print("Create Model${createItemModel.itemLng}");
    print("Create Model Hours ${createItemModel.itemHours}");
    print("Create Model${createItemModel.itemYoutubeId}");
    print("Create Model${createItemModel.itemSocialWhatsapp}");
    print("Create Model${createItemModel.countryId}");
    print("Create Model${createItemModel.category}");
    print("Create Model${createItemModel.cityId}");
    print("Create Model${createItemModel.wifi3}");
    print("Create Model${createItemModel.price}");
    // print("File Create:::${createItemModel.menuFile}");

    bool status = await ListApiController().addList(
      checkBox: checkBox,
      textFiled: textFiled,
      createItemModel: createItemModel,
      customFileds: _getCustomFieldController.keysCustomFields,
      isList: isList,
      isUpdate: edit.value
    );
    Get.back();
    if (status) {
      _getCustomFieldController.refreshData();
      Get.offAll(
        () => DoneScreen(
          isList: isList,
        ),
      );
      Availability _availability = Availability.loading;
      final InAppReview _inAppReview = InAppReview.instance;
      // WidgetsBinding.instance.addObserver(this);
      (<T>(T? o) => o!)(WidgetsBinding.instance).addPostFrameCallback((_) async {

        try {
          final isAvailable = await _inAppReview.isAvailable();
          if(HomeGetxController.to.configs.isNotEmpty){
            if(HomeGetxController.to.configs.first.data!.application_review == "yes"){

              if(isAvailable){
                _inAppReview.requestReview();
              }
            }
          }

          print("IS Available:: ${isAvailable}");
            // This plugin cannot be tested on Android by installing your app
            // locally. See https://github.com/britannio/in_app_review#testing for
            // more information.
            _availability = isAvailable && !Platform.isAndroid
                ? Availability.available
                : Availability.unavailable;



            // _openStoreListing();
        } catch (_) {
          _availability = Availability.unavailable;
        }
      });
      return status;
    } else {
      customSnackBar(
        title: "حدث خطاء ما",
        subtitle: "برجاء المحاوله مره اخرى",
        isWarning: true,
      );
      return status;
    }
  }
}
