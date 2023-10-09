import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rakwa/Core/utils/extensions.dart';

class ViewPhoto extends StatefulWidget {
  final List<String> photos;

   ViewPhoto({Key? key, required this.photos,required}) : super(key: key);

  @override
  State<ViewPhoto> createState() => _ViewPhotoState();
}

class _ViewPhotoState extends State<ViewPhoto> {
  bool hasReachedEnd = true;
  bool hasReachedFirst = false;
  @override
  Widget build(BuildContext context) {

    PageController pageController = PageController();
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
      ),
      child: PageView(
        controller: pageController,
        onPageChanged: (index){
          if (index + 1 == widget.photos.length) {
            print("First");
            setState((){
              hasReachedEnd = false;
              hasReachedFirst = true;

            });
          } else if (index == 0) {
            setState((){
              hasReachedFirst = false;
              hasReachedEnd = true;


            });
          } else {
            setState((){
              hasReachedFirst = true;
              hasReachedEnd = true;
            });

          }
        },
        children: widget.photos
            .map(
              (e) => SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Card(
                  margin: EdgeInsets.zero,
                  color: Colors.black,
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      PhotoView(
                        imageProvider: NetworkImage(e),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: hasReachedFirst,
                            child: InkWell(
                             onTap: (){
                               pageController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                             },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.50),
                                  shape: BoxShape.circle
                                ),
                                child: IconButton(onPressed: (){
                                  pageController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);

                                }, icon: Icon(Icons.arrow_back_ios_rounded,color: Colors.white,)),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: hasReachedEnd,
                            child: InkWell(
                              onTap: (){
                                pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.50),
                                    shape: BoxShape.circle
                                ),
                                child: IconButton(onPressed: (){
                                  pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);

                                }, icon: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,)),
                              ),
                            ),
                          ),

                        ],
                      ),

                      PositionedDirectional(
                          top: 60,
                          start: 30,
                          child: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.clear, color: Colors.white,)))

                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
