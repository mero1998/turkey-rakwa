import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/api/api_controllers/classified_api_controller.dart';
import 'package:rakwa/api/api_controllers/item_api_controller.dart';
import 'package:rakwa/api/api_controllers/search_api_controller.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/controller/search_item_controller.dart';
import 'package:rakwa/model/paid_items_model.dart';
import 'package:rakwa/screens/details_screen/details_classified_screen.dart';
import 'package:rakwa/screens/details_screen/details_screen.dart';
import 'package:rakwa/screens/search_screens/filter_screen.dart';
import 'package:rakwa/widget/TextFields/text_field_default.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:rakwa/widget/home_widget.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatefulWidget {
  final String? categoryId;
  final bool? isFilter;
  final bool isItem;

  const SearchScreen({super.key, this.categoryId, required this.isItem, this.isFilter});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String cityId = '';
  String stateId = '';
  String category = '';
  String subCategory = '';
  String classifiedcategories = '';
  bool isFilter = false;
  late TextEditingController _searchController;


  @override
  void initState() {
    super.initState();

    print("Category ::: ${widget.categoryId}");
    Get.put(SearchItemController());
    SearchItemController.to.isItem.value = widget.isItem;
    if(widget.categoryId != null){
      SearchItemController.to.categoryID.value = widget.categoryId!;

    }
    _searchController = TextEditingController();
    print('========================================${widget.categoryId}');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      // widget.categoryId == null
      //     ? SearchItemController.to.search(
      //   isItem: widget.isItem,
      //   query: _searchController.text,
      //   stateId: stateId,
      //   category: category,
      //   cityId: cityId,
      //   classifiedcategories: classifiedcategories,
      // )
      //     :
      if(isFilter == false){
        widget.isItem
            ?

        await  SearchItemController.to.searchItem(
            cityId: cityId,
            stateId: stateId,
            categoryId: widget.categoryId.toString(),
            classifiedcategories: classifiedcategories,
            query: _searchController.text,
            current_page: 1
        )
            :

        await  SearchItemController.to.searchClassified(
            cityId: cityId,
            stateId: stateId,
            category: widget.categoryId.toString(),
            classifiedcategories: widget.categoryId.toString(),
            query : _searchController.text,
            current_page: 1
        );
      }

      // SearchItemController.to.isLoading.value = false;

    });

  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final _form2Key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBars.appBarDefault(title: "البحث"),
      body: Column(
            children: [
              SizedBox(height: 10.h),

              searchAndFilterWidget(_form2Key),
               SizedBox(height: 20.h),
              GetX<SearchItemController>(
    builder: (c) {
     return  Expanded(
                child:  c.isLoading.value ? Shimmer.fromColors(
                    baseColor: Colors.grey.shade100,
                    highlightColor: Colors.grey.shade300,
                    child: Container(
                      margin:  EdgeInsets.only(left: 8.w),
                      height: 236.h,
                      width: Get.width * 0.9.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: Colors.white,
                      ),
                    )) : c.searchList.isEmpty ? Center(
                  child: Text('لا توجد اي عناصر '),
                ) :  Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    SizedBox(
                      height: 60.h,
                      child:  ListView.builder(
                          itemCount: c.classified.length,
                          padding: EdgeInsets.symmetric(horizontal: 10.w , vertical: 8.h),
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context,index){
                            return InkWell(
                              onTap: (){
                                c.selectedClassified.value = c.classified[index];
                                if(c.selectedClassified == c.classified[0]){

                                  c.selectedClassifiedID.value = "1";

                                }else if(c.selectedClassified == c.classified[1]){
                                  c.selectedClassifiedID.value = "2";

                                }else if(c.selectedClassified == c.classified[2]){
                                  c.selectedClassifiedID.value = "3";

                                }else if(c.selectedClassified == c.classified[3]){
                                  c.selectedClassifiedID.value = "4";

                                }else{
                                  c.selectedClassifiedID.value = "7";

                                }
                                // widget.categoryId == null
                                //     ? SearchItemController.to.search(
                                //   isItem: widget.isItem,
                                //   query: _searchController.text,
                                //   stateId: stateId,
                                //   category: SearchItemController.to.subCategoryID != 0 ?  SearchItemController.to.subCategoryID.toString(): widget.categoryId.toString(),
                                //   cityId: cityId,
                                //   classifiedcategories: classifiedcategories,
                                // )
                                //     :
                                SearchItemController.to.searchList.clear();


                                print("Lenght:: ${SearchItemController.to.searchList.length}");
                                widget.isItem
                                    ?

                                SearchItemController.to.searchItem(
                                  cityId: cityId,
                                    current_page: 1,
                                    stateId: stateId,
                                    categoryId: SearchItemController.to.subCategoryID != 0 ?  SearchItemController.to.subCategoryID.toString(): SearchItemController.to.categoryID.toString(),
                                  classifiedcategories: classifiedcategories,
                                  query: _searchController.text

                                )
                                    :

                                SearchItemController.to.searchClassified(
                                  cityId: cityId,
                                  stateId: stateId,
                                  category: widget.categoryId != null ? widget.categoryId! : "0",
                                  classifiedcategories: classifiedcategories,
                                  query: _searchController.text,
                                  current_page: 1
                                );

                              },
                              child: Container(
                                  height: 50.h,
                                  padding: EdgeInsets.symmetric(horizontal: 8.w ,vertical: 8.h),
                                  margin: EdgeInsetsDirectional.only(end: 5.w),
                                  decoration: BoxDecoration(
                                    color: c.selectedClassified == c.classified[index] ?  AppColors().mainColor : Colors.transparent,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Text(
                                    c.classified[index],
                                    style: GoogleFonts.notoKufiArabic(
                                      textStyle:  TextStyle(
                                        fontSize: 8.sp,
                                        fontWeight: FontWeight.w600,
                                        color: c.selectedClassified == c.classified[index] ? Colors.white : Colors.black
                                      ),
                                    ),
                                  )),
                            );

                          }
                      ),
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
       SizedBox(
         height: 10.h,),
                    Expanded(
                      child: ListView.separated(
                        controller:c.scroll,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        separatorBuilder: (context, index) =>  SizedBox(
                          height: 16.h,
                        ),
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: c.searchList.length,
                        itemBuilder: (context, index) {
                          return HomeWidget(
                              percentCardWidth: .9,
                              onTap: () {
                                Get.to(() => widget.isItem ? DetailsScreen(
                                    id: c.searchList[index].id.toString()) :DetailsClassifiedScreen(
                                id: c.searchList[index].id)) ;
                              },
                              discount: '25',
                              image: c.searchList[index].itemImage,
                              itemType: c.searchList[index].itemCategoriesString,
                              location:  c.searchList[index].itemDescription ?? "",
                              title: c.searchList[index].itemTitle,
                              rate:
                              c.searchList[index].itemAverageRating);
                        },
                      ),
                    ),

                    Visibility(
                        visible: c.loading.value,
                        child: Center(child: CircularProgressIndicator()))
                  ],
                ),
              );

              // Expanded(
              //   child: FutureBuilder<List<PaidItemsModel>>(
              //     future: widget.categoryId == null
              //         ? SearchApiController().search(
              //             isItem: widget.isItem,
              //             searchQuery: _searchController.text,
              //             stateId: stateId,
              //             category: category,
              //             cityId: cityId,
              //             classifiedcategories: classifiedcategories,
              //       sort: SearchController.to.selectedClassifiedID.value
              //           )
              //         : widget.isItem
              //             ?
              //             //  SearchApiController().search(
              //             //     searchQuery: _searchController.text,
              //             //     stateId: stateId,
              //             //     category: widget.searchNumber.toString(),
              //             //     cityId: cityId,
              //             //     classifiedcategories: '')
              //             ItemApiController().searchItem(
              //                 cityId: cityId,
              //                 stateId: stateId,
              //                 categoryId: widget.categoryId.toString(),
              //                 classifiedcategories: classifiedcategories,
              //                 sort: SearchController.to.selectedClassifiedID.value
              //
              //             )
              //             :
              //             //  SearchApiController().search(
              //             //     searchQuery: _searchController.text,
              //             //     stateId: stateId,
              //             //     category: '',
              //             //     cityId: cityId,
              //             //     classifiedcategories: widget.searchNumber.toString()),
              //
              //             ClassifiedApiController().searchClassified(
              //                 cityId: cityId,
              //                 stateId: stateId,
              //                 category: category,
              //                 classifiedcategories: widget.categoryId.toString(),
              //                 sort: SearchController.to.selectedClassifiedID.value
              //
              //             ),
              //     builder: (context, snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return Shimmer.fromColors(
              //             baseColor: Colors.grey.shade100,
              //             highlightColor: Colors.grey.shade300,
              //             child: Container(
              //               margin: const EdgeInsets.only(left: 8),
              //               height: 236,
              //               width: Get.width * 0.9,
              //               decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(12),
              //                 color: Colors.white,
              //               ),
              //             ));
              //       } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              //         return AnimationLimiter(
              //           child: Column(
              //             mainAxisSize: MainAxisSize.min,
              //             children: [
              //              SizedBox(
              //                height: 60.h,
              //                child: GetX<SearchController>(
              //                  builder: (c) {
              //                    print(c.classified);
              //                    print(c.selectedClassified);
              //                    return ListView.builder(
              //                        itemCount: c.classified.length,
              //                        padding: EdgeInsets.all(16),
              //                        physics: ScrollPhysics(),
              //                        shrinkWrap: true,
              //                        scrollDirection: Axis.horizontal,
              //                        itemBuilder: (context,index){
              //                      return InkWell(
              //                        onTap: (){
              //                            c.selectedClassified.value = c.classified[index];
              //                            if(c.selectedClassified == c.classified[0]){
              //
              //                              c.selectedClassifiedID.value = "1";
              //
              //                            }else if(c.selectedClassified == c.classified[1]){
              //                              c.selectedClassifiedID.value = "2";
              //
              //                            }else if(c.selectedClassified == c.classified[2]){
              //                              c.selectedClassifiedID.value = "3";
              //
              //                            }else if(c.selectedClassified == c.classified[3]){
              //                              c.selectedClassifiedID.value = "4";
              //
              //                            }else{
              //                              c.selectedClassifiedID.value = "7";
              //
              //                            }
              //                            widget.categoryId == null
              //                                ? SearchApiController().search(
              //                                isItem: widget.isItem,
              //                                searchQuery: _searchController.text,
              //                                stateId: stateId,
              //                                category: category,
              //                                cityId: cityId,
              //                                classifiedcategories: classifiedcategories,
              //                                sort: c.selectedClassifiedID.value
              //                            )
              //                                : widget.isItem
              //                                ?
              //                            //  SearchApiController().search(
              //                            //     searchQuery: _searchController.text,
              //                            //     stateId: stateId,
              //                            //     category: widget.searchNumber.toString(),
              //                            //     cityId: cityId,
              //                            //     classifiedcategories: '')
              //                            ItemApiController().searchItem(
              //                                cityId: cityId,
              //                                stateId: stateId,
              //                                categoryId: widget.categoryId.toString(),
              //                                classifiedcategories: classifiedcategories,
              //                                sort: c.selectedClassifiedID.value
              //
              //                            )
              //                                :
              //                            //  SearchApiController().search(
              //                            //     searchQuery: _searchController.text,
              //                            //     stateId: stateId,
              //                            //     category: '',
              //                            //     cityId: cityId,
              //                            //     classifiedcategories: widget.searchNumber.toString()),
              //
              //                            ClassifiedApiController().searchClassified(
              //                                cityId: cityId,
              //                                stateId: stateId,
              //                                category: category,
              //                                classifiedcategories: widget.categoryId.toString(),
              //                                sort: c.selectedClassifiedID.value
              //
              //                            );
              //
              //
              //                        },
              //                        child: Container(
              //                          height: 60.h,
              //                          padding: EdgeInsets.all(8),
              //                          margin: EdgeInsetsDirectional.only(end: 5.w),
              //                          decoration: BoxDecoration(
              //                            color: c.selectedClassified == c.classified[index] ?  AppColors().mainColor : Colors.transparent,
              //                            borderRadius: BorderRadius.circular(7),
              //                          ),
              //                          child: Text(
              //                            c.classified[index],
              //                        style: GoogleFonts.notoKufiArabic(
              //                        textStyle: const TextStyle(
              //                        fontSize: 12,
              //                        fontWeight: FontWeight.w600,
              //                        ),
              //                          ),
              //                        )),
              //                      );
              //                    });
              //                  }
              //                ),
              //              ),
              //               Expanded(
              //                 child: ListView.separated(
              //                   padding: EdgeInsets.zero,
              //                   separatorBuilder: (context, index) => const SizedBox(
              //                     height: 16,
              //                   ),
              //                   physics: const BouncingScrollPhysics(),
              //                   scrollDirection: Axis.vertical,
              //                   itemCount: snapshot.data!.length,
              //                   itemBuilder: (context, index) {
              //                     return AnimationConfiguration.staggeredList(
              //                       position: index,
              //                       duration: const Duration(milliseconds: 375),
              //                       child: SlideAnimation(
              //                         verticalOffset: 50.0,
              //                         child: FadeInAnimation(
              //                           child: HomeWidget(
              //                               percentCardWidth: .9,
              //                               onTap: () {
              //                                 Get.to(() => DetailsScreen(
              //                                     id: snapshot.data![index].id.toString()));
              //                               },
              //                               discount: '25',
              //                               image: snapshot.data![index].itemImage,
              //                               itemType: snapshot
              //                                   .data![index].itemCategoriesString,
              //                               location: snapshot.data![index].city != null
              //                                   ? snapshot.data![index].city!.cityName
              //                                   : '',
              //                               title: snapshot.data![index].itemTitle,
              //                               rate:
              //                                   snapshot.data![index].itemAverageRating),
              //                         ),
              //                       ),
              //                     );
              //                   },
              //                 ),
              //               ),
              //             ],
              //           ),
              //         );
              //       } else {
              //         return const Center(
              //           child: Text('لا توجد اي عناصر '),
              //         );
              //       }
              //     },
              //   ),
              // ),
      })
    ]));
  }

  Padding searchAndFilterWidget(GlobalKey<FormState> globalKey) {
    var node = FocusScope.of(context);

    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.kCTFEnableBorder),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFieldDefault(
                autofocus: true,
                hintSize: 10,

                hint: 'ابحث عن...',
                enableBorder: Colors.transparent,
                controller: _searchController,

                prefixIconData: Icons.search,
                onChanged: (p0) {




                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
                    // widget.categoryId == null
                    //     ?await SearchItemController.to.search(
                    //   isItem: widget.isItem,
                    //   query: _searchController.text,
                    //   stateId: stateId,
                    //   category: SearchItemController.to.subCategoryID != 0 ?  SearchItemController.to.subCategoryID.toString(): widget.categoryId.toString(),
                    //   cityId: cityId,
                    //   classifiedcategories: classifiedcategories,
                    // )
                    //     :
                    widget.isItem
                        ?

                await  SearchItemController.to.searchItem(
                        cityId: cityId,
                        stateId: stateId,
                        current_page: 1,
                        categoryId: SearchItemController.to.subCategoryID != 0 ?  SearchItemController.to.subCategoryID.toString(): SearchItemController.to.categoryID.toString(),
                        classifiedcategories: classifiedcategories,
                        query: p0

                    )
                        :

                    await  SearchItemController.to.searchClassified(
                      cityId: cityId,
                      stateId: stateId,
                      current_page: 1,
                      category: widget.categoryId != null ? widget.categoryId! : "0",
                      classifiedcategories: widget.categoryId.toString(),
                      query: p0,
                    );
                  });


                },
                onComplete: () {
                  node.unfocus();
                },
              ),
            ),
            IconButton(
              color: Colors.white,
              onPressed: () {
                node.unfocus();
                Get.to(() => FilterScreen(
                      isItem: widget.isItem,
                      categoryId: widget.categoryId == null ? 0: int.parse(widget.categoryId!),
                      cityId: 0,
                      classifiedCategoryId: 0,
                      stateId: 0,
                  subCategoryId: 0,
                  query: _searchController.text,
                    ))!.then((value) {
                      print("Value:: ${value}");
                      isFilter = value;

                });
              },
              icon: const Icon(
                Icons.filter_list_sharp,
                color: Colors.black,

              ),
            ),
          ],
        ),
      ),
    );
  }
}
