import 'package:dirve_society/app/modules/club/controllers/leave_club_controller.dart';
import 'package:dirve_society/app/modules/profile/others/controller/others_profile_controller.dart';
import 'package:dirve_society/app/modules/profile/others/views/others_profile_feed.dart';
import 'package:dirve_society/app/modules/profile/others/views/others_profile_market_place.dart';
import 'package:dirve_society/common/app_color/app_colors.dart';
import 'package:dirve_society/common/size_box/custom_sizebox.dart';
import 'package:dirve_society/common/widgets/profile_header_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OthersProfileView extends StatefulWidget {
  final String authorId;
  const OthersProfileView({
    super.key,
    required this.authorId, 
  });

  @override
  State<OthersProfileView> createState() => _OthersProfileViewState();
}

class _OthersProfileViewState extends State<OthersProfileView> {
  final LeaveClubController leaveClubController =
      Get.put(LeaveClubController());
  int selectedIndex = 0;

  final OthersProfileController othersProfileController =
      Get.put(OthersProfileController());

  @override
  void initState() {
    super.initState();
    othersProfileController.fetchOthersProfileData(widget.authorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor, 
      body: GestureDetector(
        // Detect taps outside the menu to close it (if needed)
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: GetBuilder<OthersProfileController>(builder: (controller) {
          if (controller.inProgress) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (controller.errorMessage != null &&
              controller.errorMessage!.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.errorMessage!,
                    style: TextStyle(color: AppColors.darkRed, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      controller.fetchOthersProfileData(widget.authorId);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (controller.profileData == null) {
            return const Center(
              child: Text(
                'No profile data available',
                style: TextStyle(color: AppColors.darkRed, fontSize: 16),
              ),
            );
          } else {
            final profile = controller.profileData!;

            return Column(
              children: [
                ProfileHeaderLayout(
                  title: profile.name ?? 'No name',
                  subtitle: profile.bio,
                  coverImageUrl: profile.coverPhoto,
                  profileImageUrl: profile.photoUrl,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        size: 22,
                        color: AppColors.darkRed,
                      ),
                      sw5,
                      Text(
                        profile.avgRating?.toString() ?? '0',
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  onBack: Get.back,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.silver,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = 0;
                              });
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                color: selectedIndex == 0
                                    ? AppColors.darkRed
                                    : AppColors.transparent,
                              ),
                              child: Center(
                                child: Text(
                                  'Feed',
                                  style: TextStyle(
                                    fontWeight: selectedIndex == 0
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: selectedIndex == 0
                                        ? AppColors.white
                                        : AppColors.black,
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
                                selectedIndex = 1;
                              });
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                color: selectedIndex == 1
                                    ? AppColors.darkRed
                                    : AppColors.transparent,
                              ),
                              child: Center(
                                child: Text(
                                  'Garage',
                                  style: TextStyle(
                                    fontWeight: selectedIndex == 1
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: selectedIndex == 1
                                        ? AppColors.white
                                        : AppColors.black,
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
                Expanded(
                  child: selectedIndex == 0
                      ? OthersFeedScreen(authorId: widget.authorId)
                      : OthersProfileMarketPlace(id: widget.authorId),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}
