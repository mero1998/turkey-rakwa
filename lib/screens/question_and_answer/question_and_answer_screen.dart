import 'package:flutter/material.dart';import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/api/api_controllers/item_api_controller.dart';
import 'package:rakwa/api/api_controllers/qustion_and_answer_api_controller.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/controller/notifcations_getx_controller.dart';
import 'package:rakwa/controller/questions_and_answer_getx_controller.dart';
import 'package:rakwa/model/item_by_id_model.dart';
import 'package:rakwa/model/like.dart';
import 'package:rakwa/screens/details_screen/details_screen.dart';
import 'package:rakwa/screens/question_and_answer/create_question_screen.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';
import 'package:rakwa/widget/TextFields/text_field_default.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';

import '../../widget/home_widget.dart';

class QuestionAndAnswerScreen extends StatefulWidget {
  const QuestionAndAnswerScreen({super.key});

  @override
  State<QuestionAndAnswerScreen> createState() => _QuestionAndAnswerScreenState();
}

class _QuestionAndAnswerScreenState extends State<QuestionAndAnswerScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(QuestionsAndAnswerGetxController());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<QuestionsAndAnswerGetxController>();
  }
  @override
  Widget build(BuildContext context) {
    return GetX<QuestionsAndAnswerGetxController>(
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.white,
              appBar: AppBars.appBarDefault(title: "سؤال وجواب"),

              floatingActionButton: FloatingActionButton(
                backgroundColor: AppColors().mainColor,
                child: Icon(Icons.add),
                onPressed: () => Get.to(CreateQuestionScreen()),
              ),
              body: controller.isLoading.value ?
              Center(child: CircularProgressIndicator(),)
                  : controller.questions.isEmpty ? Center(child: Text("لا يوجد أسئلة"),)
                  : SingleChildScrollView(
                // controller: controller.scroll,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () =>  Get.to(CreateQuestionScreen()),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: AlignmentDirectional.topEnd,
                              child: Text(
                                "اسال سؤالك من هنا",
                                style: GoogleFonts.notoKufiArabic(
                                    color: AppColors().mainColor,
                                    fontSize: 16.sp),
                              ),
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: controller.questions.first.questions!.length,
                        itemBuilder: (context, index){
                          RxList<bool> hide = RxList.generate(controller.questions.first.questions!.length, (i) => false);
                          RxList<TextEditingController> controllers = RxList.generate(controller.questions.first.questions!.length, (i) => TextEditingController());
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              SizedBox(height: 15.h,),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text("سؤال بواسطة ${controller.questions.first.questions![index].user!.name}" , style: GoogleFonts.notoKufiArabic(
                                color: AppColors.bottonNavBarColor),),
                              ),
                              Container(
                                // height: 100.h,
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.kCTFEnableBorder,
                                  borderRadius: BorderRadius.circular(7),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      offset: Offset(0,2),
                                      blurRadius: 12,
                                      // spreadRadius: 6
                                    )
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                controller.questions.first.questions![index].questionTitle ?? "",
                                                style: GoogleFonts.notoKufiArabic(
                                                    color: AppColors.bottonNavBarColor),
                                              ),
                                              // SizedBox(height: 7.h,),
                                              // Text(
                                              //   controller.questions.first.questions![index].questionTitle ?? "",
                                              //   style: GoogleFonts.notoKufiArabic(
                                              //       color: AppColors.drawerColor),
                                              // ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            controller.questions.first.questions![index].createdAt ?? "",
                                            style: GoogleFonts.notoKufiArabic(
                                                color: AppColors().mainColor,
                                                fontSize: 10.sp),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Text("اجابة",style: GoogleFonts.notoKufiArabic(
                                    //     color:    AppColors().mainColor, fontSize: 12),),
                                    TextFieldDefault(hint: "ادخل اجابتك",suffixIconData: Icons.send,controller: controllers[index],onSuffixTap: () async{
                                    bool success = await QuestionAndAnswerApiController().createAnswer(message: controllers[index].text, questionId: controller.questions.first.questions![index].id.toString());
                                    if(success){
                                      controllers[index].text = "";
                                    }
                                    }),
                                  ],
                                ),
                              ),
                              controller.answers[index].answer == null ? Container() :   ListView.builder(
                                shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount: controller.answers[index].answer!.length,
                                  itemBuilder: (context, i){
                                  if(controller.answers[index].user!.isNotEmpty){
                                    print(" IIDID${controller.answers[index].user![i].userId }");
                                    print(" IIDID${SharedPrefController().id}");
                                  }
                                    RxList<bool> editable = RxList.generate(controller.answers[index].answer!.length, (i) => false);
                                    RxList<TextEditingController> controllers2 = RxList.generate(controller.answers[index].answer!.length, (i) => TextEditingController());
                                    RxList<bool> hide2 = RxList.generate(controller.answers[index].answer!.length, (i) => false);
                                    RxList<bool> likes = RxList.generate(controller.answers[index].user!.length, (o) =>  controller.answers[index].user![o].userId == int.parse(SharedPrefController().id) ? true : false);
                                    RxList<TextEditingController> controllers3 = RxList.generate(controller.answers[index].answer!.length, (i) => TextEditingController());

                                    print("Edit:: ${editable.length}");
                                    print("Edit:: ${controller.answers[index].answer![i].id}");
                                    print("likes:: ${likes}");
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Text(controller.answers[index].answer![i].childId == null ? "جواب بواسطة ${controller.answers[index].answer![i].commenter!.name}" :  "جواب بواسطة ${controller.answers[index].answer![i].commenter!.name} رداً على ${controller.answers[index].answer!.where((element) {
                                            print("Element:: ${element.childId}");
                                            print(controller.answers[index].answer![i].id);
                                         return   element.id == controller.answers[index].answer![i].childId;

                                          }).first.commenter!.name}",
                                            style: GoogleFonts.notoKufiArabic(
                                              color: AppColors.bottonNavBarColor),),
                                        ),
                                       Obx(() => Visibility(
                                         visible: !editable.elementAt(i),
                                         replacement: Padding(
                                           padding: const EdgeInsets.all(16),
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.end,
                                             children: [
                                               IconButton(onPressed: (){
                                                 editable[i] =  !editable[i];

                                               }, icon: Icon(Icons.clear)),
                                               TextFieldDefault(
                                                 controller: controllers2[i],
                                                   hint: "ادخل تعديلك هنا",
                                               suffixIconData: Icons.send,
                                                 onSuffixTap: () async {
                                                 print(controller.answers[index].answer![i].id.toString());

                                                 bool success = await QuestionAndAnswerApiController().updateAnswer(message: controllers2[i].text, answerId: controller.answers[index].answer![i].id.toString());
                                                if(success){
                                                  editable[i] =  !editable[i];
                                                  controllers2[i].text = "";
                                                }
                                                 }

                                               ),
                                             ],
                                           ),
                                         ),
                                         child: Container(
                                             width: double.infinity,
                                             padding: EdgeInsets.all(15),
                                             margin: EdgeInsets.all(15),
                                             decoration: BoxDecoration(
                                                 color: Colors.white,
                                                 borderRadius: BorderRadius.circular(7)
                                             ),
                                             child: Column(
                                               crossAxisAlignment: CrossAxisAlignment.start,
                                               children: [
                                                 Row(
                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                   children: [
                                                     Expanded(
                                                       child: Text(controller.answers[index].answer![i].comment ?? "",style: GoogleFonts.notoKufiArabic(
                                                           color: AppColors.bottonNavBarColor),),
                                                     ),
                                                     SizedBox(width: 10.w,),
                                                     Column(
                                                       mainAxisAlignment: MainAxisAlignment.start,
                                                       children: [
                                                         Text("عدد الاعجابات",style: GoogleFonts.notoKufiArabic(
                                                             color: AppColors.drawerColor, fontSize: 12.sp),),
                                           GetX<QuestionsAndAnswerGetxController>(
                                                           builder: (c) {
                                                             return Text(c.answers[index].countLike![i].toString(),style: GoogleFonts.notoKufiArabic(
                                                                 color: AppColors.drawerColor, fontSize: 12.sp),);
                                                           }
                                                         ),
                                                       ],
                                                     )
                                                   ],
                                                 ),
                                                 Row(
                                                   children: [
                                                     InkWell(
                                                       onTap: () async{
                                                         if(likes.isNotEmpty){

                                                           if(likes[i]){
                                                             bool?  like = await QuestionAndAnswerApiController().dislike(answerId: controller.answers[index].user![i].id.toString());
                                                             if(like){
                                                               controller.answers[index].countLike![i]--;
                                                               print( controller.answers[index].countLike);
                                                               likes[i]  = !likes[i];
                                                             }
                                                           }else{
                                                             bool?  like = await QuestionAndAnswerApiController().like(answerId: controller.answers[index].answer![i].id.toString());
                                                             if(like){
                                                               controller.answers[index].countLike![i]++;
                                                               print( controller.answers[index].countLike);
                                                               likes[i]  = !likes[i];
                                                             }
                                                           }
                                                         }else{
                                                           likes.add(true);
                                                           bool?  like = await QuestionAndAnswerApiController().like(answerId: controller.answers[index].answer![i].id.toString());
                                                           if(like){
                                                             controller.answers[index].countLike![i]++;
                                                             print( controller.answers[index].countLike);
                                                             // likes[i]  = !likes[i];
                                                           }
                                                         }

                                                     },
                                                       child: Text(likes.isNotEmpty ? likes[i] ? "الغاء اعجابك" :"اعجاب" : "اعجاب",style: GoogleFonts.notoKufiArabic(
                                                           color: likes.isNotEmpty ? likes[i] ? AppColors().mainColor : AppColors.drawerColor : AppColors.drawerColor,
                                                           fontSize: 12.sp),),
                                                     ),
                                                     SizedBox(width: 10.w,),
                                                     InkWell(
                                                       onTap: () => hide2[i] = !hide2[i],
                                                       child: Text("رد",style: GoogleFonts.notoKufiArabic(
                                                           color: AppColors().mainColor,
                                                           fontSize: 12.sp),),
                                                     ),
                                                     SizedBox(width: 10.w,),

                                                     Visibility(
                                                       visible: controller.answers[index].answer![i].commenter!.id == int.parse(SharedPrefController().id),
                                                       child: Row(
                                                         children: [
                                                           InkWell(
                                                             onTap: () {
                                                                 editable[i] =  !editable[i];
                                                                 print(editable[i]);
                                                             },
                                                             child: Text("تعديل",style: GoogleFonts.notoKufiArabic(
                                                                 color: AppColors().mainColor,
                                                                 fontSize: 12.sp),),
                                                           ),
                                                           SizedBox(width: 10.w,),

                                                           InkWell(
                                                             onTap: ()async{
                                                               bool success = await QuestionAndAnswerApiController().deleteAnswer(answerId: controller.answers[index].answer![i].id.toString());
                                                               if(success){
                                                              int item = controller.answers[index].answer!.indexWhere((element) => element.id == controller.answers[index].answer![i].id);
                                                            print(item);
                                                              controller.answers[index].answer!.removeAt(item);
                                                               setState(() {

                                                               });
                                                               }
                                                             },
                                                             child: Text("حذف",style: GoogleFonts.notoKufiArabic(
                                                                 color: AppColors().mainColor,
                                                                 fontSize: 12.sp),),
                                                           ),
                                                         ],
                                                       ),
                                                     )
                                                   ],
                                                 ),
                                                 Visibility(
                                                     visible: hide2[i],
                                                     child: TextFieldDefault(hint: "ادخل ردك هنا",suffixIconData: Icons.send,controller: controllers3[i],
                                                     onSuffixTap: ()async{
                                                   bool success  = await QuestionAndAnswerApiController().replyAnswer(message: controllers3[i].text, answerId: controller.answers[index].answer![i].id.toString());
                                                   if(success){
                                                     controllers3[i].text = "";
                                                   }
                                                   },
                                                     ))

                                               ],
                                             )),
                                       ))  ,
                                      ],
                                    );
                              })
                            ],
                          );

                        }),
                        Visibility(
                            visible: controller.loading.value,
                            child: Center(child: CircularProgressIndicator(),)),
                      ],
                    ),
                  )
          );
        }
    );
  }
}
