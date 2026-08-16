import 'package:dirve_society/app/modules/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import '../../../../common/app_color/app_colors.dart';
import '../../../../common/app_images/app_images.dart';
import '../../../../common/app_text_style/styles.dart';
import '../../../../common/size_box/custom_sizebox.dart';

class ProfileViewModeView extends GetView {
  const ProfileViewModeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                child: SizedBox(
                  height: 240,
                  width: double.infinity,
                  child: Image.asset(
                    AppImages.coverImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 40,
                child: GestureDetector(
                  onTap: () { 
                    Get.back();
                  },
                  child: Container(
                      decoration: ShapeDecoration( 
                        shape: CircleBorder(),
                        color: AppColors.black.withOpacity(0.3),
                      ),
                      child: Image.asset(
                        AppImages.back,
                        scale: 4,
                      )),
                ),
              ),
              Positioned(
                bottom: -25,
                left: 20,
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: AppColors.white,
                  backgroundImage: AssetImage(AppImages.carImageFive),
                ),
              ),
              Positioned(
                right: 20,
                left: Get.width * 0.32,
                bottom: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nissan R35 GTR',
                      style: h1.copyWith(
                        fontSize: 20,
                        color: AppColors.darkRed,
                      ),
                    ),
                    sw8,
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 22,
                          color: AppColors.darkRed,
                        ),
                        sw5,
                        Text(
                          '4.7',
                          style: h3.copyWith(
                            color: AppColors.darkRed,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    //sh5,
                    // Text(
                    //   '5.0L V8 • 460HP • Custom Exhaust Clean, powerful, and ready to roar. Only 38k miles. DM to take it for a spin!',
                    //   style: h6,
                    //   maxLines: 3,
                    //   overflow: TextOverflow.ellipsis,
                    // )
                  ],
                ),
              ),
            ],
          ),
          sh40,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Descriptions',
                      style: h5.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.orange[600],
                      ),
                      child: Center(
                        child: Text(
                          ' Points',
                          style: h6,
                        ),
                      ),
                    ),
                  ],
                ),
                sh5,
                ReadMoreText(
                  '5.0L V8 • 460HP • Custom Exhaust Clean, powerful, and ready to roar. Only 38k miles. DM to take it for a spin!',
                  trimLines: 2,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Show More',
                  trimExpandedText: ' Show Less',
                  style: h6,
                  moreStyle: h6.copyWith(
                    color: AppColors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                  lessStyle: h6.copyWith(
                    color: AppColors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          sh20,
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       CustomButton(
          //         text: 'Add',
          //         onPressed: () {},
          //         width: 100,
          //         height: 40,
          //         iconColor: AppColors.white,
          //         textStyle: h5.copyWith(
          //           color: controller.isPostSelected.value
          //               ? AppColors.white
          //               : AppColors.black,
          //           fontWeight: FontWeight.w600,
          //         ),
          //         imageAssetPath: AppImages.add,

          //       ),
          //       Obx(
          //         () => Container(
          //           width: 150,
          //           padding: EdgeInsets.all(6),
          //           decoration: BoxDecoration(
          //               color: AppColors.silver,
          //               borderRadius: BorderRadius.circular(30)),
          //           child: Row(
          //             children: [
          //               Expanded(
          //                 child: GestureDetector(
          //                   onTap: () {
          //                     controller.isPostSelected.value = true;
          //                   },
          //                   child: Container(
          //                     padding: EdgeInsets.symmetric(vertical: 8.0),
          //                     decoration: BoxDecoration(
          //                       color: controller.isPostSelected.value
          //                           ? AppColors.darkRed
          //                           : AppColors.transparent,
          //                       borderRadius: BorderRadius.circular(25.0),
          //                     ),
          //                     child: Center(
          //                       child: Text(
          //                         'Posts',
          //                         style: h5.copyWith(
          //                           color: controller.isPostSelected.value
          //                               ? AppColors.white
          //                               : AppColors.black,
          //                           fontWeight: FontWeight.w600,
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //               sw8,
          //               Expanded(
          //                 child: GestureDetector(
          //                   onTap: () {
          //                     controller.isPostSelected.value = false;
          //                   },
          //                   child: Container(
          //                     padding: EdgeInsets.symmetric(vertical: 8.0),
          //                     decoration: BoxDecoration(
          //                       color: controller.isPostSelected.value
          //                           ? AppColors.transparent
          //                           : AppColors.darkRed,
          //                       borderRadius: BorderRadius.circular(25.0),
          //                     ),
          //                     child: Center(
          //                       child: Text(
          //                         'Garage',
          //                         style: h5.copyWith(
          //                           color: controller.isPostSelected.value
          //                               ? AppColors.black
          //                               : AppColors.white,
          //                           fontWeight: FontWeight.w600,
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Obx(
          //   () => controller.isPostSelected.value
          //       ? Expanded(
          //           child: Padding(
          //             padding: const EdgeInsets.symmetric(horizontal: 20),
          //             child: GridView.builder(
          //               padding: EdgeInsets.only(
          //                 top: 12,
          //                 bottom: 75,
          //               ),
          //               shrinkWrap: true,
          //               //primary: false,
          //               itemCount: 24,
          //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //                 crossAxisCount: 2,
          //                 mainAxisSpacing: 8,
          //                 crossAxisSpacing: 8,
          //                 mainAxisExtent: 150,
          //               ),
          //               itemBuilder: (context, index) => ClipRRect(
          //                 borderRadius: BorderRadius.circular(12),
          //                 child: Image.asset(
          //                   AppImages.noImage,
          //                   scale: 4,
          //                   fit: BoxFit.cover,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         )
          //       : Expanded(
          //           child: Padding(
          //             padding: const EdgeInsets.symmetric(horizontal: 20),
          //             child: ListView.builder(
          //               padding: EdgeInsets.zero,
          //               itemCount: DummyData.cars.length,
          //               itemBuilder: (context, index) => Padding(
          //                 padding: EdgeInsets.only(
          //                   top: index == 0 ? 12 : 8,
          //                   bottom: index == DummyData.cars.length - 1 ? 20 : 0,
          //                 ),
          //                 child: MarketPlaceWidget(
          //                   height: 200,
          //                   name: DummyData.cars[index]['name']!,
          //                   price: DummyData.cars[index]['price']!,
          //                   date: DummyData.cars[index]['date']!,
          //                   imageUrl: DummyData.cars[index]['image']!,
          //                   onTap: () {
          //                     Get.to(() => ListingDetailsView());
          //                   },
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          // ),
        ],
      ),
    );
  }
}
