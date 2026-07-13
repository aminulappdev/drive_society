// ignore_for_file: avoid_print

import 'package:dirve_society/app/modules/chat/views/chat_view.dart';
import 'package:dirve_society/app/modules/home/controllers/connection_view/connect_view.dart';
import 'package:dirve_society/app/modules/home/views/tab_feed.dart';
import 'package:dirve_society/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/app_color/app_colors.dart';
import '../../../../common/app_images/app_images.dart';
import '../../../../common/size_box/custom_sizebox.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.mainColor,
        title: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.grey,
            child: CircleAvatar(
              radius: 19,
              backgroundColor: AppColors.white,
              backgroundImage: StorageUtil.getData(StorageUtil.profilePhotoUrl) !=
                      null
                  ? NetworkImage(StorageUtil.getData(StorageUtil.profilePhotoUrl))
                  : AssetImage(AppImages.noImage),
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(() => const ConnectView());
            },
            child: Image.asset(
              AppImages.addGroup,
              scale: 4,
            ),
          ),
          sw12,
          GestureDetector(
            onTap: () {
              Get.to(() => const ChatView());
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.silver),
              ),
              child: Image.asset(
                AppImages.chatTwo,
                scale: 4,
              ),
            ),
          ),
          sw20,
        ],
      ),
      body: const TabbedFeed(),
    );
  }
}
