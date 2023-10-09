
import 'package:flutter/material.dart';
import 'package:rakwa/Core/utils/dynamic_link_service.dart';

class ShareItemWidget extends StatelessWidget  {
   String id;
   String title;
   String desc;
   String image;
   String tag;
  final String kayType;

   ShareItemWidget({
    Key? key,
    required this.id,
    required this.title,
    required this.desc,
    required this.image,
    required this.tag,
    required this.kayType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CircleAvatar(
        backgroundColor: Colors.black.withOpacity(0.4),
        child: IconButton(
            onPressed: () async{
              await DynamicLink().createDynamicLink(true, id: id,title: title, desc: desc, image: image,tag: tag);
            },
            icon: const Icon(
              Icons.share_outlined,
              // Icons.bookmark_outlined,
              color: Colors.white,
            )),
      ),
    );
  }


}
