import 'package:dirve_society/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:dirve_society/app/modules/dashboard/views/widget/bottom_nav_item.dart';
import 'package:dirve_society/app/modules/market_place/views/market_place_view.dart';
import 'package:dirve_society/app/modules/meets/views/meets_view.dart';
import 'package:dirve_society/app/modules/profile/views/my_clubs_view.dart';
import 'package:dirve_society/app/modules/profile/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/app_color/app_colors.dart';
import '../../../../common/app_images/app_images.dart'; 
import '../../home/views/home_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key}); 

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final DashboardController dashboardController =
      Get.put(DashboardController());

  final List<Widget> _screens = [
    const HomeView(),
    MeetsView(),
    const MarketPlaceView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _screens[dashboardController.selectedIndex.value]),
      // Reactive body
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          BottomAppBar(
            padding: EdgeInsets.zero,
            height: 80,
            color: AppColors.bottomNavbar,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => dashboardController.changeTabIndex(0),
                    child: Obx(() => NavBarItem(
                          selectedIcon: AppImages.homeRed,
                          unselectedIcon: AppImages.home,
                          label: "Home",
                          isSelected:
                              dashboardController.selectedIndex.value == 0,
                        )),
                  ),
                  GestureDetector(
                    onTap: () => dashboardController.changeTabIndex(1),
                    child: Obx(() => NavBarItem(
                          selectedIcon: AppImages.locationRed,
                          unselectedIcon: AppImages.location,
                          label: "   Meets   ",
                          isSelected:
                              dashboardController.selectedIndex.value == 1,
                        )),
                  ),
                  SizedBox(width: Get.width * 0.10),
                  GestureDetector(
                    onTap: () => dashboardController.changeTabIndex(2),
                    child: Obx(() => NavBarItem(
                          selectedIcon: AppImages.marketPlaceRed,
                          unselectedIcon: AppImages.marketPlace,
                          label: "Market Place",
                          isSelected:
                              dashboardController.selectedIndex.value == 2,
                        )),
                  ),
                  GestureDetector(
                    onTap: () => dashboardController.changeTabIndex(3),
                    child: Obx(() => NavBarItem(
                          selectedIcon: AppImages.personRed,
                          unselectedIcon: AppImages.person,
                          label: "Profile",
                          isSelected:
                              dashboardController.selectedIndex.value == 3,
                        )),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 35,
            left: Get.width * 0.4,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.bottomNavbar,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  splashColor: Colors.red[50],
                  backgroundColor: AppColors.transparent,
                  onPressed: () {
                    Get.to(() => MyClubsView());
                  },
                  shape: const CircleBorder(),
                  elevation: 0,
                  child: Image.asset(
                    AppImages.steeringWheel,
                    scale: 4,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
