



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class SimmerLoadingListHomeWidget extends StatelessWidget {
  const SimmerLoadingListHomeWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade100,
        highlightColor: Colors.grey.shade300,
        child: ListView.separated(
          padding: EdgeInsets.zero,
          separatorBuilder: (context, index) {
            return const SizedBox(height: 12);
          },
          itemCount: 9,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(left: 8),
              height: 236,
              width: Get.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
            );
          },
        ));
  }
}
