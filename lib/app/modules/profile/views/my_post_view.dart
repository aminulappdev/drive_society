import 'package:dirve_society/app/modules/club/views/create_post_screen.dart';
import 'package:dirve_society/app/modules/home/views/post_details_screen.dart';
import 'package:dirve_society/app/modules/profile/controllers/my_feed_controller.dart';
import 'package:dirve_society/app/modules/profile/controllers/profile_controller.dart';
import 'package:dirve_society/common/widgets/profile_header_layout.dart';
import 'package:dirve_society/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/app_color/app_colors.dart';
import '../../../../common/app_images/app_images.dart';
import '../../../../common/app_text_style/styles.dart';
 
class MyPostView extends StatefulWidget {
  const MyPostView({super.key});
 
  @override
  State<MyPostView> createState() => _MyPostViewState();
}

class _MyPostViewState extends State<MyPostView> {
  final MyFeedController myFeedController = Get.put(MyFeedController());
  final ProfileController profileController = Get.isRegistered<ProfileController>()
      ? Get.find<ProfileController>()
      : Get.put(ProfileController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      myFeedController.getMyFeed();
      if (profileController.profileData.value == null) {
        profileController.fetchProfileData();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            final profile = profileController.profileData.value;
            return ProfileHeaderLayout(
              title: profile?.name ?? StorageUtil.getData(StorageUtil.profileName) ?? '',
              coverImageUrl:
                  profile?.coverPhoto ?? StorageUtil.getData(StorageUtil.profileCoverPhoto),
              profileImageUrl:
                  profile?.photoUrl ?? StorageUtil.getData(StorageUtil.profilePhotoUrl),
              subtitle: profile?.bio ?? StorageUtil.getData(StorageUtil.profileBio) ?? '',
              onBack: Get.back,
              ratingText:
                  '${profile?.avgRating ?? StorageUtil.getData(StorageUtil.profileAvgRating) ?? '0.0'}',
              pointsText:
                  '${profile?.scores ?? StorageUtil.getData(StorageUtil.profileScores) ?? '0'} Points',
            );
          }),
         
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'My Post',
              style: h1.copyWith(fontSize: 20),
            ),
          ),
          GetBuilder<MyFeedController>(builder: (context) {
            if (myFeedController.inProgress) {
              return SizedBox(
                  height: 300,
                  child: const Center(child: CircularProgressIndicator()));
            }
            if (myFeedController.allFeedList == null ||
                myFeedController.allFeedList!.isEmpty) {
              return SizedBox(
                  height: 300,
                  child: const Center(child: Text('No Post Found')));
            }
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  padding: EdgeInsets.only(
                    top: 12,
                    bottom: 75,
                  ),
                  shrinkWrap: true,
                  //primary: false,
                  itemCount: myFeedController.allFeedList?.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    mainAxisExtent: 150,
                  ),
                  itemBuilder: (context, index) => ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () {
                        Get.to(() => PostDetailsScreen(
                              postId:
                                  myFeedController.allFeedList?[index].id ??
                                      '',
                            ));
                      },
                      child: _buildPostImages(
                        myFeedController.allFeedList![index].content,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: FloatingActionButton(
          onPressed: () {
            Get.to(() => CreatePostView());
          },
          backgroundColor: AppColors.darkRed,
          child: Icon(
            Icons.add,
            size: 32,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildPostImages(List<String> images) {
    if (images.isEmpty) {
      return Image.asset(
        AppImages.noImage,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }

    if (images.length == 1) {
      return _networkPostImage(images.first);
    }

    if (images.length == 2) {
      return Row(
        children: [
          Expanded(child: _networkPostImage(images[0])),
          const SizedBox(width: 2),
          Expanded(child: _networkPostImage(images[1])),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _networkPostImage(images[0]),
        ),
        const SizedBox(width: 2),
        Expanded(
          child: Column(
            children: [
              Expanded(child: _networkPostImage(images[1])),
              const SizedBox(height: 2),
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _networkPostImage(images[2]),
                    if (images.length > 3)
                      Container(
                        color: Colors.black54,
                        alignment: Alignment.center,
                        child: Text(
                          '+${images.length - 3}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _networkPostImage(String url) {
    return Image.network(
      url,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset(
        AppImages.noImage,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
