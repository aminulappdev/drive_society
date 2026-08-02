import 'package:dirve_society/app/data/dummy_data.dart';
import 'package:dirve_society/app/modules/chat/controllers/add_chat_controller.dart';
import 'package:dirve_society/app/modules/chat/controllers/get_chat_id_controller.dart';
import 'package:dirve_society/app/modules/chat/views/chat_view.dart';
import 'package:dirve_society/app/modules/chat/views/message_view.dart';
import 'package:dirve_society/app/modules/home/views/date_formatter.dart';
import 'package:dirve_society/app/modules/market_place/controllers/all_review_controller.dart';
import 'package:dirve_society/app/modules/market_place/controllers/market_details_controller.dart';
import 'package:dirve_society/app/modules/market_place/views/create_review_screen.dart';
import 'package:dirve_society/common/app_text_style/styles.dart';
import 'package:dirve_society/common/helper/info_container.dart';
import 'package:dirve_society/common/helper/review_card.dart';
import 'package:dirve_society/common/size_box/custom_sizebox.dart';
import 'package:dirve_society/common/widgets/custom_button.dart';
import 'package:dirve_society/common/widgets/custom_circular_container.dart';
import 'package:dirve_society/common/widgets/custom_snackbar_widget.dart';
import 'package:dirve_society/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/app_color/app_colors.dart';
import '../../../../common/app_images/app_images.dart';

// Dynamic Star Rating Widget

class ListingDetailsView extends StatefulWidget {
  final String id;
  const ListingDetailsView({super.key, required this.id});

  @override
  State<ListingDetailsView> createState() => _ListingDetailsViewState();
}

class _ListingDetailsViewState extends State<ListingDetailsView> {
  final MarketplaceDetailsController marketplaceDetailsController =
      Get.put(MarketplaceDetailsController());
  final AllReviewController allReviewController =
      Get.put(AllReviewController());

  final GetChatIdController getChatIdController =
      Get.put(GetChatIdController());
  final AddChatController addChatController = Get.put(AddChatController());

  Future<void> _openReviewScreen(String listingId) async {
    final bool? reviewSubmitted = await Get.to<bool>(
      () => CreateReviewScreen(listingId: listingId),
    );

    if (reviewSubmitted == true) {
      await Future.wait([
        marketplaceDetailsController.getMarketPlaceData(widget.id),
        allReviewController.getReview(widget.id),
      ]);
    }
  }

