import 'package:dirve_society/app/modules/home/views/post_details_screen.dart';
import 'package:dirve_society/app/modules/profile/controllers/my_favourite_controller.dart';
import 'package:dirve_society/common/app_text_style/styles.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../common/app_color/app_colors.dart';
import '../../../../common/app_images/app_images.dart';
import '../../../../common/size_box/custom_sizebox.dart';
import '../../../../common/widgets/custom_circular_container.dart';

class SavedView extends StatefulWidget {
  const SavedView({super.key});

  @override
  State<SavedView> createState() => _SavedViewState();
}

class _SavedViewState extends State<SavedView> {
  final MyFavouriteController _myFavouriteController =
      Get.put(MyFavouriteController());

  @override
  void initState() {
    _myFavouriteController.getMyFavourite();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CustomCircularContainer(
            imagePath: AppImages.back,
            onTap: () {
              Get.back();
            },
            padding: 4,
          ),
        ),
        scrolledUnderElevation: 0,
        title: Text(
          'Saved',
          style: appBarStyle,
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [ 
          sh12,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'All Posts',
              style: h1.copyWith(fontSize: 20),
            ),
          ),
          GetBuilder<MyFavouriteController>(builder: (controller) {
            if (controller.inProgress) {
              return SizedBox(
                height: 500,
                child: const Center(child: CircularProgressIndicator()));
            }
            if (controller.myFavouriteList == null ||
                controller.myFavouriteList!.isEmpty) {
              return SizedBox(
                height: 500,
                child: Center(
                  child: Text(
                    'No Saved Posts',
                    style: h4.copyWith(color: AppColors.black),
                  ),
                ),
              );
            }
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  padding: EdgeInsets.only(
                    top: 12,
                    bottom: 20,
                  ),
                  shrinkWrap: true,
                  //primary: false,
                  itemCount: controller.myFavouriteList?.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    mainAxisExtent: 150,
                  ),
                  itemBuilder: (context, index) => ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => PostDetailsScreen(
                              postId: controller
                                      .myFavouriteList![index].content?.id ??
                                  '',
                            ));
                      },
                      child: Image.network(
                        controller
                                .myFavouriteList![index].content?.content[0] ??
                            '',
                        scale: 4,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
