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
import 'package:rakwa/screens/details_screen/details_screen.dart';
import 'package:rakwa/widget/Buttons/button_default.dart';
import 'package:rakwa/widget/TextFields/text_field_default.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';

import '../../widget/home_widget.dart';

class CreateQuestionScreen extends StatefulWidget {
  const CreateQuestionScreen({super.key});

  @override
  State<CreateQuestionScreen> createState() => _CreateQuestionScreenState();
}

class _CreateQuestionScreenState extends State<CreateQuestionScreen> {

  final GlobalKey<FormState> key = GlobalKey<FormState>();

  late TextEditingController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
  return  Scaffold(
              appBar: AppBars.appBarDefault(title: "انشاء سؤال"),
              body: ListView(
                padding: EdgeInsetsDirectional.only(
                  top: 40.h,
                  start: 16.w,
                  end: 16.w
                ),
                children: [
                  Form(
                    key: key,
                  child: TextFieldDefault(
                    controller: controller,
                   errorText: "يرجى ادخال سؤالك",
                    hint: "اطرح سؤالك هنا",
                    upperTitle: "سؤالك",
                    maxLines: 4,
                  ),
              ),
                SizedBox(height: 10.h,),
                ButtonDefault(
                  title: "اضف سؤالك",
                onTap: (){
                    if(key.currentState!.validate()){
                      QuestionAndAnswerApiController().createQuestion(context ,question_title: controller.text);
                    }
                },
                )
                ],
              )
          );
  }
}