  @override
  void initState() {
    marketplaceDetailsController.getMarketPlaceData(widget.id);
    allReviewController.getReview(widget.id);
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
        title: Text(
          'Listing Details',
          style: appBarStyle,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: GetBuilder<MarketplaceDetailsController>(builder: (controller) {
          if (controller.inProgress) {
            return SizedBox(
                height: 550,
                child: const Center(child: CircularProgressIndicator()));
          }
          print(
              'Product model ${controller.marketPlaceDetailsModel?.images.length}');
          final String currentProfileId =
              StorageUtil.getData(StorageUtil.profileId) ?? '';
          final bool isOwnListing =
              controller.marketPlaceDetailsModel?.author?.id == currentProfileId;
          final bool canReview =
              !isOwnListing &&
              (controller.marketPlaceDetailsModel?.isSale ?? false);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.silver,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    controller.marketPlaceDetailsModel?.banner ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      AppImages.carImageFour,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              controller.marketPlaceDetailsModel!.images.isEmpty
                  ? SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        height: 90,
                        child: ListView.builder(
                          itemCount:
                              controller.marketPlaceDetailsModel!.images.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            print('Index: $index');
                            return Padding(
                              padding:
                                  const EdgeInsets.only(right: 8.0,),
                              child: Container(
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppColors.silver,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    controller
                                        .marketPlaceDetailsModel!.images[index],
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                      AppImages.carImageFour,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
              sh20,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.marketPlaceDetailsModel?.brand ?? '',
                          style: h1.copyWith(fontSize: 20),
                        ),
                        Text(
                          '£${controller.marketPlaceDetailsModel?.price ?? ''}',
                          style: h1.copyWith(
                            fontSize: 20,
                            color: AppColors.darkRed,
                          ),
                        ),
                      ],
                    ),
                    sh8,
                    Text(
                      '${controller.marketPlaceDetailsModel?.description}',
                      style: h6,
                    ),
                    sh20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InfoContainer(
                            imagePath: AppImages.transmission,
                            label: 'Transmission',
                            value:
                                '${controller.marketPlaceDetailsModel?.transmission}'),
                        InfoContainer(
                            imagePath: AppImages.mileage,
                            label: 'Mileage',
                            value:
                                '${controller.marketPlaceDetailsModel?.mileage} Mi'),
                        InfoContainer(
                            imagePath: AppImages.fuel,
                            label: 'Fuel',
                            value:
                                '${controller.marketPlaceDetailsModel?.fuelType}'),
                      ],
                    ),
                    sh20,
                    Text(
                      'Seller Details',
                      style: h3,
                    ),
                    sh12,
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.silver),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                controller.marketPlaceDetailsModel?.author
                                        ?.photoUrl ??
                                    '',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          sw8,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.marketPlaceDetailsModel!.author
                                        ?.name ??
                                    '',
                                style: h3.copyWith(fontSize: 14),
                              ),
                              sh8,
                              Row(
                                children: [
                                  DynamicStarRating(
                                    rating: controller.marketPlaceDetailsModel
                                            ?.author?.avgRating
                                            ?.toDouble() ??
                                        0.0,
                                    starSize: 20,
                                    filledColor: AppColors.darkRed,
                                    emptyColor: AppColors.grey,
                                  ),
                                  sw8,
                                  Text(
                                    '${controller.marketPlaceDetailsModel!.author?.avgRating ?? ''} (${controller.marketPlaceDetailsModel!.author?.ratingCount ?? ''})',
                                    style: h7,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              addChat(
                                  controller
                                      .marketPlaceDetailsModel!.author!.id!,
                                  controller
                                      .marketPlaceDetailsModel!.author!.name!,
                                  controller.marketPlaceDetailsModel!.author!
                                          .photoUrl ??
                                      'https://fastly.picsum.photos/id/237/200/300.jpg?hmac=TmmQSbShHz9CdQm0NkEjx1Dyh_Y984R9LpNrpvH2D_U');
                            },
                            child: Image.asset(
                              AppImages.chatRed,
                              scale: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              sh20,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reviews',
                          style: h3,
                        ),
                        sh5,
                        // Row(
                        //   children: [
                        //     DynamicStarRating(
                        //       rating:
                        //           4.7, // Replace with dynamic average if available
                        //       starSize: 20,
                        //       filledColor: AppColors.darkRed,
                        //       emptyColor: AppColors.grey,
                        //     ),
                        //     sw8,
                        //     Text(
                        //         '${controller.marketPlaceDetailsModel!.avgRating ?? ''} (${controller.marketPlaceDetailsModel!.ratingCount ?? ''})',
                        //         style: h7), // Update with dynamic data
                        //   ],
                        // ),
                      ],
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     Get.to(() => CreateReviewScreen(
                    //           listingId:
                    //               controller.marketPlaceDetailsModel!.id!,
                    //         ));
                    //   },
                    //   child: Row(
                    //     children: [
                    //       Text(
                    //         'Create review',
                    //         style: h6.copyWith(color: AppColors.darkRed),
                    //       ),
                    //       sw8,
                    //       Image.asset(
                    //         AppImages.arrowRight,
                    //         scale: 4,
                    //         color: AppColors.darkRed,
                    //       )
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
              sh12,
              GetBuilder<AllReviewController>(builder: (controller) {
                if (allReviewController.inProgress) {
                  return const Center(child: CircularProgressIndicator());
                }
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.18,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.allReviewList?.length ?? 0,
                    itemBuilder: (context, index) {
                      final review = controller.allReviewList?[index];
                      final dateFormatter = DateFormatter(
                          controller.allReviewList?[index].createdAt ??
                              DateTime.now());
                      return Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? 20 : 8,
                          right: index == DummyData.reviews.length - 1 ? 20 : 0,
                        ),
                        child: ReviewCard(
                          rating: review?.rating,
                          reviewText: review?.review ?? '',
                          reviewerName: review!.user?.name ?? '',
                          date: dateFormatter.getFullDateFormat(),
                          imagePath: review.user?.photoUrl ?? '',
                        ),
                      );
                    },
                  ),
                );
              }),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomButton(
                  textStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.normal),
                  backgroundColor:
                      canReview ? AppColors.darkRed : Colors.grey,
                  text: 'Rate this seller on marketplace',
                  onPressed: () {
                    if (isOwnListing) {
                      showSnackBarMessage(
                        context,
                        'You can’t review your own listing.',
                        false,
                        'Notice',
                      );
                      return;
                    }

                    if (!(controller.marketPlaceDetailsModel?.isSale ?? false)) {
                      showSnackBarMessage(
                        context,
                        'Rating becomes available after a completed sale or direct communication.',
                        false,
                        'Not Available Yet',
                      );
                      return;
                    }
                    
                    if (controller.marketPlaceDetailsModel?.id != null) {
                      _openReviewScreen(
                        controller.marketPlaceDetailsModel!.id!,
                      );
                    }
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // Future<void> getChatId(String userId, String name, String image) async {
  //   final bool isSuccess = await getChatIdController.getChat(userId);
  //   var chatId = getChatIdController.chatId;

  //   if (isSuccess) {
  //     if (mounted) {
  //       Get.to(() => MessageView(
  //             chatId: chatId ?? '',
  //             receiverId: userId,
  //             receiverName: name,
  //             receiverImage: image,
  //           ));
  //     }
  //   } else {
  //     if (mounted) {
  //       showSnackBarMessage(
  //         context,
  //         getChatIdController.errorMessage ?? 'Failed to update profile',
  //         true,
  //       );
  //     }
  //   }
  // }

  Future<void> addChat(String userId, String name, String image) async {
    final bool isSuccess = await addChatController.addChat(userId);
    var chatId = getChatIdController.chatId;

    if (isSuccess) {
      if (mounted) {
        Get.to(() => ChatView());
      }
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          addChatController.errorMessage ?? 'Failed to update profile',
          true,
        );
      }
    }
  }
}
