// ignore_for_file: avoid_print
import 'package:dirve_society/app/modules/home/controllers/feed/all_feed_controller.dart';
import 'package:dirve_society/app/modules/home/controllers/all_car_rating_controller.dart';
import 'package:dirve_society/app/modules/home/controllers/all_story_controller.dart';
import 'package:dirve_society/app/modules/home/controllers/feed/dis_react_controller.dart';
import 'package:dirve_society/app/modules/home/controllers/feed/react_controller.dart';
import 'package:dirve_society/app/modules/home/controllers/feed/save_post_controller.dart';
import 'package:dirve_society/app/modules/home/controllers/feed/un_saved_post_controller.dart';
import 'package:dirve_society/app/modules/home/views/comment_screen.dart';
import 'package:dirve_society/app/modules/home/views/create_story_screen.dart';
import 'package:dirve_society/app/modules/home/views/date_formatter.dart';
import 'package:dirve_society/app/modules/home/views/story_screen.dart';
import 'package:dirve_society/common/app_color/app_colors.dart';
import 'package:dirve_society/common/app_images/app_images.dart';
import 'package:dirve_society/common/helper/post_card.dart';
import 'package:dirve_society/common/helper/story_widget.dart';
import 'package:dirve_society/common/size_box/custom_sizebox.dart';
import 'package:dirve_society/common/widgets/custom_snackbar_widget.dart';
import 'package:dirve_society/common/widgets/circle_shimmer_widget.dart';
import 'package:dirve_society/common/widgets/feed_shimmer.dart';
import 'package:dirve_society/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final ReactPostController reactPostController =
      Get.put(ReactPostController());
  final DisReactPostController disReactPostController =
      Get.put(DisReactPostController());
  final SavePostController savePostController = Get.put(SavePostController());
  final UnSavedPostController unSavedPostController =
      Get.put(UnSavedPostController());
  final AllFeedController allFeedController = Get.put(AllFeedController());
  final AllCarRatingController allCarRatingController =
      Get.put(AllCarRatingController());

  final AllStoryController allStoryController = Get.put(AllStoryController());

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_loadMoreData);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      allFeedController.getAllFeed();
      allCarRatingController.getAllCarRating();
      allStoryController.getAllStory();
    });
  }

  void _loadMoreData() {
    if (scrollController.position.extentAfter < 500 &&
        !allFeedController.inProgress) {
      print('Load more data');
      allFeedController.getAllFeed();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> reactPost(String postId) async {
    print('Attempting to like post with ID: $postId');
    final bool isSuccess = await reactPostController.reactPost(postId);
    if (isSuccess) {
      int index = allFeedController.postList
          .indexWhere((post) => post.contentMeta?.id == postId);
      print('Index found: $index');
      if (index != -1) {
        int currentLikes =
            allFeedController.postList[index].contentMeta?.like ?? 0;
        print('Current likes: $currentLikes');
        allFeedController.updatePostLike(postId, true, currentLikes + 1);
        if (mounted) {
          //  showSnackBarMessage(context, 'Like successfully completed');
        }
      } else {
        print('Post not found for ID: $postId');
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            reactPostController.errorMessage ?? 'Failed to like', true);
      }
    }
  }

  Future<void> disReactPost(String postId) async {
    print('Attempting to dislike post with ID: $postId');
    final bool isSuccess = await disReactPostController.disReactPost(postId);
    if (isSuccess) {
      int index = allFeedController.postList
          .indexWhere((post) => post.contentMeta?.id == postId);
      print('Index found: $index');
      if (index != -1) {
        int currentLikes =
            allFeedController.postList[index].contentMeta?.like ?? 0;
        print('Current likes: $currentLikes');
        allFeedController.updatePostLike(
            postId, false, currentLikes > 0 ? currentLikes - 1 : 0);
        if (mounted) {
          // showSnackBarMessage(context, 'Dislike successfully completed');
        }
      } else {
        print('Post not found for ID: $postId');
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            disReactPostController.errorMessage ?? 'Failed to dislike', true);
      }
    }
  }

  Future<void> savePost(String userId, String contentId) async {
    print('Attempting to save post with ID: $contentId');
    final bool isSuccess =
        await savePostController.savePostF(userId, contentId);
    if (isSuccess) {
      allFeedController.updatePostSave(contentId, true);
      if (mounted) {
        // showSnackBarMessage(context, 'Post saved successfully');
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            savePostController.errorMessage ?? 'Failed to save post', true);
      }
    }
  }

  Future<void> unSavePost(String postId) async {
    print('Attempting to unsave post with ID: $postId');
    final bool isSuccess =
        await unSavedPostController.unSavePost(postId: postId);
    if (isSuccess) {
      allFeedController.updatePostUnSave(postId, false);
      if (mounted) {
        // showSnackBarMessage(context, 'Post unsaved successfully');
      }
    } else {
      if (mounted) {
        showSnackBarMessage(
            context,
            unSavedPostController.errorMessage ?? 'Failed to unsave post',
            true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.transparent,
          height: 90,
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: StorageUtil.getData(
                                      StorageUtil.profilePhotoUrl) !=
                                  null
                              ? NetworkImage(StorageUtil.getData(
                                  StorageUtil.profilePhotoUrl))
                              : AssetImage(AppImages.noImage),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => const AddStoryScreen());
                            },
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.black,
                              child: Icon(
                                Icons.add,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Text(
                      'My Story',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              GetBuilder<AllStoryController>(builder: (controller) {
                if (controller.inProgress) {
                  return CircleItemShimmerEffectWidget();
                } else if (controller.storData == null ||
                    controller.storData!.isEmpty) {
                  return SizedBox(height: 40, child: Center(child: Text('')));
                } else {
                  return Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.storData?.length,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            StoryWidget(
                              ontap: () {
                                Get.to(() => StoryScreen(
                                      userId: controller
                                              .storData![index].user?.userId ??
                                          '',
                                    ));
                              },
                              image: controller.storData![index].user?.stories
                                      .last.content ??
                                  '',
                            ),
                            Text(
                              controller.storData![index].user?.name ?? '',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
              }),
            ],
          ),
        ),
        sh12,
        Expanded(
          child: Obx(() {
            print(
                'Obx rebuild triggered with postList length: ${allFeedController.postList.length}');
            if (allFeedController.inProgress && allFeedController.page == 1) {
              return FeedItemShimmerEffectWidget();
            }
            if (allFeedController.postList.isEmpty) {
              return const Center(
                child: Text(
                  'No posts available',
                  style: TextStyle(color: AppColors.white),
                ),
              );
            }
            return ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.only(bottom: 30),
              itemCount: allFeedController.postList.length,
              itemBuilder: (context, index) {
                final feed = allFeedController.postList[index];
                final dateFormatter =
                    DateFormatter(feed.createdAt ?? DateTime.now());
                return feed.isHide == false
                    ? PostCard(
                        id: feed.author?.id ?? '',
                        profileImage: feed.author?.photoUrl ?? '',
                        clubName: feed.author?.name ?? '',
                        userName: feed.author?.name ?? 'Unknown',
                        contentPaths: feed.content,
                        description: feed.description ?? '',
                        hashtags: feed.tags.isNotEmpty ? feed.tags[0] : '',
                        date: dateFormatter.getRelativeTimeFormat(),
                        likes: feed.contentMeta?.like ?? 0,
                        comments: feed.contentMeta?.comment ?? 0,
                        isLiked: feed.isLiked ?? false,
                        isSaved: feed.isFavorite ?? false,
                        onProfileTap: () {
                          // Navigate to profile (implement as needed)
                        },
                        onMenuTap: () {
                          // Implement menu/bottom sheet (implement as needed)
                        },
                        onLikeTap: () {
                          print(
                              'Like tapped for post ID: ${feed.contentMeta?.id}');
                          feed.isLiked == true
                              ? disReactPost(feed.contentMeta?.id ?? '')
                              : reactPost(feed.contentMeta?.id ?? '');
                        },
                        onCommentTap: () {
                          Get.to(CommentScreen(
                            postId: feed.id ?? '',
                            postType: 'feed',
                            // onCommentPosted: (newCommentCount) {
                            //   allFeedController.updatePostComment(feed.id ?? '', newCommentCount);
                            // },
                          ));
                        },
                        onBookmarkTap: () {
                          print('Bookmark tapped for post ID: ${feed.id}');
                          feed.isFavorite == true
                              ? unSavePost(feed.id ?? '')
                              : savePost(
                                  StorageUtil.getData(StorageUtil.profileId) ??
                                      '',
                                  feed.id ?? '',
                                );
                        },
                      )
                    : Container();
              },
            );
          }),
        ),
      ],
    );
  }
}
