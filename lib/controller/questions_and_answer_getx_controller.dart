import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/api/api_controllers/classified_api_controller.dart';
import 'package:rakwa/api/api_controllers/item_api_controller.dart';
import 'package:rakwa/api/api_controllers/list_api_controller.dart';
import 'package:rakwa/api/api_controllers/qustion_and_answer_api_controller.dart';
import 'package:rakwa/model/all_categories_model.dart';
import 'package:rakwa/model/classified_with_category.dart';
import 'package:rakwa/model/item_with_category.dart';
import 'package:rakwa/model/question_answers.dart';
import 'package:rakwa/model/questions.dart';

class QuestionsAndAnswerGetxController extends GetxController {

  static QuestionsAndAnswerGetxController get to => Get.find();
  RxList<Questions> questions = <Questions>[].obs;
  RxList<QuestionAnswers> answers = <QuestionAnswers>[].obs;
  RxBool isLoading = true.obs;
  bool getFirstData = false;
  bool lastPage = false;
  RxBool loading = false.obs;
  int page = 1;
  int index = 0;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
   await getQuestions();

    });
  }


  getQuestions() async{
    isLoading.value = true;
    Questions? question = await QuestionAndAnswerApiController().getQuestions(current_page: page);

    if(question != null) {
      questions.add(question);
      for(int i = 0; i < questions.first.questions!.length; i++){
        await getAnswers(questionId: questions.first.questions![i].id.toString());
      }

      isLoading.value = false;

    }
    // print(list.length);
    //   final bool emptyRepositories = list.isEmpty;
    //   if (!getFirstData && emptyRepositories) {
    //     isLoading.value = false;
    //
    //     // change(null, status: RxStatus.empty());
    //   }
    //   else if (getFirstData && emptyRepositories) {
    //     lastPage = true;
    //     isLoading.value = false;
    //
    //   } else {
    //     // isLoading.value = true;
    //     getFirstData = true;
    //
    //     questions.addAll(list);




          // print(answers.length);


      // }



    isLoading.value = false;

  }

  getAnswers({required String questionId}) async{
    isLoading.value = true;
    QuestionAnswers? answer = await QuestionAndAnswerApiController().getAnswers(questionId: questionId);
    if(answer != null){
      print("we are here::::");
      answers.add(answer);
      print(answers.length);
      isLoading.value = false;
    }
    isLoading.value = false;

  }

  // @override
  // Future<void> onEndScroll() async {
  //   // TODO: implement onEndScroll
  //   print("from scroll");
  //   if (!lastPage) {
  //     page += 1;
  //     loading.value = true;
  //     // List<Questions> list = await QuestionAndAnswerApiController()
  //     //     .getQuestions(
  //     //     current_page: page);
  //     //
  //     // final bool emptyRepositories = list.isEmpty;
  //     // if (!getFirstData && emptyRepositories) {
  //     //   isLoading.value = false;
  //     //
  //     //   // change(null, status: RxStatus.empty());
  //     // } else if (getFirstData && emptyRepositories) {
  //     //   lastPage = true;
  //     //   isLoading.value = false;
  //     // } else {
  //     //   // isLoading.value = true;
  //     //   getFirstData = true;
  //     //   questions.addAll(list);
  //     //   for (int i = 0; i < questions.length; i++) {
  //     //     await getAnswers(
  //     //         questionId: questions[i].id.toString());
  //     //   }
  //     // }
  //
  //     List<Questions> list = await QuestionAndAnswerApiController().getQuestions(current_page: page);
  //     print(list.length);
  //     final bool emptyRepositories = list.isEmpty;
  //     if (!getFirstData && emptyRepositories) {
  //       isLoading.value = false;
  //
  //       // change(null, status: RxStatus.empty());
  //     }
  //     else if (getFirstData && emptyRepositories) {
  //       lastPage = true;
  //       isLoading.value = false;
  //
  //     } else {
  //       // isLoading.value = true;
  //       getFirstData = true;
  //
  //       questions.addAll(list);
  //
  //
  //       for(int i = 0; i < questions.length; i++){
  //         await getAnswers(questionId: questions[i].id.toString());
  //       }
  //
  //       print(answers.length);
  //
  //       isLoading.value = false;
  //
  //     }
  //
  //
  //   }
  //
  //     else {
  //       loading.value = false;
  //
  //       Get.snackbar('تنبيه', 'لا يوجد عناصر بعد');
  //     }
  //
  // }
  // @override
  // Future<void> onTopScroll() {
  //   // TODO: implement onTopScroll
  //   throw UnimplementedError();
  // }
}
