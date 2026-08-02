// ignore_for_file: avoid_print

import 'dart:math' as math;

import 'package:dirve_society/app/modules/home/controllers/all_car_rating_controller.dart';
import 'package:dirve_society/app/modules/home/controllers/feed/react_controller.dart';
import 'package:dirve_society/app/modules/profile/others/views/others_profile_screen.dart';
import 'package:dirve_society/common/app_color/app_colors.dart';
import 'package:dirve_society/common/app_images/app_images.dart';
import 'package:dirve_society/common/size_box/custom_sizebox.dart';
import 'package:dirve_society/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';

class CarRatingPage extends StatefulWidget {
  const CarRatingPage({super.key});

  @override
  State<CarRatingPage> createState() => _CarRatingPageState();
}

class _CarRatingPageState extends State<CarRatingPage> {
  final ReactPostController reactPostController =
      Get.put(ReactPostController());
  final AllCarRatingController allCarRatingController =
      Get.put(AllCarRatingController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllCarRatingController>(builder: (controller) {
      if (controller.inProgress) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (controller.carRatingList == null ||
          controller.carRatingList!.isEmpty) {
        return const Center(
          child: Text(
            'No car ratings available',
            style: TextStyle(color: AppColors.white),
          ),
        );
      }

      final carRatings = controller.carRatingList!;
      final displayedCards = math.min(2, carRatings.length);

      return CardSwiper(
        cardsCount: carRatings.length,
        numberOfCardsDisplayed: displayedCards,
        cardBuilder: (context, index, x, y) {
          final car = carRatings[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    car.banner ?? AppImages.carImage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        AppImages.carImage,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        car.description ?? 'Unknown',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                          shadows: [
                            Shadow(
                              color: AppColors.black,
                              offset: Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      sh8,
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            () => OthersProfileView(
                              authorId: car.author!.id ?? '',
                            ),
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: car.author?.photoUrl != null
                                  ? NetworkImage(car.author!.photoUrl!)
                                  : const AssetImage(AppImages.carImageFive),
                            ),
                            sw5,
                            Expanded(
                              child: Text(
                                car.author?.name ?? 'Unknown',
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 14,
                                  shadows: [
                                    Shadow(
                                      color: AppColors.black,
                                      offset: Offset(1, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 26,
                  right: 20,
                  child: carRatings[index].isLiked ?? true
                      ? Icon(
                          Icons.thumb_up_sharp,
                          color: Colors.blue,
                          size: 30,
                        )
                      : Icon(
                          Icons.thumb_up_alt_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                ),
              ],
            ),
          );
        },
        onSwipe: (previousIndex, currentIndex, direction) {
          // Ensure currentIndex is not null
          if (currentIndex != null) {
            final car = carRatings[currentIndex];
            if (direction == CardSwiperDirection.left) {
              // Check if id is not null before calling reactPost
              if (car.id != null) {
                print('Swiped card $previousIndex to the LEFT, ID: ${car.id}');
                print(
                    'Swiped card $previousIndex to the LEFT, ID: ${carRatings[currentIndex].isLiked}');
              } else {
                print('Swiped card $previousIndex to the LEFT, but ID is null');
                if (mounted) {}
              }
            } else if (direction == CardSwiperDirection.right) {
              reactPost(car.contentMeta!.id ?? '');
              print('Swiped card $previousIndex to the RIGHT, ID: ${car.id}');
              'Swiped card $previousIndex to the LEFT, ID: ${carRatings[currentIndex].isLiked}';
              // Add your right swipe operation here
            }
          } else {
            print('Swipe ignored: currentIndex is null');
          }
          return true; // Allow the swipe
        },
        allowedSwipeDirection:
            const AllowedSwipeDirection.symmetric(horizontal: true),
        padding: const EdgeInsets.only(bottom: 35, left: 20, right: 20, top: 8),
      );
    });
  }

  Future<void> reactPost(String postId) async {
    print('Attempting to like post with ID: $postId');
    final bool isSuccess = await reactPostController.reactPost(postId);
    if (isSuccess) {
      if (mounted) {
        // showSnackBarMessage(context, 'Like successfully completed');
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            reactPostController.errorMessage ?? 'Failed to like', true);
      }
    }
  }
}
