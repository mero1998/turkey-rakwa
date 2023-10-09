import 'dart:convert';
import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/custom_card_type_icon.dart';
import 'package:flutter_credit_card/glassmorphism_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/api/api_controllers/order_api_controller.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/controller/all_cart_getx_controller.dart';
import 'package:rakwa/controller/all_orders_getx_controller.dart';
import 'package:rakwa/screens/main_screens/main_screen.dart';
import 'package:rakwa/screens/order/all_orders_screen.dart';
import 'package:rakwa/widget/TextFields/text_field_default.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:rakwa/widget/main_elevated_button.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;

class ConfirmOrderBookScreen extends StatefulWidget {
  String orderId;
  ConfirmOrderBookScreen({required this.orderId});

  @override
  State<ConfirmOrderBookScreen> createState() => _ConfirmOrderBookScreenState();
}

class _ConfirmOrderBookScreenState extends State<ConfirmOrderBookScreen> with WidgetsBindingObserver{

  bool created = false;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Get.put(AllOrdersGetxController());

    print("From init");
    Future.delayed(Duration.zero,() async{
      created = await OrderApiController().checkOrder(orderId: int.parse(widget.orderId));
    });

    print("Created::: ${created}");
}
  void didChangeAppLifecycleState(AppLifecycleState state) {

    super.didChangeAppLifecycleState(state);

    print("State:::::::: ${state}");
    if(state == AppLifecycleState.resumed){

      Future.delayed(Duration.zero,() async{
        created = await OrderApiController().checkOrder(orderId: int.parse(widget.orderId));
      });

      if(!created){
        Get.offAll(MainScreen());
      }
      print("Created::: ${created}");


    }
    // if(state == AppLifecycleState.paused){
    // }


  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // backgroundColor: Color(0xFFF5F5F5),
      backgroundColor: Colors.white,

      appBar: AppBars.appBarDefault(title: "",isBack: false),
      body: Center(
        child:  Text(
         created ? "تم تأكيد الحجز بنجاح" : "يرجى تأكيد عملية الدفع",
          style: GoogleFonts.notoKufiArabic(
            textStyle:  TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }



}

class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 1, this.color = Colors.black})
      : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 10.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}