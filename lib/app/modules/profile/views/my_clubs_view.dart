import 'package:dirve_society/app/modules/club/views/club_view.dart';
import 'package:dirve_society/app/modules/home/controllers/connection_view/my_joining_club_controller.dart';
import 'package:dirve_society/app/modules/profile/controllers/my_club_controller.dart';
import 'package:dirve_society/app/modules/profile/controllers/profile_controller.dart';
import 'package:dirve_society/app/modules/club/views/create_club_view.dart';
import 'package:dirve_society/common/widgets/custom_button.dart';
import 'package:dirve_society/common/widgets/profile_header_layout.dart';
import 'package:dirve_society/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/app_color/app_colors.dart';
import '../../../../common/app_images/app_images.dart';
import '../../../../common/app_text_style/styles.dart';
import '../../../../common/helper/group_card.dart';
import '../../../../common/size_box/custom_sizebox.dart';

class MyClubsView extends StatefulWidget {
  const MyClubsView({super.key});

  @override
  State<MyClubsView> createState() => _MyClubsViewState();
}

class _MyClubsViewState extends State<MyClubsView> {
  final MyClubController myClubController = Get.put(MyClubController());
  final ProfileController profileController =
      Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : Get.put(ProfileController());
  final MyJoiningClubController myJoiningClubController =
      Get.put(MyJoiningClubController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      myClubController.getMyClub();
      myJoiningClubController.getJoiningClub('approved');
      if (profileController.profileData.value == null) {
        profileController.fetchProfileData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final profile = profileController.profileData.value;
              return ProfileHeaderLayout(
                title: profile?.name ??
                    StorageUtil.getData(StorageUtil.profileName) ??
                    '',
                coverImageUrl: profile?.coverPhoto ??
                    StorageUtil.getData(StorageUtil.profileCoverPhoto),
                profileImageUrl: profile?.photoUrl ??
                    StorageUtil.getData(StorageUtil.profilePhotoUrl),
                onBack: Get.back,
                subtitle: profile?.bio ??
                    StorageUtil.getData(StorageUtil.profileBio) ??
                    '',
                ratingText:
                    '${profile?.avgRating ?? StorageUtil.getData(StorageUtil.profileAvgRating) ?? '0.0'}',
                pointsText:
                    '${profile?.scores ?? StorageUtil.getData(StorageUtil.profileScores) ?? '0'} Points',
              );
            }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Clubs',
                    style: h1.copyWith(fontSize: 20),
                  ),
                  CustomButton(
                    width: 160,
                    height: 38,
                    text: 'Create Club',
                    onPressed: () {
                      Get.to(() => CreateClubView());
                    },
                    imageAssetPath: AppImages.add,
                    iconColor: AppColors.white,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 200,
              child: GetBuilder<MyClubController>(builder: (controller) {
                if (myClubController.inProgress) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.myClubList == null ||
                    controller.myClubList!.isEmpty) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: Text('No Clubs Found')),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.myClubList?.length,
                  itemBuilder: (context, index) => SizedBox(
                    width: 160,
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GroupCard(
                        isOneButton: true,
                        acceptButton: () {},
                        joinClubBtuton: () {},
                        rejectedButton: () {},
                        ontap: () {
                          Get.to(() => ClubView(
                                name: controller.myClubList?[index].name ?? '',
                                isAuthor: true,
                                authorId:
                                    controller.myClubList![index].owner?.id ??
                                        '',
                                id: controller.myClubList?[index].id ?? '',
                              ));
                        },
                        imageUrl:
                            controller.myClubList?[index].profilePhoto ?? '',
                        title: controller.myClubList?[index].name ??
                            'Nissan R35 GTR',
                        memberCount:
                            '${controller.myClubList?[index].member ?? 0} Members',
                        isPublic: true,
                        isJoined: false,
                        showButton: false,
                      ),
                    ),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'My Join Clubs',
                style: h1.copyWith(fontSize: 20),
              ),
            ),
            SizedBox(
              height: 200,
              child: GetBuilder<MyJoiningClubController>(builder: (controller) {
                if (controller.inProgress) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.myJoiningClubList == null ||
                    controller.myJoiningClubList!.isEmpty) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: Text('No Clubs Found')),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.myJoiningClubList?.length,
                  itemBuilder: (context, index) => SizedBox(
                    width: 160,
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GroupCard(
                        isOneButton: true,
                        acceptButton: () {},
                        joinClubBtuton: () {},
                        rejectedButton: () {},
                        ontap: () {
                          Get.to(() => ClubView(
                                name: controller.myJoiningClubList![index]
                                        .reference?.name ??
                                    '',
                                isAuthor: false,
                                authorId: controller.myJoiningClubList![index]
                                        .reference?.owner ??
                                    '',
                                id: controller.myJoiningClubList![index]
                                        .reference?.id ??
                                    '',
                              ));
                        },
                        imageUrl: controller.myJoiningClubList![index].reference
                                ?.profilePhoto ??
                            '',
                        title: controller
                                .myJoiningClubList?[index].reference?.name ??
                            'Nissan R35 GTR',
                        memberCount:
                            '${controller.myJoiningClubList?[index].reference?.member ?? 0} Members',
                        isPublic: true,
                        isJoined: false,
                        showButton: false,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
