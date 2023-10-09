// import 'dart:convert';
//
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_credit_card/credit_card_brand.dart';
// import 'package:flutter_credit_card/credit_card_form.dart';
// import 'package:flutter_credit_card/credit_card_model.dart';
// import 'package:flutter_credit_card/credit_card_widget.dart';
// import 'package:flutter_credit_card/custom_card_type_icon.dart';
// import 'package:flutter_credit_card/glassmorphism_config.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:rakwa/app_colors/app_colors.dart';
// import 'package:rakwa/controller/all_cart_getx_controller.dart';
// import 'package:rakwa/controller/all_orders_getx_controller.dart';
// import 'package:rakwa/screens/main_screens/main_screen.dart';
// import 'package:rakwa/widget/TextFields/text_field_default.dart';
// import 'package:rakwa/widget/appbars/app_bars.dart';
// import 'package:rakwa/widget/main_elevated_button.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../widget/SVG_Widget/svg_widget.dart';
// import 'package:http/http.dart' as http;
//
// class OrderSuccessScreen extends StatefulWidget {
//
//   @override
//   State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
// }
//
// class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
//
// @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
// }
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       // backgroundColor: Color(0xFFF5F5F5),
//       backgroundColor: Colors.white,
//
//       appBar: AppBars.appBarDefault(title: "",isBack: false),
//       body: ListView(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 40.h),
//         children: [
//           Text(
//             "تم انشاء طلبك بنجاح",
//             style: GoogleFonts.notoKufiArabic(
//               textStyle:  TextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.bold,
//                 overflow: TextOverflow.ellipsis,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//           Text(
//             "يمكنك تتبع طلبك من صفحة الطلبات",
//             style: GoogleFonts.notoKufiArabic(
//               textStyle:  TextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.bold,
//                 overflow: TextOverflow.ellipsis,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//           SizedBox(height: 40.h,),
//           IconSvg(
//           "chat",
//             size: 200.h,
//           ),
//
//
//           MainElevatedButton(child:  Text(
//             "ارسله من هنا",
//             style: GoogleFonts.notoKufiArabic(
//               textStyle:  TextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.bold,
//                 overflow: TextOverflow.ellipsis,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//               height: 48.h,
//               width: 100.w,
//               borderRadius: 6,
//               onPressed: () async{
//                 var url = Uri.parse(widget.whatsappLink);
//                 if (await canLaunchUrl(url)) {
//                 launchUrl(url,mode:LaunchMode.externalApplication);
//                 }
//               }),
//           SizedBox(height: 20.h,),
//           MainElevatedButton(child:  Text(
//             "العودة للصفحة الرئيسية",
//             style: GoogleFonts.notoKufiArabic(
//               textStyle:  TextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.bold,
//                 overflow: TextOverflow.ellipsis,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//               height: 48.h,
//               width: 100.w,
//               borderRadius: 6,
//               onPressed: (){
//             Get.offAll(MainScreen());
//               })
//         ],
//       ),
//     );
//   }
//
//
//
// }
//
// class MySeparator extends StatelessWidget {
//   const MySeparator({Key? key, this.height = 1, this.color = Colors.black})
//       : super(key: key);
//   final double height;
//   final Color color;
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (BuildContext context, BoxConstraints constraints) {
//         final boxWidth = constraints.constrainWidth();
//         const dashWidth = 10.0;
//         final dashHeight = height;
//         final dashCount = (boxWidth / (2 * dashWidth)).floor();
//         return Flex(
//           children: List.generate(dashCount, (_) {
//             return SizedBox(
//               width: dashWidth,
//               height: dashHeight,
//               child: DecoratedBox(
//                 decoration: BoxDecoration(color: color),
//               ),
//             );
//           }),
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           direction: Axis.horizontal,
//         );
//       },
//     );
//   }
// }