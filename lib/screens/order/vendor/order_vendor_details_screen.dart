import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:rakwa/api/api_controllers/order_api_controller.dart';
import 'package:rakwa/model/order.dart';
import 'package:rakwa/model/orders_vendor.dart';
import 'package:rakwa/screens/menu/food_details_screen.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app_colors/app_colors.dart';


class OrderVendorDetailsScreen extends StatefulWidget {

OrdersVendor order;
OrderVendorDetailsScreen({required this.order});

  @override
  State<OrderVendorDetailsScreen> createState() => _OrderVendorDetailsScreenState();
}

class _OrderVendorDetailsScreenState extends State<OrderVendorDetailsScreen> {
  final Completer<GoogleMapController> controller2 = Completer();
  CameraPosition? cameraPosition;
  late GoogleMapController _mapController;

  Set<Marker> markers = Set<Marker>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.order.address != null){
      if(widget.order.address!.lat != null && widget.order.address!.lng != null ){
        markers.add(
            Marker(markerId: MarkerId("3"),
                position: LatLng(double.parse(widget.order.address!.lat ?? ""), double.parse(widget.order.address!.lng ?? ""))
            )
        );

        cameraPosition= CameraPosition(target: LatLng(
            double.parse(widget.order.address!.lat ?? ""),double.parse(widget.order.address!.lng ?? "")
        ), zoom: 17);
      }

    }

  }
  @override
  Widget build(BuildContext context) {

    print(widget.order.id);
    // print(widget.order.restorant.);
    // تم قبولها من الادمن
    // 9 تم رفضها
    // 3 تم قبولها.
    // 5 تم التحضير
    // 7 تم التوصيل
    List<String> orderStatus = [
      "Accepted by admin",
      "Accepted",
      "Rejected",
      "Prepared",
      "Delivered",
    ];
    List<String> orderStatus2 = [
      "Accepted by admin",
      "Accepted",
      "Rejected",
    ];
    return Scaffold(

      appBar: AppBars.appBarDefault(title: "تفاصيل الطلب",secondIconImage: Visibility(
        visible: widget.order.lastStatus!.first.name != orderStatus[0],
        child: Visibility(
          visible: widget.order.lastStatus!.first.name != orderStatus[2],
          child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: IconButton(
              onPressed: () async{
                Share.share("${widget.order.client!.name},${widget.order.client!.phone},${widget.order.address!.address}\nبلوك: ${widget.order.address!.block}\nطابق: ${widget.order.address!.floor}\n شقة :${widget.order.address!.apartment}\n${widget.order.address != null ?"https://www.google.com/maps?q=${widget.order.address!.lat},${widget.order.address!.lng}" : ""} ");

              },
              icon: const Icon(
                Icons.share_outlined,
                // Icons.bookmark_outlined,
                color: Colors.black,
              )),
    ),
        ),
      )),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h,),
              Center(
                child: SizedBox(
                  height: 120.h,
                  child: widget.order.restorant!.type == 5 || widget.order.restorant!.type == 4?ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount:  orderStatus2.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        return widget.order.lastStatus!.isEmpty ? Container() : TimelineTile(
                          axis: TimelineAxis.horizontal,
                          alignment: TimelineAlign.end,
                          beforeLineStyle: LineStyle(
                              color: Colors.grey
                          ),
                          indicatorStyle: IndicatorStyle(
                              color: widget.order.lastStatus!.first.name == orderStatus2[index] ? AppColors().mainColor : Colors.grey.shade700
                          ),
                          startChild: Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                                Container(
                                    width: 80.w,
                                    margin: EdgeInsetsDirectional.only(end: 5.w),
                                    child: Text(orderStatus2[index] == "Accepted by admin" ? "Pending"  :  orderStatus2[index] == "Accepted by restaurant" ? "Accepted" :  orderStatus2[index] == "Rejected by restaurant" ? "Rejected" : orderStatus2[index],style: GoogleFonts.notoKufiArabic(
                                      textStyle: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.black,
                                          height: 1.3
                                      ),),
                                        textAlign: TextAlign.center
                                    ))
                              ],
                              // color: Colors.amberAccent,
                            ),
                          ),
                        );
                      }
                  ):ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount:  orderStatus.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        return widget.order.lastStatus!.isEmpty ? Container() : TimelineTile(
                          axis: TimelineAxis.horizontal,
                          alignment: TimelineAlign.end,
                          beforeLineStyle: LineStyle(
                              color: Colors.grey
                          ),
                          indicatorStyle: IndicatorStyle(
                              color: widget.order.lastStatus!.first.name == orderStatus[index] ? AppColors().mainColor : Colors.grey.shade700
                          ),
                          startChild: Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                              Container(
                                  width: 80.w,
                                    margin: EdgeInsetsDirectional.only(end: 5.w),
                                    child: Text(orderStatus[index] == "Accepted by admin" ? "Pending"  :  orderStatus[index] == "Accepted by restaurant" ? "Accepted" :  orderStatus[index] == "Rejected by restaurant" ? "Rejected" : orderStatus[index],style: GoogleFonts.notoKufiArabic(
                                    textStyle: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.black,
                                  height: 1.3
                                    ),),
                                  textAlign: TextAlign.center
                                  ))
                              ],
                              // color: Colors.amberAccent,
                              ),
                          ),
                        );
                      }
                  ),
                ),
              ),
             widget.order.restorant!.type == 5 ||widget.order.restorant!.type == 4  ?Padding(
               padding:  EdgeInsets.symmetric(horizontal: 24.h, vertical: 10.h),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   widget.order.lastStatus == null ? Container() : Visibility(
                     visible: widget.order.lastStatus!.first.name == "Accepted by admin",
                     child: InkWell(
                       onTap: () async{
                         bool success =await OrderApiController().acceptOrder(orderId: widget.order.id.toString());
                         if(success){
                           widget.order.lastStatus!.first.name = "Accepted";
                           setState(() {

                           });
                         }
                       },
                       child: Container(
                           padding: EdgeInsetsDirectional.only(
                               top: 2.h, bottom: 2.h , start: 17.w, end: 12.w
                           ),
                           decoration: BoxDecoration(
                             color: Colors.green,
                             border: Border.all(
                               color: Colors.green,
                             ),
                             borderRadius: BorderRadius.circular(9),
                           ),
                           child: Text("قبول",style: GoogleFonts.notoKufiArabic(
                             textStyle: TextStyle(
                               fontSize: 13.sp,
                               color: Colors.white,
                             ),))),
                     ),
                   ),
                   Visibility(
                     visible: widget.order.lastStatus!.first.name == 'Accepted by admin',
                     child: InkWell(
                       onTap: () async{
                         bool success =await OrderApiController().rejectOrder(orderId: widget.order.id.toString());
                         if(success){
                           widget.order.lastStatus!.first.name = "Rejected";
                           setState(() {

                           });
                         }
                       },

                       child: Container(
                           padding: EdgeInsetsDirectional.only(
                               top: 2.h, bottom: 2.h , start: 17.w, end: 12.w
                           ),
                           decoration: BoxDecoration(
                             color: Colors.red,
                             border: Border.all(
                               color: Colors.red,
                             ),
                             borderRadius: BorderRadius.circular(9),
                           ),
                           child: Text("رفض",style: GoogleFonts.notoKufiArabic(
                             textStyle: TextStyle(
                               fontSize: 13.sp,
                               color: Colors.white,
                             ),))),
                     ),
                   ),
                   Visibility(
                     visible: widget.order.lastStatus!.first.name == 'Rejected',
                     child: Text("هذا الطلب مرفوض",style: GoogleFonts.notoKufiArabic(
                       textStyle: TextStyle(
                         fontSize: 13.sp,
                         color: Colors.black,
                       ),)),
                   ),

                   // Visibility(
                   //   visible: widget.order.lastStatus!.first.name == 'Delivered',
                   //   child: Text("لا يوجد أحداث",style: GoogleFonts.notoKufiArabic(
                   //     textStyle: TextStyle(
                   //       fontSize: 13.sp,
                   //       color: Colors.black,
                   //     ),)),
                   // )

                   // https://rakwa.me//
                 ],
               ),
             ) :  Padding(
                padding:  EdgeInsets.symmetric(horizontal: 24.h, vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.order.lastStatus == null ? Container() : Visibility(
                     visible: widget.order.lastStatus!.first.name == "Accepted by admin",
                      child: InkWell(
                        onTap: () async{
                          bool success =await OrderApiController().acceptOrder(orderId: widget.order.id.toString());
                        if(success){
                          widget.order.lastStatus!.first.name = "Accepted";
                          setState(() {

                          });
                        }
                          },
                        child: Container(
                            padding: EdgeInsetsDirectional.only(
                                top: 2.h, bottom: 2.h , start: 17.w, end: 12.w
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              border: Border.all(
                                color: Colors.green,
                              ),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Text("قبول",style: GoogleFonts.notoKufiArabic(
                              textStyle: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.white,
                              ),))),
                      ),
                    ),
                    Visibility(
                      visible: widget.order.lastStatus!.first.name == 'Accepted by admin',
                      child: InkWell(
                        onTap: () async{
                          bool success =await OrderApiController().rejectOrder(orderId: widget.order.id.toString());
                          if(success){
                            widget.order.lastStatus!.first.name = "Rejected";
                            setState(() {

                            });
                          }
                        },

                        child: Container(
                            padding: EdgeInsetsDirectional.only(
                                top: 2.h, bottom: 2.h , start: 17.w, end: 12.w
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              border: Border.all(
                                color: Colors.red,
                              ),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Text("رفض",style: GoogleFonts.notoKufiArabic(
                              textStyle: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.white,
                              ),))),
                      ),
                    ),
                    Visibility(
                      visible: widget.order.lastStatus!.first.name == 'Rejected',
                      child: Text("هذا الطلب مرفوض",style: GoogleFonts.notoKufiArabic(
                        textStyle: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black,
                        ),)),
                    ),
                    Visibility(
                      visible: widget.order.lastStatus!.first.name == 'Accepted',

                      child: InkWell(
                        onTap: () async{
                          bool success =await OrderApiController().updateStatusOrder(orderId: widget.order.id.toString(),status: 5);
                          if(success){
                            widget.order.lastStatus!.first.name = "Prepared";
                            setState(() {
                            });
                          }
                        },
                        child: Container(
                            padding: EdgeInsetsDirectional.only(
                                top: 2.h, bottom: 2.h , start: 17.w, end: 12.w
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              border: Border.all(
                                color: Colors.green,
                              ),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Text("تحضير",style: GoogleFonts.notoKufiArabic(
                              textStyle: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.white,
                              ),))),
                      ),
                    ),
                    Visibility(
                      visible: widget.order.lastStatus!.first.name == 'Prepared',

                      child: InkWell(
                        onTap: () async{
                          bool success =await OrderApiController().updateStatusOrder(orderId: widget.order.id.toString(),status: 7);
                          if(success){
                            widget.order.lastStatus!.first.name = "Delivered";
                            setState(() {

                            });
                          }
                        },
                        child: Container(
                            padding: EdgeInsetsDirectional.only(
                                top: 2.h, bottom: 2.h , start: 17.w, end: 12.w
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              border: Border.all(
                                color: Colors.green,
                              ),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Text("توصيل",style: GoogleFonts.notoKufiArabic(
                              textStyle: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.white,
                              ),))),
                      ),
                    ),
                    Visibility(
                      visible: widget.order.lastStatus!.first.name == 'Delivered',
                      child: Text("لا يوجد أحداث",style: GoogleFonts.notoKufiArabic(
                        textStyle: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black,
                        ),)),
                    )

                  ],
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsetsDirectional.only(top: 30.h, start: 16.w, end: 16.w,bottom: 24.h),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0,3),
                          blurRadius: 6,
                          color: Colors.black.withOpacity(0.16)
                      )
                    ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:  EdgeInsetsDirectional.only(start: 11.w, end: 9.w, top: 9.h, bottom: 16.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(text: TextSpan(
                              children: [
                                TextSpan(text: "رقم الطلب",  style: GoogleFonts.notoKufiArabic(
                textStyle: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black,
                ),
              ),),
                                TextSpan(text: " "),
                                TextSpan(text: "#", style: TextStyle(color: Color(0xff545454))),
                                TextSpan(text: ""),
                                // Color(0xff0F146D)
                                TextSpan(text: widget.order.id.toString(),
                                    style: GoogleFonts.notoKufiArabic(
                                      textStyle: TextStyle(
                                        fontSize: 14.sp,
                                        color: Color(0xff0F146D),
                                      ),
                                  ),)
                              ]
                          )),
                          // Text(text: orderController.showOrders.first.order!.createdAt!.substring(0,10), fontColor:Color(0xff545454), fontSize: 13)
                        ],
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsetsDirectional.only(start: 10.w, end: 11.w, bottom: 2.h),
                      child:   Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFF5F5F5)
                                    ),
                                    padding: EdgeInsets.all(6),
                                    child: Icon(Icons.store, size: 9.w, color: Color(0xFF0F146D),)),
                                Text(" طلب من  ${widget.order.restorant!.name ??" "}",style: GoogleFonts.notoKufiArabic(
                                textStyle: TextStyle(
                                fontSize: 11.sp,
                                  color: Colors.black,
                                ),))
                              ],
                            ),
                          ),
                          widget.order.lastStatus!.isEmpty ? Container() :   Expanded(
                            child: Container(
                                padding: EdgeInsetsDirectional.only(
                                    top: 2.h, bottom: 2.h , start: 17.w, end: 12.w
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors().mainColor,
                                  ),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: Text(widget.order.lastStatus!.first.name == "Accepted by admin" ? "Pending" : widget.order.lastStatus!.first.name ?? "",style: GoogleFonts.notoKufiArabic(
                                  textStyle: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.black,
                                  ),))),
                          )


                        ],
                      ),
                    ),

                    widget.order.event != null ?     Padding(
                      padding:  EdgeInsetsDirectional.only(start: 33.w, end: 9.w, top: 9.h, bottom: 15.8.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("من:  ${widget.order.event!.startTime} ",style: GoogleFonts.notoKufiArabic(
                            textStyle: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.black,
                            ),)),
                          Text("الى:  ${widget.order.event!.endTime} ",style: GoogleFonts.notoKufiArabic(
                            textStyle: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.black,
                            ),)),

                        ],
                      ),
                    ) : Container(),
                 widget.order.insurance != null ? Padding(
                   padding:  EdgeInsetsDirectional.only(start: 33.w, end: 9.w, top: 9.h, bottom: 15.8.h),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text("التأمين:  ${widget.order.insurance} ليرة",style: GoogleFonts.notoKufiArabic(
                         textStyle: TextStyle(
                           fontSize: 10.sp,
                           color: Colors.black,
                         ),)),
                       Text("النظافة:  ${widget.order.clean} ليرة",style: GoogleFonts.notoKufiArabic(
                         textStyle: TextStyle(
                           fontSize: 10.sp,
                           color: Colors.black,
                         ),)),

                     ],
                   ),
                 ) :   Padding(
                      padding:  EdgeInsetsDirectional.only(start: 33.w, end: 9.w, top: 9.h, bottom: 15.8.h),
                      child: Text("${widget.order.items!.length}عنصر,  مجموع المبلغ : ${widget.order.orderPrice} ليرة ",style: GoogleFonts.notoKufiArabic(
                        textStyle: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.black,
                        ),)),
                    ),

                    // Accepted by restaurant
                    Padding(
                      padding:  EdgeInsetsDirectional.only(start: 33.w, end: 9.w, top: 9.h, bottom: 15.8.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(),
                          Visibility(
                            visible: widget.order.lastStatus!.first.name != orderStatus[0],
                            child: Visibility(
                              visible: widget.order.lastStatus!.first.name != orderStatus[2],

                              child: Text( " اسم العميل: ${widget.order.client!.name}",style: GoogleFonts.notoKufiArabic(
                                textStyle: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.black,
                                ),)),
                            ),
                          ),

                        widget.order.image != null  ?  Image.network("https://rakwa.me/${widget.order.logom ?? ""}",width: 70.w, height: 70.h,)
                        : Container(),
                          widget.order.address != null ?       Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("عنوان العميل:",style: GoogleFonts.notoKufiArabic(
                          textStyle: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                          ),
                    ),),

                        // UrlLauncher.launch('tel: xxxxxxxx');
                        //
                        Expanded(
                                child: InkWell(
                                  onTap: () => MapsLauncher.launchCoordinates(double.parse(widget.order.address!.lat ?? ""), double.parse(widget.order.address!.lng ?? "") ),
                                  child: Text( " ${widget.order.address!.address}",style: GoogleFonts.notoKufiArabic(
                                    textStyle: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,

                                    ),
                                  ),
                                  ),
                                ),
                              ),
                            ],
                          ) : Container(),


                          widget.order.address != null ?  Text( "تفاصيل اخرى: ${widget.order.address!.floor}-${widget.order.address!.apartment}",style: GoogleFonts.notoKufiArabic(
                            textStyle: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black,
                            ),)) : Container(),

                          Row(
                            children: [
                              Padding(
                                padding:  EdgeInsetsDirectional.only(end: 9.w, top: 9.h,),
                                child: Text( "حالة الدفع:",style: GoogleFonts.notoKufiArabic(
                                  textStyle: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.black,
                                  ),
                                ),
                                ),
                              ),
                              Padding(
                                padding:  EdgeInsetsDirectional.only(end: 9.w, top: 9.h,),
                                child: Text('${widget.order.paymentMethod =='cod' ? " الدفع عند الاستلام" : "تم الدفع أونلاين"}',style: GoogleFonts.notoKufiArabic(
                                  textStyle: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.black,
                                  ),)),
                              ),

                              widget.order.paymentMethod !='cod'  ? Padding(
                                padding:  EdgeInsetsDirectional.only(end: 9.w, top: 9.h,),
                                child: Text('${widget.order.partial_payment != null ? " مبلغ جزئي بقيمة ${widget.order.partial_payment}" : "${widget.order.orderPrice}"} \$',style: GoogleFonts.notoKufiArabic(
                                  textStyle: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.black,
                                  ),)),
                              ) : Container(),
                            ],
                          ),
                          Padding(
                            padding:  EdgeInsetsDirectional.only(end: 9.w, top: 9.h, bottom: 9.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text( "تكلفة التوصيل :",style: GoogleFonts.notoKufiArabic(
                                  textStyle: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.black,
                                  ),)),
                                Text( " ${widget.order.delivery_price} ${widget.order.restorant!.type == 4 || widget.order.restorant!.type == 5 ? "\$" : "ليرة"}  ",style: GoogleFonts.notoKufiArabic(
                                  textStyle: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.black,
                                  ),)),

                              ],
                            ),
                          ),
                          Visibility(
                            visible:     widget.order.lastStatus!.first.name != orderStatus[0],

                            child: Visibility(
                              visible: widget.order.lastStatus!.first.name != orderStatus[2],
                              child: Row(
                                children: [
                                  Text( "رقم هاتف العميل: ",style: GoogleFonts.notoKufiArabic(
                                    textStyle: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.black,
                                    ),)),
                                  InkWell(
                                    onTap: () => launchUrl(Uri(scheme: 'tel', path: "${widget.order.client!.phone}")),
                                    child: Text( "${widget.order.client!.phone}",style: GoogleFonts.notoKufiArabic(
                                      textStyle: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Divider(),
                    Padding(
                      padding:  EdgeInsetsDirectional.only(end: 9.w, top: 9.h, bottom: 9.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                        //   Text( "المجموع :",style: GoogleFonts.notoKufiArabic(
                        // textStyle: TextStyle(
                        //   fontSize: 12.sp,
                        //   color: Colors.black,
                        // ),)),
                          widget.order.insurance != null ?Text( " مجموع المبلغ :${widget.order.total} ليرة, ${widget.order.type == 1 ?'المبلغ المدفوع ${widget.order.partial_payment} ليرة ' : ""} ",style: GoogleFonts.notoKufiArabic(
                            textStyle: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black,
                            ),)) :      Text( "${widget.order.items!.length} عنصر,  مجموع المبلغ : ${widget.order.orderPrice} ${widget.order.restorant!.type == 4 || widget.order.restorant!.type == 5 ? "\$" : "ليرة"}  ",style: GoogleFonts.notoKufiArabic(
                            textStyle: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black,
                            ),)),

                        ],
                      ),
                    ),







                  ],
                ),
              ),

              widget.order.address != null ?   Container(
                margin: EdgeInsetsDirectional.only(top: 30.h, start: 16.w, end: 16.w,bottom: 24.h),

                height: 250.h,
                child: GoogleMap(
                    markers: markers,
                    onMapCreated: (GoogleMapController mapController)async {
                      _mapController = mapController;
                      controller2.complete(mapController);

                      // LocationSearchDialog(). _controller.complete(mapController);
                      // final GoogleMapController controller = await controller2.future;
                      // locationController.setMapController(mapController);
                    },
                    myLocationEnabled: false,
                    myLocationButtonEnabled:false,
                    // zoomControlsEnabled:false,
                    // mapToolbarEnabled:false,

                    onCameraIdle: ()async{
                      // await   AllAddressGetxController.to.getPlaceName(
                      //           AllAddressGetxController.to.latMap.value,
                      //     AllAddressGetxController.to.longMap.value);
                    },

                    initialCameraPosition: cameraPosition!
                ),
              ) : Container(),

              Padding(
                padding: EdgeInsetsDirectional.only(top: 30.h, start: 16.w, end: 16.w,bottom: 10.h),
                child: Text("العناصر : ",style: GoogleFonts.notoKufiArabic(
                  textStyle: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                  ),)),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: widget.order.items!.length,
                  itemBuilder: (context, index){
                    return InkWell(
                      onTap: (){

                        // Navigator.push(context, MaterialPageRoute(builder: (c) => FoodDetailsScreen(foodId: widget.order.items![index].id ?? -1, resId: widget.order.restorant!.id ?? -1,)));
                      },
                      child: Container(
                          margin: EdgeInsetsDirectional.only(top: 30.h, start: 16.w, end: 16.w,bottom: 10.h),
                          child: Row(
                              children: [
                                Container(
                                  width: 120.w,
                                  height: 120.h,
                                  // margin: EdgeInsetsDirectional.all(8),
                                  padding: EdgeInsetsDirectional.all(8),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage("https://rakwa.me//${widget.order.items![index].logom ?? ""}"),
                                      ),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.16),
                                          offset: Offset(0,3),
                                          blurRadius: 6,
                                        )
                                      ]
                                  ),),
                                SizedBox(width: 30.w,),
                                Column(
                                  children: [
                                    Text(widget.order.items![index].name ?? "",style: GoogleFonts.notoKufiArabic(
                                      textStyle: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.black,
                                      ),)),
                                    SizedBox(height: 15.h,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text("${widget.order.items![index].price.toString() } ${widget.order.restorant!.type == 4 || widget.order.restorant!.type == 5 ? "\$" : "ليرة"} "?? "",style: GoogleFonts.notoKufiArabic(
                                          textStyle: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.black,
                                          ),)),
                                        // SizedBox(width: 50.w,),
                                        //    Column(
                                        //   crossAxisAlignment: CrossAxisAlignment.start,
                                        //   children: [
                                        //     Row(
                                        //       children: [
                                        //         Text("التأمين",style: GoogleFonts.notoKufiArabic(
                                        //           textStyle: TextStyle(
                                        //             fontSize: 12.sp,
                                        //             color: Colors.black,
                                        //           ),)),
                                        //         SizedBox(width:10.w,),
                                        //
                                        //         Text("${widget.order.items![index].insurance.toString() } ₺"?? "",style: GoogleFonts.notoKufiArabic(
                                        //           textStyle: TextStyle(
                                        //             fontSize: 12.sp,
                                        //             color: Colors.black,
                                        //           ),)),
                                        //       ],
                                        //     ),
                                        //     Row(
                                        //       children: [
                                        //         Text("النظافة",style: GoogleFonts.notoKufiArabic(
                                        //           textStyle: TextStyle(
                                        //             fontSize: 12.sp,
                                        //             color: Colors.black,
                                        //           ),)),
                                        //         SizedBox(width:10.w,),
                                        //         Text("${widget.order.items![index].clean.toString() } ₺"?? "",style: GoogleFonts.notoKufiArabic(
                                        //           textStyle: TextStyle(
                                        //             fontSize: 12.sp,
                                        //             color: Colors.black,
                                        //           ),)),
                                        //       ],
                                        //     )
                                        //
                                        //
                                        //
                                        // ],)
                                      ],
                                    ),


                                  ],
                                ),
                              ]
                          )
                      ),
                    );
                  }),
            ],
          ),
        )
    );
  }
}


