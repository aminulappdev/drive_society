// ignore_for_file: avoid_print

import 'package:dirve_society/app/modules/home/controllers/feed/home_controller.dart';
import 'package:dirve_society/app/modules/home/views/car_rating_page.dart';
import 'package:dirve_society/app/modules/home/views/feed_page.dart';
import 'package:dirve_society/common/app_color/app_colors.dart';
import 'package:dirve_society/common/size_box/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabbedFeed extends StatefulWidget {
  const TabbedFeed({super.key});

  @override
  State<TabbedFeed> createState() => _TabbedFeedState();
}

class _TabbedFeedState extends State<TabbedFeed> {
  int selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Column(
      children: [
        // Tab bar
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectIndex = 0;
                          controller.isFeedSelected.value = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          color: controller.isFeedSelected.value
                              ? Colors.red
                              : AppColors.transparent,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Center(
                          child: Text(
                            'Feed',
                            style: TextStyle(
                              color: controller.isFeedSelected.value
                                  ? AppColors.white
                                  : AppColors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  sw8,
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectIndex = 1;
                          controller.isFeedSelected.value = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          color: controller.isFeedSelected.value
                              ? AppColors.transparent
                              : Colors.red,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Center(
                          child: Text(
                            'Car Rating',
                            style: TextStyle(
                              color: controller.isFeedSelected.value
                                  ? AppColors.black
                                  : AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Content based on selected tab
        Expanded(
          child: selectIndex == 0 ? const FeedPage() : const CarRatingPage(),
        ),
      ],
    );
  }
}
