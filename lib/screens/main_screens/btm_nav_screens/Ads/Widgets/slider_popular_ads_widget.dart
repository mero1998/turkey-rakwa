import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Ads/Widgets/shimmer_loading_slider_home_widget.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Ads/Widgets/slider_card_ads.dart';

import '../../../../../api/api_controllers/home_api_controller.dart';
import '../../../../../model/paid_items_model.dart';



class SliderPopularAdsWidget extends StatelessWidget {
  const SliderPopularAdsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280.h,
      child: FutureBuilder<List<PaidItemsModel>>(
        future: HomeApiController().getPopularClassified(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ShimmerLoadingSliderHomeWidget();
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return SliderCardAds(
              length: snapshot.data!.length,
              ads: snapshot.data!,
            );
          } else {
            return const Center(
              child: Text('لا توجد اي عناصر '),
            );
          }
        },
      ),
    );
  }
}
