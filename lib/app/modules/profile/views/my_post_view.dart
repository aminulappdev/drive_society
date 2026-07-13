import 'package:dirve_society/app/modules/club/views/create_post_screen.dart';
import 'package:dirve_society/app/modules/home/views/post_details_screen.dart';
import 'package:dirve_society/app/modules/profile/controllers/my_feed_controller.dart';
import 'package:dirve_society/get_storage.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

import '../../../../common/app_color/app_colors.dart';
import '../../../../common/app_images/app_images.dart';
import '../../../../common/app_text_style/styles.dart';
import '../../../../common/size_box/custom_sizebox.dart';

class MyPostView extends StatefulWidget {
  const MyPostView({super.key});

  @override
  State<MyPostView> createState() => _MyPostViewState();
}

class _MyPostViewState extends State<MyPostView> {
  final MyFeedController myFeedController = Get.put(MyFeedController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      myFeedController.getMyFeed();
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
          Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child:
                        StorageUtil.getData(StorageUtil.profileCoverPhoto) !=
                                null
                            ? Image.network(
                                StorageUtil.getData(
                                    StorageUtil.profileCoverPhoto),
                                fit: BoxFit.cover,
                              )
                            : Image.asset(AppImages.noBanner)),
              ),
              Positioned(
                left: 20,
                top: 30,
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
                  backgroundImage: StorageUtil.getData(
                              StorageUtil.profilePhotoUrl) !=
                          null
                      ? NetworkImage(
                          StorageUtil.getData(StorageUtil.profilePhotoUrl))
                      : AssetImage(AppImages.noImage),
                ),
              ),
              Positioned(
                right: 20,
                left: Get.width * 0.32,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300]?.withOpacity(0.5),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          StorageUtil.getData(StorageUtil.profileName) ?? '',
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
                              StorageUtil.getData(StorageUtil.profileAvgRating)
                                  .toString(),
                              style: h3.copyWith(
                                color: AppColors.darkRed,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          sh40,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Descriptions',
                      style: h5.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.orange[600],
                      ),
                      child: Center(
                        child: Text(
                          '${StorageUtil.getData(StorageUtil.profileScores)} Points',
                          style: h6,
                        ),
                      ),
                    ),
                  ],
                ),
                sh5,
                ReadMoreText(
                  StorageUtil.getData(StorageUtil.profileBio) ?? '',
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
